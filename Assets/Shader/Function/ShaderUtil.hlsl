//------------- Function --------------
//-------------  Kirk  --------------
#ifndef Include_ShaderUtil
#define Include_ShaderUtil

#include "./Input/InputParames.hlsl"

//-------------  设置头发颜色参数  --------------
    void GET_HAIR_COLOR(inout float4 mainColor, inout float4 ilmColor,float2 uv, inout float4 outColor)
    {
        mainColor                               =  tex2D(_MainTexture, TRANSFORM_TEX(uv, _MainTexture)) * _MainColor;
        ilmColor                                =  tex2D(_ILMTexture, TRANSFORM_TEX(uv, _ILMTexture));
        outColor                                =  mainColor;
    }

//-------------  设置头发阴影  --------------    
    void SET_HAIR_SHADOW(float4 mainColor, float4 ilmColor, inout float4 outColor)
    {
        float fixShadowArea                     =  step(ilmColor.g,0.1);
        float HNoLArea                          =  1 - fixShadowArea;
        outColor                                =  fixShadowArea * mainColor * _FixShadowColor + HNoLArea * mainColor;
    }
#endif
