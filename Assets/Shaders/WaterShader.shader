Shader "Custom/WaterShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

		_Steepness ("Steepness", Range(0, 1)) = 0.5
		_Wavelength ("Wavelength", Float) = 10
		_Direction ("Direction (2D)", Vector) = (1,0,0,0)        
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 200

        GrabPass {"_WaterBackground"}

        CGPROGRAM
        #pragma surface surf Standard alpha fullforwardshadows vertex:vert // so the shader uses the vert function
        #pragma target 3.0

        #include "LookingThroughWater.cginc"

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float4 screenPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

		float _Steepness;
        float _Wavelength;
		float2 _Direction;

        void makeWave(inout appdata_full vertexPoint)
        {
            float3 p = vertexPoint.vertex.xyz;
            float k = 2 * UNITY_PI / _Wavelength;
            float c = sqrt (9.8 / k);
            float2 d = normalize(_Direction);
            float f = k * (dot(d, p.xz) - c * _Time.y);
            float a = _Steepness / k;
            
			p.y = a * sin(f);

            vertexPoint.vertex.xyz = p;
        }

        void calculateNormal(inout appdata_full vertexPoint)
        {
            float3 p = vertexPoint.vertex.xyz;
            float2 d = normalize(_Direction);
            float k = 2 * UNITY_PI / _Wavelength;
            float c = sqrt (9.8 / k);
            float f = k * (dot(d, p.xz) - c * _Time.y);

            float3 tangent = float3(1 - d.x * d.x * (_Steepness * sin(f)), d.x * (_Steepness * cos(f), 0), -d.x * d.y *(_Steepness * sin(f)));
            float3 binormal = float3 (-d.x * d.y * (_Steepness * sin(f)), d.y * (_Steepness * cos(f)), 1 - d.y * d.y * (_Steepness * sin(f)));
            
            float3 normal = normalize(cross(binormal, tangent));
            vertexPoint.normal = normal;
        }

        void vert (inout appdata_full vertexData) 
        {
            // creating a wave
            makeWave(vertexData);

            // changing vertex normals
            calculateNormal(vertexData);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

            o.Albedo = ColourBelowWater(IN.screenPos);
			o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
