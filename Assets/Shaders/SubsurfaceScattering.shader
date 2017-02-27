// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "Custom/SubsurfaceScattering" {
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
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _DepthMap;
		sampler2D _ScatterMap;
		float4x4 _LightProjectionMatrix;
		float4x4 _LightMatrix;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
            // translate the point into light space
            float4 pos_LightSpace = mul(_LightMatrix, float4( IN.worldPos.xyz, 1.0f ));

            // translate the point into the projection space of the light/depth map
            float4 texCoord = mul( _LightProjectionMatrix,  pos_LightSpace);

            // get the depth and set it into the range 0-1
            float d_i =  Linear01Depth(tex2Dproj( _DepthMap, UNITY_PROJ_COORD( texCoord)).r);
                     
            float d_o = length( pos_LightSpace );
                     
            float distance = d_o - d_i;

			o.Albedo = tex2D(_ScatterMap, float2(distance, 0.0f)).rgb;// tex2Dproj( _DepthMap, UNITY_PROJ_COORD( texCoord)); //
			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1.0f;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
