/***********************************************************************************************
 ***                                T O O N ---  S H A D E R                                 ***
 ***********************************************************************************************
 *                                                                                             *
 *                                    Doc: K_Hair.shader                                       *
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

Shader "K-Toon/Hair"
{
    Properties
    {
        [Main(g1,_,2)]  _group1                     ("基础设置",             float)          = 1 
        [Sub(g1)][HDR]  _MainColor                  ("Main Color",          Color)          = (1,1,1,1)
        [Sub(g1)]       _MainTexture                ("Main Texture",        2D)             = "white"{}
        // [Sub(g1)]       _ILMTexture                 ("ILM Texture",         2D)             = "white"{}

        [Main(g2,_,2)]  _group2                     ("外勾边设置",           float)          = 1
        [Sub(g2)]       _OutlineWidth               ("Outline Width",       Range(0,1))     = 0.1
        [Sub(g2)]       _OutlineColor               ("Outline Color",       color)          = (1,1,1,1)

        [Main(g3,_,2)]  _group3                     ("阴影设置",             float)          = 1
        [Sub(g3)]       _FirstShadowColor           ("1st_Shadow Color",    Color)          = (1,1,1,1)
        [Sub(g3)]       _FirstStep                  ("1st_Shadow Step",     Range(0,1))     = 0.5
        [Sub(g3)]       _FirstFeather               ("1st_Shadow Feather",  Range(0,1))     = 0

        [Sub(g3)][HDR]  _ShadowEdgeColor            ("ShadowEdge Color",    Color)          = (1,1,1,1)
        [Sub(g3)]       _EdgeStep                   ("Edge       Step",     Range(0,1))     = 0.5
        [Sub(g3)]       _EdgeFeather                ("Edge       Feather",  Range(0,1))     = 0

        [Sub(g3)]       _SecondShadowColor          ("2st_Shadow Color",    Color)          = (1,1,1,1)
        [Sub(g3)]       _SecondStep                 ("2st_Shadow Step",     Range(0,1))     = 0.5
        [Sub(g3)]       _SecondFeather              ("2st_Shadow Feather",  Range(0,1))     = 0


        [Main(g4,_,2)]  _group4                     ("边缘光设置",           float)          = 1
        [Sub(g4)]       _RimLightColor              ("RimLight Color",      Color)          = (1,1,1,1) 
        [Sub(g4)]       _RimRangeStep               ("Rim Range Step",      Range(0,1))     = 0.5
        [Sub(g4)]       _RimFeather                 ("Rim   Feather",       Range(0,1))     = 0.5


        // [Main(g4,_,2)]  _group6                     ("高光设置",             float)          = 1
        // [Sub(g4)]       _SPEC_Strength              ("Spec Scale",          Range(0,1))     = 0.5
        // [Sub(g4)]       _SPEC_COLOR                 ("Spec Color",          Color)          = (1,1,1,1) 
        // [Sub(g4)]       _1st_HighColor_Step         ("1st_HighColor_Step",  Color)          = (0.3, 0.3, 0.3, 1)
        // [Sub(g4)]       _2st_HighColor_Step         ("2st_HighColor_Step",  Color)          = (0.05, 0.05, 0.05, 1)
        // [Sub(g4)]       _LightWidth                 ("Light Width",         Range(0, 1))    = 0.9
        // [Sub(g4)]       _LightLength                ("Light Length",        Range(0, 1))    = 0.5
        // [Sub(g4)]       _1st2nd_Light_Feather       ("1/2_Light_Feather",   Range(0, 0.5))  = 0.2
        // [Sub(g4)]       _1st2nd_Light_Threshold     ("1/2_Light_Threshold", Range(0, 0.9))  = 0.1
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
            #pragma vertex VS_HAIR
            #pragma fragment PS_HAIR
            ENDHLSL
        }
    }
}
