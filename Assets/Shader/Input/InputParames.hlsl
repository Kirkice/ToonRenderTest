//------------- InputParames --------------
//---------------  Kirk  ------------------

/// <summary>
/// 图片部分
/// </summary>
CBUFFER_START(UnityPerMaterial)
/// <summary>
/// 描边部分
/// </summary>
    uniform     float       _OutlineWidth;
    uniform     float4      _OutlineColor;

/// <summary>
/// 图片部分
/// </summary>
    uniform     sampler2D   _MainTex;
    uniform     float4      _MainTex_ST;

/// <summary>
/// 颜色部分
/// </summary>
    uniform     float4      _MainColor;
    uniform     float4      _F_ShadowColor;

/// <summary>
/// 阴影部分
/// </summary>
    uniform     float       _ShadowStep;
    uniform     float       _ShadowFeather;
CBUFFER_END