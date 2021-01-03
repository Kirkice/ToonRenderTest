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
CBUFFER_END