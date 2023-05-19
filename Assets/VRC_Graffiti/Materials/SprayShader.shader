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


Shader "Custom/SprayShader"
{
    Properties
    {
        _MainTex ("Alpha Mask", 2D) = "white" {}
        _Speed("Rainbow Speed", Range(0, 1)) = 0.05
        _Emission("Rainbow Emission", Range(0, 1)) = 0
        _Alpha("Alpha", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent+1" }
        LOD 200
        // Can use blend drop downs
        Blend SrcAlpha OneMinusSrcAlpha 
        BlendOp Add

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float4 color : COLOR; // Particles edit vertex color with color over life time
        };

        float _Speed, _Emission, _Alpha;

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
            float alpha = tex2D (_MainTex, IN.uv_MainTex).r;
            fixed3 col = ColorWheel(_Time.y * _Speed);
            o.Albedo = col; 
            o.Emission = _Emission * col;
            o.Alpha = alpha *  IN.color.a * _Alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
