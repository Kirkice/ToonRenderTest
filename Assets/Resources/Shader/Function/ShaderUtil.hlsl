//------------- Function --------------
//-------------  Kirk  --------------
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
        outColor                                        =  mainColor;
    }

//-------------  设置头发阴影  --------------    
    void SET_HAIR_SHADOW(float4 mainColor, float4 ilmColor, inout float4 outColor)
    {
        float       fixShadowArea                       =  step(ilmColor.g,0.01);
        float       HNoLArea                            =  1 - fixShadowArea;
                    outColor                            =  mainColor;
    }

//-------------  设置头发高光  --------------    
    void SET_HAIR_HIGHLIGHT(float4 ilmColor, float3 N, float3 H, inout float4 outColor)
    {
        float       _ShadowStep                         =   saturate(1 - (H - (_1st2nd_Light_Threshold - _1st2nd_Light_Feather)) / _1st2nd_Light_Feather);
                    _ShadowStep                         =   max(ilmColor.g, _ShadowStep);
                    
        float3      NV                                  =   mul(UNITY_MATRIX_V, N);
        float3      HV                                  =   mul(UNITY_MATRIX_V, H);
        float       NoH                                 =   dot(normalize(NV.xz), normalize(HV.xz));
        NoH                                             =   pow(NoH, 6) * _LightWidth;
        NoH                                             =   pow(NoH, 1 / _LightLength);

        float       lightFeather                        =   _1st2nd_Light_Feather * NoH;
        float       lightStepMax                        =   saturate(1 - NoH + lightFeather);
        float       lightStepMin                        =   saturate(1 - NoH - lightFeather);

        float3      highlightRGB_H                      =   smoothstep(lightStepMin, lightStepMax, clamp(ilmColor.r, 0, 0.99)) * _1st_HighColor_Step.rgb;
        float3      highlightRGB_L                      =   smoothstep(_1st2nd_Light_Threshold, 1, ilmColor.r) * _2st_HighColor_Step.rgb;
        float3      HighLightMapRGB                     =   (highlightRGB_H + highlightRGB_L) * ilmColor.g;

                    outColor.rgb                        =   outColor.rgb * (1 - ilmColor.r) + HighLightMapRGB;
    }
    
#endif
