/***********************************************************************************************
 ***                                T O O N ---  S H A D E R                                 ***
 ***********************************************************************************************
 *                                                                                             *
 *                                    Doc: InputParames.hlsl                                   *
 *                                                                                             *
 *                                    Programmer : Kirk                                        *
 *                                                                                             *
 *                                      Date : 2021/1/20                                       *
 *                                                                                             *
 *---------------------------------------------------------------------------------------------*
 * Functions List:                                                                             *
 *   1.0 Textures                                                                              *
 *   2.0 OUTLINE                                                                               *
 *   3.0 SHADOW                                                                                *
 *   4.0 RIMLIGHT                                                                              *
 *   5.0 SPEC                                                                                  *
 *   6.0 LIGHT                                                                                 *
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

#ifndef Include_INPUT_PARAMES
#define Include_INPUT_PARAMES

//-------------  Textures  --------------
uniform         sampler2D   _MainTexture;
uniform         sampler2D   _ILMTexture;
uniform         sampler2D   _NormalTexture;

CBUFFER_START(UnityPerMaterial)

//-------------  OUTLINE  --------------
    uniform     float       _OutlineWidth;
    uniform     float4      _OutlineColor;

//-------------  MAINTEX  --------------
    uniform     float4      _MainTexture_ST;
    uniform     float4      _MainColor;

//-------------  ILMTEX  ---------------
    uniform     float4      _ILMTexture_ST;

//-------------  NORAMLTEX  -------------
    uniform     float4      _NormalTexture_ST;

//-------------  SHADOW  ---------------
    uniform     float4      _FirstShadowColor;
    uniform     float4      _SecondShadowColor;
    uniform     float4      _ShadowEdgeColor;

    uniform     float       _FirstStep;
    uniform     float       _FirstFeather;

    uniform     float       _SecondStep;
    uniform     float       _SecondFeather;

    uniform     float       _EdgeStep;
    uniform     float       _EdgeFeather;

    uniform     float4      _1st_HighColor_Step;
    uniform     float4      _2st_HighColor_Step;
    uniform     float       _1st2nd_Light_Feather;
    uniform     float       _1st2nd_Light_Threshold;
//-------------  RIMLIGHT  ---------------
    uniform     float       _RimRangeStep;
    uniform     float       _RimFeather;
    uniform     float4      _RimLightColor;
//-------------  SPEC  ---------------
    uniform     float       _SPEC_Strength;
    uniform     float4      _SPEC_COLOR;
    uniform     float       _LightWidth;
    uniform     float       _LightLength;

//--------------  LIGHT  --------------------
    uniform     float3      _HairFirstLightDirection;
    uniform     float3      _HairSecondLightDirection;

CBUFFER_END

#endif