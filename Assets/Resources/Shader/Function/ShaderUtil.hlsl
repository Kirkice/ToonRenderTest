/***********************************************************************************************
 ***                                T O O N ---  S H A D E R                                 ***
 ***********************************************************************************************
 *                                                                                             *
 *                                    Doc: ShaderUtil.hlsl                                     *
 *                                                                                             *
 *                                    Programmer : Kirk                                        *
 *                                                                                             *
 *                                      Date : 2021/1/20                                       *
 *                                                                                             *
 *---------------------------------------------------------------------------------------------*
 * Functions List:                                                                             *
 *   1.0 Get_HNoL                                                                              *
 *   2.0 Get_H                                                                                 *
 *   3.0 GET_DIRECTION_PARAMES                                                                 *
 *   4.0 GET_HAIR_COLOR                                                                        *
 *   5.0 SET_HAIR_SHADOW                                                                       *
 *   6.0 SET_HAIR_RIMLIGHT                                                        			   *
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


#ifndef Include_ShaderUtil
#define Include_ShaderUtil

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl" 
#include "./Input/InputParames.hlsl"

//-------------  获取HNoL  --------------
    void Get_HNoL(float3 N, float3 L, inout float HNoL)
    {
        HNoL                                            = saturate(dot(N, L) * 0.5 + 0.5);
    }

//-------------  获取H  --------------
    void Get_H(float3 V, float3 L, inout float3 H)
    {
        H                                               = normalize(V + L);
    }

//-------------  设置方向参数  --------------
    void GET_DIRECTION_PARAMES(float3 normal, float3 posW, inout float3 N, inout float3 L, inout float3 V)
    {
        N                                               = normalize(normal);
        Light mainLight                                 = GetMainLight();
        L                                               = normalize(mainLight.direction);
        V                                               = normalize(_WorldSpaceCameraPos.xyz - posW.xyz);
    }
//-------------  设置头发颜色参数  --------------
    void GET_HAIR_COLOR(inout float4 mainColor, inout float4 ilmColor,float2 uv, inout float4 outColor)
    {
        mainColor                                       =  tex2D(_MainTexture, TRANSFORM_TEX(uv, _MainTexture)) * _MainColor;
        ilmColor                                        =  tex2D(_ILMTexture, TRANSFORM_TEX(uv, _ILMTexture));
        outColor                                        =  lerp(_OutlineColor, mainColor, mainColor.a);
    }

//-------------  设置头发阴影  --------------    
    void SET_HAIR_SHADOW(float3 N, float3 L_1st, float3 L_2st, inout float4 outColor , inout float Set_ShadowMask_1st)
    {
        float HNoL_1st                                  = saturate(dot(N, L_1st) * 0.5 + 0.5);
        Set_ShadowMask_1st                              = 1 - saturate(1 - (HNoL_1st - (_FirstStep - _FirstFeather)) / _FirstFeather);

        float Set_EdgeMask                              = saturate(1 - (HNoL_1st - (_EdgeStep - _EdgeFeather)) / _EdgeFeather);

        float HNoL_2st                                  = saturate(dot(N, L_2st) * 0.5 + 0.5);
        float Set_ShadowMask_2st                        = saturate(1 - (HNoL_2st - (_SecondStep - _SecondFeather)) / _SecondFeather);
        //---------------固有色-------------------
        float4 mainColor                                = outColor;

        outColor                                        = lerp(outColor, _ShadowEdgeColor * outColor, Set_ShadowMask_1st * Set_EdgeMask );

        outColor                                        = lerp(outColor, outColor * _FirstShadowColor + outColor * 0.2, Set_ShadowMask_1st);
        outColor                                        = lerp(outColor, mainColor * _SecondShadowColor + mainColor * 0.4, Set_ShadowMask_2st);
    }

//------------------  设置头发边缘光  ---------------------
    void SET_HAIR_RIMLIGHT(float3 V, float3 N, float Set_ShadowMask_1st,inout float4 outColor)
    {
        float NoV                                       = saturate(dot(N, V));
        float rimFactor                                 = pow(1.0 - max(0,NoV),1);
        float Set_RimLightMask                          = saturate(((rimFactor - (_RimRangeStep -_RimFeather)) * - 1.0 ) / (_RimRangeStep - (_RimRangeStep-_RimFeather)) + 1);
        _RimLightColor                                  = lerp(_RimLightColor, _RimLightColor * 0.375, Set_ShadowMask_1st);
        outColor                                       += lerp(_RimLightColor, float4(0,0,0,0), Set_RimLightMask);
    }

//------------------  设置面部固有色  ---------------------
void SET_FACE_COLOR(inout float4 mainColor, inout float4 outColor, float2 uv)
{
        mainColor                                       =  tex2D(_MainTexture, TRANSFORM_TEX(uv, _MainTexture)) * _MainColor;
        outColor                                        =  float4(mainColor.rgb,1);
}

// //-------------  设置头发高光  --------------    
//     void SET_HAIR_HIGHLIGHT(float4 ilmColor, float3 N, float3 H, inout float4 outColor)
//     {
//         float       _ShadowStep                         =   saturate(1 - (H - (_1st2nd_Light_Threshold - _1st2nd_Light_Feather)) / _1st2nd_Light_Feather);
//                     _ShadowStep                         =   max(ilmColor.g, _ShadowStep);
                    
//         float3      NV                                  =   mul(UNITY_MATRIX_V, N);
//         float3      HV                                  =   mul(UNITY_MATRIX_V, H);
//         float       NoH                                 =   dot(normalize(NV.xz), normalize(HV.xz));
//         NoH                                             =   pow(NoH, 6) * _LightWidth;
//         NoH                                             =   pow(NoH, 1 / _LightLength);

//         float       lightFeather                        =   _1st2nd_Light_Feather * NoH;
//         float       lightStepMax                        =   saturate(1 - NoH + lightFeather);
//         float       lightStepMin                        =   saturate(1 - NoH - lightFeather);

//         float3      highlightRGB_H                      =   smoothstep(lightStepMin, lightStepMax, clamp(ilmColor.r, 0, 0.99)) * _1st_HighColor_Step.rgb;
//         float3      highlightRGB_L                      =   smoothstep(_1st2nd_Light_Threshold, 1, ilmColor.r) * _2st_HighColor_Step.rgb;
//         float3      HighLightMapRGB                     =   (highlightRGB_H + highlightRGB_L) * ilmColor.g;

//                     outColor.rgb                        =   outColor.rgb * (1 - ilmColor.r) + HighLightMapRGB;
//     }

//-------------  设置法线贴图  -------------- 
void SET_NORMAL_TEXTURE(float4 TW1, float4 TW2, float4 TW3, float2 uv_Bump, inout float3 N)
{
    float3x3 TW                                             =   float3x3(TW1.xyz,TW2.xyz,TW3.xyz);
    float4 normal                                           =   SAMPLE_TEXTURE2D(_NormalTexture, sampler_NormalTexture, uv_Bump);        //对法线纹理采样
    float3 bump                                             =   UnpackNormal(normal); 
    bump.xy                                                *=   1.5;
    bump.z                                                  =   sqrt(1.0 - saturate(dot(bump.xy,bump.xy)));
    bump                                                    =   mul(TW, bump);
    N                                                       =   bump;
}

//-------------  COLORFUL  -------------- 
half3 HSVtoRGB(half3 c)
{
	half4 K                                                 =   half4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	half3 p                                                 =   abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
	return                                                  c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
}

half3 RGBtoHSV(half3 c)
{
	half4 K                                                 =   half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	half4 p                                                 =   lerp(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
	half4 q                                                 =   lerp(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));

	half d                                                  =   q.x - min(q.w, q.y);
	half e                                                  =   1.0e-10;

	return                                                  half3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

//-------------  HSV调节  -------------- 
void SET_EYE_HSV(float4 mainColor, inout float4 outColor)
{
    float EYE_MASK                                          =   (1 - saturate(step(mainColor.a, 0.2))) * saturate(step(mainColor.a, 0.5));
    float4 OTHER_PART                                       =   outColor * (1 - EYE_MASK);
    float4 EYE_PART                                         =   outColor * EYE_MASK;

    float3 HSV                                              =   RGBtoHSV(EYE_PART.rgb);
    HSV.r                                                  +=   _HueOffset;
    HSV.g                                                  +=   _SaturationOffset;
    HSV.b                                                  +=   _ValueOffset;
    EYE_PART.rgb                                            =   HSVtoRGB(HSV.rgb);

    outColor                                                =   OTHER_PART + EYE_PART;
}

void SET_EYE_REFLECTION(float3 V, float3 N, inout float4 outColor)
{
    float3 reflectVector                                    = reflect(-V, N);
    float3 reflection                                       = texCUBE(_Env,reflectVector);
    // outColor.rgb                                            = reflection;
}
#endif


//  1st shadow 0.609054973831573     0.6527255587821294  0.8018866947871355
//  edge shadow 0.9000000892500029  1   0.913385833886168