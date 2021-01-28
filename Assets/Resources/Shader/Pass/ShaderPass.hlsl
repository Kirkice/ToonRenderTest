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
    float2 uv_Bump                          :   TEXCOORD1;
};

struct VertexOut_Shade
{ 
	float4 PosH                             :   SV_POSITION;
    float3 PosW                             :   TEXCOORD0;
    float3 NormalW                          :   TEXCOORD1;
    float4 Color                            :   TEXCOORD2;
    float2 uv                               :   TEXCOORD3;
    float2 uv_Bump                          :   TEXCOORD4;
    float4 TW1                              :   TEXCOORD5;
    float4 TW2                              :   TEXCOORD6;
    float4 TW3                              :   TEXCOORD7;
};


//-----------------------------------------
//-------------  BODY  --------------------
//-----------------------------------------
VertexOut_Shade VS_BODY(VertexIn_Shade vin)
{
    VertexOut_Shade                             vout;
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
//-------------  EYE  --------------------
//-----------------------------------------
VertexOut_Shade VS_EYE(VertexIn_Shade vin)
{
    VertexOut_Shade                             vout;   
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    vout.uv                                 =   vin.texcoord0;
    return vout;
}

float4 PS_EYE(VertexOut_Shade pin) : SV_Target
{
//-------------  XMFLOAT4 VECTOR --------------
    float4  mainColor, outColor;

//-------------  XMFLOAT3 VECTOR  -------------
    float3  N, L, V, H;

//-------------  SET DIRECTION  ---------------
    GET_DIRECTION_PARAMES(pin.NormalW, pin.PosW, N, L, V);

//-------------  SET MAIN COLOR  --------------
    SET_FACE_COLOR(mainColor, outColor, pin.uv);

//-------------  SET EYE HSV  --------------
    SET_EYE_HSV(mainColor, outColor);

//--------------SET EYE REFLECTION----------------
    SET_EYE_REFLECTION(V, N, outColor);

    return  outColor;
}
//-----------------------------------------
//-------------  HAIR  --------------------
//-----------------------------------------
VertexOut_Shade VS_HAIR(VertexIn_Shade vin)
{
    VertexOut_Shade                             vout;
    vout.PosH                               =   TransformObjectToHClip(vin.PosL.xyz);
    vout.NormalW                            =   TransformObjectToWorldNormal(vin.NormalL);
    float3 TangentW                         =   TransformObjectToWorldDir(vin.TangentL.xyz);
    float3 BinormalW                        =   cross(vout.NormalW,TangentW) * vin.TangentL.w;
    vout.PosW                               =   mul(unity_ObjectToWorld, vin.PosL);
    vout.uv                                 =   vin.texcoord0;
    vout.uv_Bump                            =   vin.uv_Bump;


    vout.TW1                                = float4(TangentW.x, BinormalW.x, vout.NormalW.x, vout.PosW.x);
    vout.TW2                                = float4(TangentW.y, BinormalW.y, vout.NormalW.y, vout.PosW.y);
    vout.TW3                                = float4(TangentW.z, BinormalW.z, vout.NormalW.z, vout.PosW.z);
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

//-------------  GET NORMAL TEXTURE  ----------
    SET_NORMAL_TEXTURE(pin.TW1, pin.TW2, pin.TW3, pin.uv_Bump, N);
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