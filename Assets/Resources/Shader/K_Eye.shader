/***********************************************************************************************
 ***                                T O O N ---  S H A D E R                                 ***
 ***********************************************************************************************
 *                                                                                             *
 *                                    Doc: K_Body.shader                                       *
 *                                                                                             *
 *                                    Programmer : Kirk                                        *
 *                                                                                             *
 *                                      Date : 2021/1/20                                       *
 *                                                                                             *
 *---------------------------------------------------------------------------------------------*
 * Functions List:                                                                             *
 *   1.0 OutLine PASS                                                                          *
 *   2.0 Forward PASS                                                                          *
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

Shader "K-Toon/Eye"
{
    Properties
    {
        [Main(g1,_,2)]  _group1                     ("基础设置",             float)          = 1 
        [Sub(g1)]       _MainColor                  ("Main Color",          Color)          = (1,1,1,1)
        [Sub(g1)]       _MainTexture                ("Main Texture",        2D)             = "white"{}
        [Sub(g1)]       _Env                        ("Cube Map",            Cube)           = "white"{}

        [Main(g2,_,2)]  _group2                     ("HSV设置",             float)          = 1
        [Sub(g2)]       _HueOffset                  ("Hue Offset",          Range(0,1))     = 0
        [Sub(g2)]       _SaturationOffset           ("Saturat Offset",      Range(-1,1))    = 0.3
        [Sub(g2)]       _ValueOffset                ("Value Offset",        Range(-1,1))    = 0.15
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalRenderPipeline" }

        HLSLINCLUDE
        #include "Pass/ShaderPass.hlsl"
        ENDHLSL

        Pass
        {
            Cull Back
            Name "Forward"
            Tags { "LightMode" = "UniversalForward"}
            HLSLPROGRAM
            #pragma vertex VS_EYE
            #pragma fragment PS_EYE
            ENDHLSL
        }
    }
}
