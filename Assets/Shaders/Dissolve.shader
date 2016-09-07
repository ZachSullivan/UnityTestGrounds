Shader "Dissolve" {
	Properties{
		_MainTex("Texture (RGB)", 2D) = "white" {}
	_SliceGuide("Slice Guide (RGB)", 2D) = "white" {}
	_SliceAmount("Slice Amount", Range(0.0, 1.0)) = 0.5


		_ColorTint("Color Tint", Color) = (1, 1, 1, 1)
	_BumpMap("Normal Map", 2D) = "bump" {}
	_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		_RimPower("Rim Power", Range(1.0, 6.0)) = 3.0


		_BurnSize("Burn Size", Range(0.0, 1.0)) = 0.15
		_BurnRamp("Burn Ramp (RGB)", 2D) = "white" {}
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		Cull Off
		CGPROGRAM
		//if you're not planning on using shadows, remove "addshadow" for better performance
#pragma surface surf Lambert addshadow
	struct Input {
		float2 uv_MainTex;
		float2 uv_SliceGuide;
		float _SliceAmount;

		float4 color : Color;
		float2 uv_BumpMap;
		float3 viewDir;
	};


	sampler2D _MainTex;
	sampler2D _SliceGuide;
	float _SliceAmount;
	sampler2D _BurnRamp;
	float _BurnSize;

	float4 _ColorTint;
	sampler2D _BumpMap;
	float4 _RimColor;
	float _RimPower;


	void surf(Input IN, inout SurfaceOutput o) {
		clip(tex2D(_SliceGuide, IN.uv_SliceGuide).rgb - _SliceAmount);

		IN.color = _ColorTint;
		o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * IN.color;
		o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

		half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
		//o.Emission = _RimColor.rgb * pow(rim, _RimPower);

		half test = tex2D(_SliceGuide, IN.uv_MainTex).rgb - _SliceAmount;
		if (test < _BurnSize && _SliceAmount > 0 && _SliceAmount < 1) {

			o.Emission = tex2D(_BurnRamp, float2(test *(1 / _BurnSize), 0));
			o.Albedo *= o.Emission;
		}
	}
	ENDCG
	}
		Fallback "Diffuse"
}
