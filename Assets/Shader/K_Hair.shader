Shader "K-Toon/Hair"
{
    Properties
    {
        [Main(g1,_,2)]  _group1         ("Main Settings",           float)          = 1 
        [Sub(g1)]       _MainColor      ("Main Color",              color)          = (1,1,1,1)
        [Sub(g1)]       _MainTex        ("Main Texture",            2D)             = "white"{}

        [Main(g2,_,2)]  _group2         ("OutLine Settings",        float)          = 1
        [Sub(g2)]       _OutlineWidth   ("Outline Width",           Range(0,1))     = 0.1
        [Sub(g2)]       _OutlineColor   ("Outline Color",           color)          = (1,1,1,1)

        [Main(g3,_,2)]  _group3         ("Shadow Set",              float)          = 1
        [Sub(g3)]       _F_ShadowColor  ("First SD Color",          color)          = (1,1,1,1)
        [Sub(g3)]       _ShadowStep     ("Shadow Step",             Range(0,1))     = 0.8
        [Sub(g3)]       _ShadowFeather  ("Shadow Feather",          Range(0.001,1)) = 0.3
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
            #pragma vertex VS_Hair
            #pragma fragment PS_Hair
            ENDHLSL
        }
    }
}
