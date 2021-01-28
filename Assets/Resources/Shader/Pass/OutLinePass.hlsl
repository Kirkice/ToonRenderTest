/***********************************************************************************************
 ***                                T O O N ---  S H A D E R                                 ***
 ***********************************************************************************************
 *                                                                                             *
 *                                    Doc: OutLine.hlsl                                        *
 *                                                                                             *
 *                                    Programmer : Kirk                                        *
 *                                                                                             *
 *                                      Date : 2021/1/20                                       *
 *                                                                                             *
 *---------------------------------------------------------------------------------------------*
 * Functions List:                                                                             *
 *   1.0 COMMON OUTLINE                                                                        *
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

#ifndef Include_OutLinePass
#define Include_OutLinePass

#include "./Function/ShaderUtil.hlsl"

struct VertexIn
{
	float4 PosL                             :   POSITION;
    float3 NormalL                          :   NORMAL;
    float4 TangentL                         :   TANGENT;
    float4 color                            :   COLOR;
    float2 texcoord0                        :   TEXCOORD0;
};

struct VertexOut
{
	float4 PosH                             :   SV_POSITION;
    float3 PosW                             :   TEXCOORD0;
    float3 NormalW                          :   TEXCOORD1;
    float4 Color                            :   TEXCOORD2;
    float2 uv                               :   TEXCOORD3;
};

VertexOut VS(VertexIn vin)
{
    VertexOut vout                          =   (VertexOut)0.0f;

    float3 tangentW                         =   mul((float3x3)UNITY_MATRIX_IT_MV, vin.TangentL);
    vout.PosW                               =   mul(unity_ObjectToWorld, vin.PosL);
    vout.PosH                               =   mul(UNITY_MATRIX_MV, vin.PosL);

    vout.PosH.xy                            =   vout.PosH.xy + normalize(tangentW).xy * _OutlineWidth * 0.1;
    vout.PosH                               =   mul(UNITY_MATRIX_P, vout.PosH);

    vout.Color                              =   _OutlineColor;
    vout.uv                                 =   vin.texcoord0;

    return vout;
}

float4 PS(VertexOut pin) : SV_Target
{
    half4  outColor                         =   pin.Color;
    return outColor;
}

#endif