//***************************************************************************************
// ShaderPass.hlsl by Kirk . 2020
//
// Shader Pass Part, ToonShader
//***************************************************************************************
#ifndef Include_ShaderPass
#define Include_ShaderPass

#include "./Function/ShaderUtil.hlsl"

struct VertexIn_Body
{
	float4 PosL                             :   POSITION;
    float3 NormalL                          :   NORMAL;
    float4 TangentL                         :   TANGENT;
    float4 color                            :   COLOR;
    float2 texcoord0                        :   TEXCOORD0;
};

struct VertexOut_Body
{
	float4 PosH                             :   SV_POSITION;
    float3 PosW                             :   TEXCOORD0;
    float3 NormalW                          :   TEXCOORD1;
    float4 Color                            :   TEXCOORD2;
    float2 uv                               :   TEXCOORD3;
};

VertexOut VS_Body(VertexIn vin)
{
    VertexOut vout                          =   (VertexOut)0.0f;
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    return vout;
}

float4 PS_Body(VertexOut pin) : SV_Target
{
    half4  outColor                         =   half4(1,1,1,1);
    return outColor;
}

#endif