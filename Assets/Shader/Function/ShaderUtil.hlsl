//------------- Function --------------
//-------------  Kirk  --------------
#ifndef Include_ShaderUtil
#define Include_ShaderUtil

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/SpaceTransforms.hlsl"

#include "./Input/InputParames.hlsl"

//--------------- 获取方向参数 ----------------
void GetNormalizeDir(float3 normal, float3 posWS, inout float3 normalDir, inout float3 lightDir, inout float3 viewDir)
{
    normalDir                               = normalize(normal);
    Light mainLight                         = GetMainLight();
    lightDir                                = normalize(mainLight.direction);
    viewDir                                 = normalize(_WorldSpaceCameraPos.xyz - posWS.xyz);
}

//------------- 获取头发贴图参数 --------------
void GetHairTexParames(float2 uv, inout float4 out_color,inout float4 mainColor)
{
    mainColor                               = tex2D(_MainTex , TRANSFORM_TEX(uv, _MainTex)) * _MainColor;
    out_color                               = mainColor;
}

//---------------- 获取头发颜色 -----------------
void GetHairColor(float3 N, float3 L, float4 mainColor, inout float4 out_color)
{
    float HNoL                              = dot(N, L) * 0.5 + 0.5;
    float lerp_shadow                       = saturate(((HNoL - (_ShadowStep-_ShadowFeather)) * - 1.0 ) / (_ShadowStep - (_ShadowStep - _ShadowFeather)) + 1 );
    out_color                               = lerp(mainColor,_F_ShadowColor,lerp_shadow);
}
#endif
