//------------- InputParames --------------
//---------------  Kirk  ------------------

//-------------  Textures  --------------
uniform         sampler2D   _MainTexture;
uniform         sampler2D   _ILMTexture;

CBUFFER_START(UnityPerMaterial)

//-------------  OUTLINE  --------------
    uniform     float       _OutlineWidth;
    uniform     float4      _OutlineColor;

//-------------  MAINTEX  --------------
    uniform     float4      _MainTexture_ST;
    uniform     float4      _MainColor;

//-------------  ILMTEX  ---------------
    uniform     float4      _ILMTexture_ST;

//-------------  SHADOW  ---------------
    uniform     float4      _FixShadowColor;

    uniform     float4      _FirstShadowColor;
    uniform     float4      _SecondShadowColor;
    uniform     float       _FirstStep;
    uniform     float       _FirstFeather;
    uniform     float       _SecondStep;
    uniform     float       _SecondFeather;

    uniform     float4      _1st_HighColor_Step;
    uniform     float4      _2st_HighColor_Step;
    uniform     float       _1st2nd_Light_Feather;
    uniform     float       _1st2nd_Light_Threshold;

//-------------  SPEC  ---------------
    uniform     float       _SPEC_Strength;
    uniform     float4      _SPEC_COLOR;
    uniform     float       _LightWidth;
    uniform     float       _LightLength;
CBUFFER_END