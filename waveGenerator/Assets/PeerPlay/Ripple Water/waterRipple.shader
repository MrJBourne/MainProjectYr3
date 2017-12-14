Shader "unlit/waterRipple"//unlit?
{
	Properties
	{
		[NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
		_Scale ("Scale", float) = 1
		_Speed ("Speed", float) = 1
		_Freq ("Freq", float) = 1
		_Colour("Colour", color) = (1,1,1,1)
	}
	SubShader
	{

		//Tags { "RenderType"="Opaque" }
		//Tags {"LightMode"="ForwardBase"}//forward rendering pipeline
		//LOD 100

		Pass
		{
		//Tags { "RenderType"="Opaque" }
		//Tags {"LightMode"="ForwardBase"}//forward rendering pipeline
		LOD 100

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			//#pragma surface surf WrapLambert
			// make fog work
			//#pragma multi_compile_fog
			
			//#include "UnityCG.cginc"
			#include "UnityCG.cginc" // for UnityObjectToWorldNormal
            //#include "UnityLightingCommon.cginc" // for _LightColor0

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				//float3 normal : NORMAL;
				fixed4 color : COLOR;
				//fixed4 diff : COLOR0;//?
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				//fixed4 diff : COLOR0; // diffuse lighting color
				fixed4 color : COLOR;//

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Scale, _Speed, _Freq;
			half4 _Colour;
			float3 customValue;
			
			v2f vert (appdata v)
			{

			//_Scale = 0.5;
				v2f o;
				//half offsetVert = v.vertex.x + v.vertex.z;
				half offsetVert = ((v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z));
				half value = _Scale * sin(_Time.y * _Speed + offsetVert * _Freq);
				v.vertex.y += value;

				//sin(_Time.y)*4;
				//v.vertex.y+=value;
				//v.normal += value;
				//o.customValue = value;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color * 0.5 + 0.5;
				//o.normal += IN.value;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);

				//half3 worldNormal = UnityObjectToWorldNormal(v.normal);// get vertex normal in world space
				//half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));                // dot product between normal and light direction for|standard diffuse (Lambert) lighting
				                // factor in the light color
                //o.diff = nl * _LightColor0;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) * _Colour;
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
