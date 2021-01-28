/***********************************************************************************************
 ***                                T O O N ---  S H A D E R                                 ***
 ***********************************************************************************************
 *                                                                                             *
 *                                    Doc: ShaderPass.hlsl                                     *
 *                                                                                             *
 *                                    Programmer : Kirk                                        *
 *                                                                                             *
 *                                      Date : 2021/1/20                                       *
 *                                                                                             *
 *---------------------------------------------------------------------------------------------*
 * Functions List:                                                                             *
 *   1.0 BODY                                                                                  *
 *   2.0 HAIR                                                                                  *
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

#ifndef Include_ShaderPass
#define Include_ShaderPass

#include "./Function/ShaderUtil.hlsl"
//-----------------------------------------
//-------------  VERTEX_SET  --------------
//-----------------------------------------

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


//-----------------------------------------
//-------------  BODY  --------------------
//-----------------------------------------
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

//-----------------------------------------
//-------------  HAIR  --------------------
//-----------------------------------------
VertexOut_Shade VS_FACE(VertexIn_Shade vin)
{
    VertexOut_Shade vout                    =   (VertexOut)0.0f;
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    vout.uv                                 =   vin.texcoord0;
    return vout;
}

float4 PS_FACE(VertexOut_Shade pin) : SV_Target
{
//-------------  XMFLOAT4 VECTOR --------------
    float4  mainColor, outColor;

//-------------  SET MAIN COLOR  --------------
    SET_FACE_COLOR(mainColor, outColor, pin.uv);

    return  outColor;
}
//-----------------------------------------
//-------------  HAIR  --------------------
//-----------------------------------------
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
//-------------  XMFLOAT4 VECTOR --------------
    float4  mainColor, ilmColor, outColor;

//-------------  XMFLOAT3 VECTOR  -------------
    float3  N, L, V, H;

//-------------  XMFLOAT  ---------------------
    float   HNoL, Set_ShadowMask_1st;

//-------------  SET DIRECTION  ---------------
    GET_DIRECTION_PARAMES(pin.NormalW, pin.PosW, N, L, V);

//-------------  SET MAIN COLOR  --------------
    GET_HAIR_COLOR(mainColor, ilmColor, pin.uv, outColor);

//-------------  GET HNoL  --------------------
    Get_HNoL(N, L, HNoL);

//-------------  GET H  -----------------------
    Get_H(V, L, H);

//-------------  SET SHADOW  ------------------  
    SET_HAIR_SHADOW(N, _HairFirstLightDirection, _HairSecondLightDirection, outColor, Set_ShadowMask_1st);

//-------------  SET RIMLIGHT  ----------------  
    SET_HAIR_RIMLIGHT(V, N, Set_ShadowMask_1st, outColor);

//-------------  设置头发高光  -----------------
    // SET_HAIR_HIGHLIGHT(ilmColor, N, H, outColor);
    
    return  outColor;
}

#endif