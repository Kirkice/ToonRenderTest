Shader "K-Toon/Body"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalRenderPipeline" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Pass/OutLinePass.hlsl"
        ENDHLSL

        Pass
        {
            Name "OutLine"
            Tags { "LightMode" = "UniversalForward"}
            HLSLPROGRAM
            #pragma vertex VS
            #pragma fragment PS
            ENDHLSL
        }
    }
}
