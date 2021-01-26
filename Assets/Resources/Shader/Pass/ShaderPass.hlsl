//***************************************************************************************
// ShaderPass.hlsl by Kirk . 2020
//
// Shader Pass Part, ToonShader
//***************************************************************************************
#ifndef Include_ShaderPass
#define Include_ShaderPass

#include "./Function/ShaderUtil.hlsl"

//-------------  VERTEX_SET  --------------
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

//-------------  BODY  --------------
VertexOut_Shade VS_BODY(VertexIn_Shade vin)
{
    VertexOut_Shade vout                    =   (VertexOut)0.0f;
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    vout.uv                                 =   vin.texcoord0;
    return vout;
}

float4 PS_BODY(VertexOut_Shade pin) : SV_Target
{
    float4  outColor                        =   tex2D(_MainTexture,TRANSFORM_TEX(pin.uv,_MainTexture));
    return  outColor;
}

//-------------  HAIR  --------------
VertexOut_Shade VS_HAIR(VertexIn_Shade vin)
{
    VertexOut_Shade vout                    =   (VertexOut)0.0f;
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    vout.NormalW                            =   TransformObjectToWorldNormal(vin.NormalL);
    vout.PosW                               =   mul(unity_ObjectToWorld, vin.PosL);
    vout.uv                                 =   vin.texcoord0;
    return vout;
}

float4 PS_HAIR(VertexOut_Shade pin) : SV_Target
{
//-------------  COLOR参数  --------------
    float4  mainColor, ilmColor, outColor;
//-------------  DIRECTION参数  --------------
    float3  N, L, V, H;
//-------------  需要用到的参数  --------------
    float   HNoL;
//-------------  设置方向参数  --------------
    GET_DIRECTION_PARAMES(pin.NormalW, pin.PosW, N, L, V);
//-------------  设置头发颜色参数  --------------
    GET_HAIR_COLOR(mainColor, ilmColor, pin.uv, outColor);
//-------------  获取HNoL  --------------
    Get_HNoL(N, L, HNoL);
//----------------  获取H  -----------------
    Get_H(V, L, H);
//-------------  设置头发阴影  --------------    
    // SET_HAIR_SHADOW(mainColor, ilmColor, outColor);
//-------------  设置头发高光  --------------  
    SET_HAIR_HIGHLIGHT(ilmColor, N, H, outColor);
    
    return  outColor;
}

#endif