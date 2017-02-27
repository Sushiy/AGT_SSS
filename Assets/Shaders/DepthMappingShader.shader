// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Subsurface Scattering/ShadowMap"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_DepthMap("Depth", 2D) = "white" {}
		_ScatterMap("Scatter", 2D) = "" {}
	}

		SubShader
	{
		Tags{ "RenderType" = "Opaque" }

		Pass
	{
		CGPROGRAM
#pragma vertex 		ShadowMapVS
#pragma fragment 	ShadowMapPS
#pragma target 		3.0
#include "UnityCG.cginc"

		// material components
		static float4 g_vecMaterialDiffuse = { 1.0, 0.0, 0.0, 1.0 };
	static float4 g_vecMaterialAmbient = { 1.0, 0.0, 0.0, 1.0 };

	// light components
	static float4 g_vecLightDiffuse = { 0.2, 0.2, 0.2, 1.0 };
	static float4 g_vecLightAmbient = { 0.2, 0.2, 0.2, 1.0 };

	static float3 g_vecLightPos = { 0.0, 5.0, 0.0 };
	static float3 g_vecLightDir = { 0.0, 1.0, 0.0 };

	sampler2D _MainTex;
	sampler2D _DepthMap;
	sampler2D _ScatterMap;
	uniform float4x4 _LightProjectionMatrix;
	uniform float4x4 _LightMatrix;
	uniform float4x4 _LightTexMatrix;

	static float _TexSize = 512;
	static float _Bias = 0.012;
	uniform float4x4  _ProjMatrix;
	static float _FarClip = 5.5;
	static float _NearClip = 0.3;

	// vertex input structure used by both techniques
	struct VSInput
	{
		float3 pos: POSITION0;
		float3 norm: NORMAL0;
		float2 tex: TEXCOORD0;
	};

	// vertex output structure used by ShadowMap technique
	struct VSOutput
	{
		float4 pos: SV_POSITION;
		float4 col: COLOR0;
		float4 projTex: TEXCOORD1;
	};

	VSOutput ShadowMapVS(VSInput a_Input)
	{
		VSOutput Output;

		// calculate vertex position homogenous
		Output.pos = mul(UNITY_MATRIX_MVP, float4(a_Input.pos, 1.0f));

		// calculate vertex normal
		float3 normal = normalize(mul(transpose(unity_WorldToObject), float4(a_Input.norm, 0.0f)).xyz);

		// calculate diffuse variable
		float diffComp = max(dot(g_vecLightDir, normal), 0.0f);

		// calculate the two components
		float3 diffuse = diffComp * (g_vecLightDiffuse * g_vecMaterialDiffuse).rgb;
		float3 ambient = g_vecLightAmbient * g_vecMaterialAmbient;

		// combine and output colour
		Output.col = float4(diffuse + ambient, g_vecMaterialAmbient.a);

		float4 posWorld = mul(unity_ObjectToWorld, float4(a_Input.pos, 1.0f));

		Output.projTex = mul(_LightTexMatrix, posWorld);

		return Output;
	}

	// this function is based on Microsoft's function of the same purpose in their ShadowMapping example
	float4 ShadowMapPS(VSOutput a_Input) : COLOR
	{
		// transform coordinates into texture coordinates
		a_Input.projTex.xy /= a_Input.projTex.w;
		a_Input.projTex.x = 0.5 * a_Input.projTex.x + 0.5f;
		a_Input.projTex.y = 0.5 * a_Input.projTex.y + 0.5f;

		// Compute pixel depth for shadowing
		float depth = a_Input.projTex.z / a_Input.projTex.w;

		// Now linearise using a formula by Humus, drawn from the near and far clipping planes of the camera.
		float sceneDepth = _NearClip * (depth + 1.0) / (_FarClip + _NearClip - depth * (_FarClip - _NearClip));

		// Transform to texel space
		float2 texelpos = _TexSize * a_Input.projTex.xy;

		// Determine the lerp amounts.           
		float2 lerps = frac(texelpos);

		// sample shadow map
		float dx = 1.0f / _TexSize;
		float s0 = (DecodeFloatRGBA(tex2D(_DepthMap, a_Input.projTex.xy)) + _Bias < sceneDepth) ? 0.0f : 1.0f;
		float s1 = (DecodeFloatRGBA(tex2D(_DepthMap, a_Input.projTex.xy + float2(dx, 0.0f))) + _Bias < sceneDepth) ? 0.0f : 1.0f;
		float s2 = (DecodeFloatRGBA(tex2D(_DepthMap, a_Input.projTex.xy + float2(0.0f, dx))) + _Bias  < sceneDepth) ? 0.0f : 1.0f;
		float s3 = (DecodeFloatRGBA(tex2D(_DepthMap, a_Input.projTex.xy + float2(dx, dx))) + _Bias  < sceneDepth) ? 0.0f : 1.0f;

		float shadowCoeff = lerp(lerp(s0, s1, lerps.x), lerp(s2, s3, lerps.x), lerps.y);

		// output colour multipled by shadow value
		//return float4(shadowCoeff * a_Input.col.rgb, g_vecMaterialDiffuse.a);
		return tex2D(_DepthMap, a_Input.projTex.xy);
	}

		ENDCG
	}
	}
}
