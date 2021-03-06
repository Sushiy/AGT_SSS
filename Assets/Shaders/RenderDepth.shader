﻿Shader "Subsurface Scattering/RenderDepth" 
{
    SubShader 
	{
        Tags { "RenderType"="Opaque" }
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

			sampler2D _CameraDepthTexture;
            
			struct v2f 
			{
			   float4 pos : SV_POSITION;
			   float4 scrPos:TEXCOORD1;
			};

			//Basic Vertex Shader; Pass over position
            v2f vert (appdata_base v) 
			{
                v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.scrPos=ComputeScreenPos(o.pos);
				return o;
            }

            //Fragment Shader; Sample the Cameras internal DepthTexture and draw it to the screen
			half4 frag (v2f i) : COLOR
			{
				float depthValue = Linear01Depth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r);

				return float4(depthValue, depthValue, depthValue, 1.0f);
			}
            ENDCG
        }
    }
}