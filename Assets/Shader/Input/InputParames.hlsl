//------------- InputParames --------------
//---------------  Kirk  ------------------

/// <summary>
/// 图片部分
/// </summary>
// TEXTURE2D(_OutlineZOffsetMaskTex);

CBUFFER_START(UnityPerMaterial)
/// <summary>
/// 描边部分
/// </summary>
    uniform     float       _OutlineWidth;
    uniform     float4      _OutlineColor;

/// <summary>
/// 图片部分
/// </summary>
    // uniform     float4      _OutlineZOffsetMaskTex_ST;

CBUFFER_END