//***************************************************************************************
// ShaderPass.hlsl by Kirk . 2020
//
// Shader Pass Part, ToonShader
//***************************************************************************************
#ifndef Include_ShaderPass
#define Include_ShaderPass

#include "./Function/ShaderUtil.hlsl"

struct VertexIn_Shade
{
	float4 PosL                             :   POSITION;
    float3 NormalL                          :   NORMAL;
    float4 TangentL                         :   TANGENT;
    float4 color                            :   COLOR;
    float2 texcoord0                        :   TEXCOORD0;
};

struct VertexOut_Shade
{
	float4 PosH                             :   SV_POSITION;
    float3 PosW                             :   TEXCOORD0;
    float3 NormalW                          :   TEXCOORD1;
    float4 Color                            :   TEXCOORD2;
    float2 uv                               :   TEXCOORD3;
};

//-----------------------   Body   ------------------------
VertexOut_Shade VS_Body(VertexIn_Shade vin)
{
    VertexOut_Shade vout                    =   (VertexOut)0.0f;
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    return vout;
}

float4 PS_Body(VertexOut_Shade pin) : SV_Target
{
    half4  outColor                         =   half4(1,1,1,1);
    return outColor;
}
//-----------------------   Hair   ------------------------
VertexOut_Shade VS_Hair(VertexIn_Shade vin)
{
    VertexOut_Shade vout                    =   (VertexOut)0.0f;
    vout.NormalW                            =   TransformObjectToWorldNormal(vin.NormalL.xyz);
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    vout.PosW                               =   TransformObjectToWorld(vin.PosL);
    vout.uv                                 =   vin.texcoord0;
    return vout;
}

float4 PS_Hair(VertexOut_Shade pin) : SV_Target
{
    half4 mainColor,outColor;
    half3 N,V,L;
//--------------- 获取方向参数 ----------------
    GetNormalizeDir(pin.NormalW, pin.PosW, N, L, V);

//------------- 获取头发贴图参数 --------------
    GetHairTexParames(pin.uv, outColor, mainColor);

//---------------- 获取头发颜色 -----------------
    GetHairColor(N, L, mainColor, outColor);
    return outColor;
}
#endif