// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "Custom/SubsurfaceScattering" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_DepthMap ("Depth", 2D) =  "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "Autolight.cginc"
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _DepthMap;
		float4x4 _LightProjectionMatrix;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			/*
			//Get Distance from Light to entrypoint
			//float dist_IN = tex2Dproj(_DepthMap, );
			
			//Transform Point to LightSpace
			float4 pos_Light = mul(_World2Light[0], float4(pos,1.0));

			//distance of this pixel from light (Distance Out)
			float dist_OUT = length(pos_Light);

			//calculate depth
			float depth = dist_OUT - dist_IN;
			*/
			// translate the point into light space
            float4 PointInLightSpace = mul(_Object2Light[0], input.fragPos );
            // translate the point into the projection space of the light/depth map
            float4 texCoord = mul( _LightProjectionMatrix, PointInLightSpace );
            // get the depth and set it into the range 0-1
            float d_i = Linear01Depth( tex2Dproj( _DepthMap, UNITY_PROJ_COORD( texCoord.xyw ) ).r );
            // translate the point into light space
            float Plight = mul(_Object2Light[0], float4( input.fragPos.xyz, 1.0 ) );
                     
            float d_o = length( Plight );
                     
            float distance = d_o - d_i;

			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
