// MIT License

// Copyright (c) 2023 Stratos

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

Shader "Custom/DecalUnlit"
{
	Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScaleVector("UV Scale", Vector) = (1.0, 1.0, 1.0, 0.0)
    }
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100


        // Can use blend drop downs
        Blend SrcAlpha OneMinusSrcAlpha 
        BlendOp Add

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 depthTextureGrabPos : TEXCOORD1;
				float4 rayFromCamera : TEXCOORD2;
                float3 worldObjCenter: TEXCOORD3;
			};

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4x4 rotationMatrix;
			float4 _scaleVector;

			UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

			// Dj Lukis.LT's oblique view frustum correction (VRChat mirrors use such view frustum)
			// https://github.com/lukis101/VRCUnityStuffs/blob/master/Shaders/DJL/Overlays/WorldPosOblique.shader
			#define UMP UNITY_MATRIX_P
			inline float4 CalculateObliqueFrustumCorrection()
			{
				float x1 = -UMP._31 / (UMP._11 * UMP._34);
				float x2 = -UMP._32 / (UMP._22 * UMP._34);
				return float4(x1, x2, 0, UMP._33 / UMP._34 + x1 * UMP._13 + x2 * UMP._23);
			}
			static float4 ObliqueFrustumCorrection = CalculateObliqueFrustumCorrection();
			inline float CorrectedLinearEyeDepth(float z, float correctionFactor)
			{
				return 1.f / (z / UMP._34 + correctionFactor);
			}
			#undef UMP

			v2f vert(appdata v)
			{
				float4 worldPosition = mul(unity_ObjectToWorld, v.vertex);
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.depthTextureGrabPos = ComputeGrabScreenPos(o.vertex);
				o.rayFromCamera.xyz = worldPosition.xyz - _WorldSpaceCameraPos.xyz;
				o.rayFromCamera.w = dot(o.vertex, ObliqueFrustumCorrection); // oblique frustrum correction factor

                float4 center = float4(0.0, 0.0, 0.0, 1.0); // initialize to object space origin
                // center = mul(unity_WorldToObject, center); // transform to object space
                o.worldObjCenter = mul(unity_ObjectToWorld, center).xyz; // transform back to world space
				return o;
			}

            // Calcs alpha mask based on if depth is sky or if position of depth map is inside
            // Unity box which has dimensions [-0.5, 0.5]. TODO: Deal with scaling
            bool getAlphaMask(float3 worldPosition, float3 worldObjCenter, float rawdepth)
            {
				return (length(worldPosition.x - worldObjCenter.x) < 0.5 & 
					length(worldPosition.y - worldObjCenter.y) < 0.5 & 
					length(worldPosition.z - worldObjCenter.z) < 0.5);
            }

			float4 frag(v2f i) : SV_Target
			{
				float perspectiveDivide = 1.f / i.vertex.w;
				float4 rayFromCamera = i.rayFromCamera * perspectiveDivide;
				float2 depthTextureGrabPos = i.depthTextureGrabPos.xy * perspectiveDivide;
				// https://github.com/cnlohr/shadertrixx/blob/main/README.md#best-practice-for-getting-depth-of-a-given-pixel-from-the-depth-texture
				// For this to always work we need a directional light
				// https://forum.unity.com/threads/depth-texture-needs-directional-lighting.789557/
				// So one solution is to attach a zero power directional light on your avatar, but this will make it poor
				// It can work with out it, but this will not function on a indoor map
				float z = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, depthTextureGrabPos);

				#if UNITY_REVERSED_Z
				if (z == 0.f) {
				#else
				if (z == 1.f) {
				#endif
					// this is skybox, depth texture has default value
					return float4(0.f, 0.f, 0.f, 0.f);
				}

				// linearize depth and use it to calculate background world position
				float depth = CorrectedLinearEyeDepth(z, rayFromCamera.w);

				float3 worldPosition = rayFromCamera.xyz * depth + _WorldSpaceCameraPos.xyz;

                // Object Rotation from Decal Manager
                // worldPosition = mul(rotationMatrix, float4(worldPosition, 0.0)).xyz;
				worldPosition = worldPosition - i.worldObjCenter;
                float4 objPosition = mul(unity_WorldToObject, float4(worldPosition, 0.0));

				// demonstrate on tartan pattern
				float4 objCenter = float4(0.0, 0.0, 0.0, 1.0);
                float alpha = getAlphaMask(objPosition, objCenter, z);
                // Get coordinates relative to object
                // float3 worldRelPosition = objPosition - objCenter;

                float2 uv = (TRANSFORM_TEX((saturate(objPosition.xy + 0.5)), _MainTex));
                fixed4 col = tex2D(_MainTex, uv);
				return float4(col.rgb, col.a*alpha);
			}

			ENDCG
		}
	}
}