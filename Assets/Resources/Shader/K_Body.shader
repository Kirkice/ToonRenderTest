Shader "K-Toon/Body"
{
    Properties
    {
        _MainTexture    ("Main Texture",    2D)             = "white"{}
        _OutlineWidth   ("Outline Width",   Range(0,1))     = 0.1
        _OutlineColor   ("Outline Color",   color)          = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalRenderPipeline" }

        HLSLINCLUDE
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
            #pragma vertex VS_BODY
            #pragma fragment PS_BODY
            ENDHLSL
        }
    }
}
