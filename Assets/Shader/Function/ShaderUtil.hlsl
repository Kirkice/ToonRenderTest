//------------- Function --------------
//-------------  zhuhan  --------------
#include "./character_lib.hlsl"

/// <summary>
/// 根据UV获取SimpleX噪声并Step
/// </summary>
half SIMPLEX_NOISE_SETP(float2 uv)
{
    half2 noise                                 = half2(uv.x * 30 , uv.y * 30);
    return SimpleX_Noise(noise);
}
/// <summary>
/// 正交化处理
/// </summary>
void ORTHOGRAPHIC_SET_MV(float4 vertex, inout float4 posCS)
{
	#if defined (ORTHOGRAPHIC_ON)
        vertex                                  = mul(UNITY_MATRIX_MV,vertex);
        float pivortZ                           = UNITY_MATRIX_MV[2][3];
        vertex.z                                = (vertex.z - pivortZ) / _PerspectCor + pivortZ;
        posCS                                   = mul(UNITY_MATRIX_P,vertex);            
	#endif
}
