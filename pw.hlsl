/**********************************************************************
HLSL pixel shader for Windows Terminal

Sources used:
https://github.com/microsoft/terminal/blob/main/samples/PixelShaders/README.md
https://blog.grijjy.com/2021/01/14/shader-programming/

2021-04-05 Arttu Kärpinlehto
**********************************************************************/

// The terminal graphics as a texture
Texture2D shaderTexture;
SamplerState samplerState;

// Terminal settings such as the resolution of the texture
cbuffer PixelShaderSettings {
  float  Time;
  float  Scale;
  float2 Resolution;
  float4 Background;
};


float4 main(float4 pos : SV_POSITION, float2 tex : TEXCOORD) : SV_TARGET
{
	float4 sample = shaderTexture.Sample(samplerState, tex);
	float3 col = float3(Background.rgb);
	float i0 = 1.0;
 	float i1 = 1.0;
	float i2 = 1.0;
	float i4 = 0.0;
	float2 uv = tex.xy;

	for (int s = 0; s < 7; s++) 
	{
	    float2 r = float2(
	      cos(uv.y * i0 - i4 + Time / i1),
	      sin(uv.x * i0 - i4 + Time / i1)) / i2;
       
	    r += float2(-r.y, r.x) * 0.3;    
	    uv.xy += r;
     
	    i0 *= 1.93;
	    i1 *= 1.15;
	    i2 *= 1.7;
	    i4 += 0.05 + 0.1 * Time * i1;
	}
   
	float r = sin(uv.x - Time) * 0.5 + 0.5;
	float b = sin(uv.y + Time) * 0.5 + 0.5;
	float g = sin((uv.x + uv.y + sin(Time * 0.5)) * 0.5) * 0.5 + 0.5;
        
	col *= float3(r, g, b);
	col *= tex.x * (1.0 - tex.y);
	col = lerp(col, sample, sample.w);
	return float4(col, 1.0);
}


