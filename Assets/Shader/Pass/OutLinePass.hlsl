//***************************************************************************************
// OutLine.hlsl by Kirk . 2020
//
// OutLine Pass Part, ToonShader
//***************************************************************************************

#include "./Function/ShaderUtil.hlsl"

struct VertexIn
{
	float4 PosL                     :   POSITION;
    float3 NormalL                  :   NORMAL;
    float3 tangent                  :   TANGENT;
    float4 color                    :   COLOR;
    float2 texcoord0                :   TEXCOORD0;
};

struct VertexOut
{
	float4 PosH                     :   SV_POSITION;
    float3 PosW                     :   POSITION;
    float3 NormalW                  :   NORMAL;
    float3 Color                    :   COLOR;
    float2 uv                       :   TEXCOORD0;
};

VertexOut VS(VertexIn vin)
{
    VertexOut vout                  =   (VertexOut)0.0f;
    vout.PosW                       =   mul( unity_ObjectToWorld, vin.PosL);
    half3 viewNormal                =   mul((float3x3)UNITY_MATRIX_IT_MV, vin.tangent);
    half3 ndcNormal                 =   normalize(TransformViewToProjection(viewNormal.xyz)) * pos.w;



// v2f_outline vert_outline(outline_data v)
// {
// 	v2f_outline o = (v2f_outline)0;
	
// 	#if defined(BREAK_ON)
// 		_BreakDir = normalize(_BreakDir);
// 		float4 worldPos = mul(unity_ObjectToWorld,v.vertex);
// 		half X = lerp(0,_BreakDir.x * _MaxDistance_X,_BreakScale);
// 		half Y = lerp(0,_BreakDir.y * _MaxDistance_Y,_BreakScale);
// 		half Z = lerp(0,_BreakDir.z * _MaxDistance_Z,_BreakScale);
// 		worldPos.xyz += half3(X,Y,Z);
// 		v.vertex = mul(unity_WorldToObject,worldPos);
// 	#endif

// 	#if defined (ORTHOGRAPHIC_ON)
// 		float4 posVS = mul(UNITY_MATRIX_MV,v.vertex);
// 		float pivortZ = UNITY_MATRIX_MV[2][3];
// 		posVS.z = (posVS.z - pivortZ) / _PerspectCor + pivortZ;
// 		half4 pos = mul(UNITY_MATRIX_P,posVS);
// 	#else
// 		half4 pos = UnityObjectToClipPos(v.vertex);
// 	#endif
// 	o.PosOS	= normalize(v.vertex);
//     o.uv1 = v.texcoord0;
// 	half3 posWS = mul(unity_ObjectToWorld,v.vertex);
// 	half3 aimNormal = _UseSmoothNormal * v.tangent.xyz + (1 - _UseSmoothNormal) * v.normal.xyz;
//     half3 viewNormal = mul((float3x3)UNITY_MATRIX_IT_MV, aimNormal);
//     half3 ndcNormal = normalize(TransformViewToProjection(viewNormal.xyz)) * pos.w;//将法线变换到NDC空间
    
// 	half4 nearUpperRight = mul(unity_CameraInvProjection, float4(1, 1, UNITY_NEAR_CLIP_VALUE, _ProjectionParams.y));//将近裁剪面右上角位置的顶点变换到观察空间
//     half aspect = abs(nearUpperRight.y / nearUpperRight.x);//求得屏幕宽高比
//     ndcNormal.x *= aspect;
// 	half Dis = distance(_WorldSpaceCameraPos.xyz,posWS);
// 	half outlineScaleBalance = 0.1 * lerp(0.7,0.25,clamp((Dis/5),0,1));
//     pos.xy += outlineScaleBalance * _OutlineWidth * ndcNormal.xy * v.color.x;
//     o.pos = pos;
// 	o.screenPos = ComputeScreenPos(o.pos);
//     o.color.xyz = v.color.xyz;
// 	o.color.a = v.color.x;
//     o.uv0 = v.texcoord0;
// 	return o;
// }

// half4 frag_skin_outline(v2f_outline i) : COLOR
// {
// 	half4 finalColor = i.color;
// 	clip(i.color.a - 0.001);
// 	float skinmask = step(i.color.g, 0.01);
// 	finalColor.rgb = skinmask * _OutlineColor.rgb + (1 - skinmask) * _OutlineSkinColor.rgb;
// 	half4 mainColor = tex2D(_MainTex, TRANSFORM_TEX(i.uv0.xy, _MainTex));
// 	clip(mainColor.a - 0.5);

// 	half2 screenPos = i.screenPos.xy / i.screenPos.w;
// 	screenPos *= _ScreenParams.xy;
// 	SetMaskTransparency(_Transparency,screenPos);
// 	/******************************************************************/
// 	/******************************************************************/
// 	/*************			 Dissolve  					***************/
// 	/******************************************************************/
// 	/******************************************************************/
// 	#if defined(DISSOLVE_ON)
//         // half noiseValue = tex2D(_NoiseTex,TRANSFORM_TEX(i.uv0.xy, _NoiseTex)).r;  
// 		// if(noiseValue <= _DissolveScale)
// 		// 	discard;
// 		clip(mainColor.a - 2);
// 	#endif

//     #if defined (NOISE_DISSOLVE_ON)
//         half clipLine                           = i.PosOS.y + 0.5;
//         _DissolveStep                          += _DissolveCut;
//         half  clipMask                          = 1 - saturate(((clipLine - (_DissolveStep - _DissolveFeather)) * - 1.0 ) / (_DissolveStep - (_DissolveStep - _DissolveFeather)) + 1 );
        
//         if (clipLine < _DissolveCut)
//             discard;

//         if (clipLine > _DissolveCut)
//             finalColor.rgb                           = lerp(_DissolveColor.rgb, finalColor.rgb, clipMask);
//     #endif

// 	return half4(finalColor.rgb , 1);
// }

// half4 frag_outline(v2f_outline i) : COLOR
// {
// 	fixed4 finalColor = _OutlineColor;
// 	clip(i.color.a - 0.001);
// 	half4 mainColor = tex2D(_MainTex, TRANSFORM_TEX(i.uv0.xy, _MainTex));
// 	clip(mainColor.a - 0.5);

// 	half2 screenPos = i.screenPos.xy / i.screenPos.w;
// 	screenPos *= _ScreenParams.xy;
// 	SetMaskTransparency(_Transparency,screenPos);
// 	/******************************************************************/
// 	/******************************************************************/
// 	/*************			 Dissolve  					***************/
// 	/******************************************************************/
// 	/******************************************************************/
// 	#if defined(DISSOLVE_ON)
//         // half noiseValue = saturate(tex2D(_NoiseTex,TRANSFORM_TEX(i.uv0.xy, _NoiseTex)).r);  
// 		// if(noiseValue < _DissolveScale)
// 		// discard;
// 		clip(mainColor.a - 2);
// 	#endif

//     #if defined (NOISE_DISSOLVE_ON)
//         half clipLine                           = i.PosOS.y + 0.5;
//         _DissolveStep                          += _DissolveCut;
//         half  clipMask                          = 1 - saturate(((clipLine - (_DissolveStep - _DissolveFeather)) * - 1.0 ) / (_DissolveStep - (_DissolveStep - _DissolveFeather)) + 1 );
        
//         if (clipLine < _DissolveCut)
//             discard;

//         if (clipLine > _DissolveCut)
//             finalColor.rgb                           = lerp(_DissolveColor.rgb, finalColor.rgb, clipMask);
//     #endif

// 	return half4(finalColor.rgb, 1);
// }