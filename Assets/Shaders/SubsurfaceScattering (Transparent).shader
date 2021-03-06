﻿Shader "Subsurface Scattering/SubsurfaceScattering(Transparent)" 
{
	//Transparent Variant of the SubSurfaceShader

	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_Alpha("Alpha", Range(0,1)) = 0.5
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_DepthMap("Depth", 2D) = "white" {}
		_ScatterMap("Scatter", 2D) = "" {}
		_AlphaFalloffMap("AlphaFalloff", 2D) = "" {}
	}
		SubShader{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		LOD 200

		CGPROGRAM
		//#include "UnityDeferredLibrary.cginc"
#include "UnityCG.cginc"
#include "Lighting.cginc"
		// Physically based Standard lighting model, and enable shadows on all light types
#pragma surface surf Standard alpha fullforwardshadows  vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
#pragma target 5.0

	sampler2D _DepthMap;
	sampler2D _ScatterMap;
	sampler2D _AlphaFalloffMap;
	float _CameraFarPlane;
	float4x4 _LightProjectionMatrix;
	float4x4 _LightMatrix;
	float4x4 _LightTexMatrix;
	float4 _LightColor;

	struct Input
	{
		float3 worldPos;
		float3 localPos;
	};

	half _Glossiness;
	half _Metallic;
	float _Alpha;
	fixed4 _Color;

	void vert(inout appdata_full v, out Input o) {
		UNITY_INITIALIZE_OUTPUT(Input, o);
		o.localPos = v.vertex.xyz;
	}

	void surf(Input IN, inout SurfaceOutputStandard o)
	{
		//Calculate WorldSpace Position of fragment
		float4 worldP = mul(unity_ObjectToWorld, float4(IN.localPos.xyz, 1.0f));

		//Translate point into light space
		float4 pos_LightSpace = mul(_LightMatrix, worldP);

		//Translate point into lightProjectionSpace
		float4 lightTexCoords = mul(_LightTexMatrix, worldP);

		//transform coordinates into texture coordinates
		lightTexCoords.xy /= lightTexCoords.w;
		lightTexCoords.x = 0.5 * lightTexCoords.x + 0.5f;
		lightTexCoords.y = 0.5 * lightTexCoords.y + 0.5f;

		//get the depth from the DepthMap and set it into the range 0-1
		float dist_IN = Linear01Depth(DecodeFloatRGBA(tex2D(_DepthMap, lightTexCoords.xy)));

		//calculate the distance from the Light to the current point
		float dist_OUT = length(pos_LightSpace) / _CameraFarPlane;

		//calculate the distance that the light traveled through the object
		float dist_THROUGH = dist_OUT - dist_IN;

		//Albedo is sampled from the ScatterMap and multiplied with the Color of the light
		o.Albedo = tex2D(_ScatterMap, float2(dist_THROUGH, 0.0f)).rgb * _LightColor;

		// Metallic and smoothness come from slider variables
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		//Substract the value of the AlphaFallofMap (sampled with the distance traveled through the medium) from the Alpha set in the Material
		o.Alpha = _Alpha - tex2D(_AlphaFalloffMap, float2(dist_THROUGH, 0.0f)).r;
	}
	ENDCG
	}
		FallBack "Diffuse"
}
