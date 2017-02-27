// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "Subsurface Scattering/SubsurfaceScattering" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_DepthMap ("Depth", 2D) =  "white" {}
		_ScatterMap("Scatter", 2D) = "" {}

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		//#include "UnityDeferredLibrary.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 5.0

		sampler2D _MainTex;
		sampler2D _DepthMap;
		sampler2D _ScatterMap;
		uniform float4x4 _LightProjectionMatrix;
		uniform float4x4 _LightMatrix;
		uniform float4x4 _LightTexMatrix;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float3 localPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void vert(inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.localPos = v.vertex.xyz;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{

			float4 worldP = mul(unity_ObjectToWorld, float4(IN.localPos.xyz, 1.0f));
            // translate the point into light space
            float4 pos_LightSpace = mul(_LightMatrix, worldP);

			float4 lightTexCoords = mul(_LightTexMatrix, worldP);

			// transform coordinates into texture coordinates
			lightTexCoords.xy /= lightTexCoords.w;
			lightTexCoords.x = 0.5 * lightTexCoords.x + 0.5f;
			lightTexCoords.y = 0.5 * lightTexCoords.y + 0.5f;

            // translate the point into the projection space of the light/depth map
            float4 texCoord = mul( _LightProjectionMatrix,  pos_LightSpace);

            // get the depth and set it into the range 0-1
			float d_i = tex2D(_DepthMap, lightTexCoords.xy).r;
                     
            float d_o = length( pos_LightSpace );
                     
            float distance = d_o - d_i;
			o.Albedo = half3(0.0f, 0.0f, d_i);// tex2D(_ScatterMap, float2(distance, 0.0f)).rgb;//tex2D(_DepthMap, lightTexCoords.xy).rgb; //
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			o.Alpha = 1.0f;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
