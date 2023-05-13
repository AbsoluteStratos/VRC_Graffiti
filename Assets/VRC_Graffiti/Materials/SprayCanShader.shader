Shader "Custom/SprayCanShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness (RGB)", 2D) = "white" {}
        _Metallic ("Metallic (RGB)", 2D) = "white" {}
        _BumpMap ("Bumpmap", 2D) = "bump" {}
        _RainbowMask ("Rainbow Mask", 2D) = "black" {}
        _Speed("Rainbow Speed", Range(0, 1)) = 0.05
        _Emission("Rainbow Emission", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex, _Metallic, _Glossiness, _BumpMap, _RainbowMask;

        struct Input
        {
            float2 uv_MainTex;
        };

        float _Speed, _Emission;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        fixed3 ColorWheel (float t) {
            fixed3 color;
            color.r = sin(t * 6.28318530718);
            color.g = sin(t * 6.28318530718 + 2.09439510239);
            color.b = sin(t * 6.28318530718 + 4.18879020479);
            return color * 0.5 + 0.5;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 m = tex2D (_RainbowMask, IN.uv_MainTex);
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 r = ColorWheel(_Time.y * _Speed);
            o.Albedo = lerp(c.rgb, r.rgb, m.r); 
            // Metallic and smoothness come from slider variables
            o.Metallic = 0.5 * tex2D (_Metallic, IN.uv_MainTex);
            o.Smoothness = tex2D (_Glossiness, IN.uv_MainTex);
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_MainTex));
            o.Emission = _Emission*lerp(fixed3(0,0,0), r.rgb, m.r);  
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
