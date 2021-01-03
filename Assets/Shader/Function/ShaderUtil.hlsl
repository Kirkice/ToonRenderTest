//------------- Function --------------
//-------------  Kirk  --------------
#ifndef Include_ShaderUtil
#define Include_ShaderUtil

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl" 
#include "./Input/InputParames.hlsl"

//-------------  设置方向参数  --------------
    void GET_DIRECTION_PARAMES(float3 normal, float3 posW, inout float3 N, inout float3 L, inout float3 V)
    {
        N                                               = normalize(normal);
        Light mainLight                                 = GetMainLight();
        L                                               = mainLight.direction;
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
        float       fixShadowArea                       =  step(ilmColor.g,0.1);
        float       HNoLArea                            =  1 - fixShadowArea;
                    outColor                            =  fixShadowArea * _FixShadowColor + HNoLArea * mainColor;
    }

//-------------  设置头发高光  --------------    
    void SET_HAIR_HIGHLIGHT(float4 ilmColor, float3 N, float3 V, float3 L, inout float4 outColor)
    {
        float       SPEC_MASK                           =  ilmColor.r;
        float       SPEC_POW                            =  1 - ilmColor.b;
        float3      SPEC                                =  saturate(pow(max(0, dot(N, normalize(V + L))), SPEC_POW * 18) - SPEC_POW);
	    SPEC                                            =  (SPEC + ceil(SPEC)) * SPEC_MASK * _SPEC_Strength;
        outColor.rgb                                   +=  SPEC;
    }
    
#endif
