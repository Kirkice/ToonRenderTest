Shader "K-Toon/Hair"
{
    Properties
    {
        _MainTexture    ("Main Texture",    2D)             = "white"{}
        _MainColor      ("Main Color",      Color)          = (1,1,1,1)
        _ILMTexture     ("ILM Texture",     2D)             = "white"{}
        _FixShadowColor ("FShadow Color",   Color)          = (1,1,1,1)
        _OutlineWidth   ("Outline Width",   Range(0,1))     = 0.1
        _OutlineColor   ("Outline Color",   color)          = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalRenderPipeline" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Pass/OutLinePass.hlsl"
        #include "Pass/ShaderPass.hlsl"
        ENDHLSL

        Pass
        {
            Cull Front
            Name "OutLine"
            HLSLPROGRAM
            #pragma vertex VS
            #pragma fragment PS
            ENDHLSL
        }

        Pass
        {
            Cull Back
            Name "Forward"
            Tags { "LightMode" = "UniversalForward"}
            HLSLPROGRAM
            #pragma vertex VS_HAIR
            #pragma fragment PS_HAIR
            ENDHLSL
        }
    }
}
