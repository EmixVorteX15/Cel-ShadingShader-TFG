Shader "Unlit/ToonShaderBI"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        

        // Ambient light is applied uniformly to all surfaces on the object.
		[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
		[HDR]
		_SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
		// Controls the size of the specular reflection.
		_Glossiness("Glossiness", Float) = 32
        [HDR]
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		// Control how smoothly the rim blends when approaching unlit
		// parts of the surface.
		_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1		

        
        // Number of stripes
        [IntRange]
        _Stripes("Stripes", Range(0,10)) = 3
        
        // Personalized colors
        _Color1("Color1", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone1("Halftone", Float) = 0
        _Color2("Color2", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone2("Halftone", Float) = 0
        _Color3("Color3", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone3("Halftone", Float) = 0
        _Color4("Color4", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone4("Halftone", Float) = 0
        
        // Color palette
        [Toggle] 
        _Paleta("Palette", Float) = 0
        _ColorPaleta("Palette Color", Color) = (1,1,1,1)
       
        // Outline
        _OutlineColor("Outline Color", Color) = (1,1,1,1)
        _OutlineThreshold("Outline Threshold", Range(0,1)) = 0.1


        // Halftone
        [IntRange]
        _Frequency("Frequency", Range(0,200)) = 0
        _ColorHalftone("Dots Color", Color) = (1,1,1,1)
        _Radius("Radius", Range(0,1)) = 0.5
        [Toggle] 
        _Diagonal("Diagonal", Float) = 0
        [Toggle] 
        _Size("Size", Float) = 0
    }
    SubShader
    {
        Tags
        { 
            "RenderType" = "Opaque" 
            "LightMode" = "ForwardBase"         // first light in inspector
            "PassFlags" = "OnlyDirectional"     // only directional light
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            // declaration for Toggles ifs   
            #pragma shader_feature _DIAGONAL_ON  
            #pragma shader_feature _SIZE_ON
            #pragma shader_feature _PALETA_ON    

            // needed for IntRange 
            //#pragma multi_compile               

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "Lighting.cginc"
			#include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : POSITION;
                float3 worldNormal : TEXCOORD1; // Just a name to assign on memory but it wont be UV
                float3 viewDir : TEXCOORD2;	
                SHADOW_COORDS(3)                // Shadows data into TEXCOORD3  
            };
            

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _ColorPaleta;
            float4 _Color1;
            float4 _Color2;
            float4 _Color3;
            float4 _Color4;
            float4 _ColorHalftone;
            int _Stripes;
            float _Radius;
            int _Frequency;
            float _Halftone1;
            float _Halftone2;
            float _Halftone3;
            float _Halftone4;

            // Outline
            float _OutlineThreshold;
            float4 _OutlineColor;

            // Blinn-Phong
            float4 _AmbientColor;
			float4 _SpecularColor;
			float _Glossiness;

            float4 _RimColor;
			float _RimAmount;
			float _RimThreshold;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.viewDir = WorldSpaceViewDir(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                // Compute shadow data taken from Autolight.cginc
                TRANSFER_SHADOW(o)
                return o;
            }

            float outline(float3 normal, float3 viewDir)
            {
                return dot(normal, viewDir);
            }

            float Toon(float3 normal, float3 lightDir)
            {
                float NdotL = max(0.0,dot(normal, lightDir));
                return NdotL;
            }

            float3 halftone(float3 dots, float3 color, float2 uv, float NdotL)
            {
                /*//float2 st2 = float2x2(0.707, -0.707, 0.707, 0.707) * uv;
                float2 nearest = 2.0 * frac(_Frequency * uv) - 1.0;*/
        
                float2 st;
                #if _DIAGONAL_ON
                matrix <float, 2, 2> diagonalMatrix = { 0.707f, -0.707f, 
                                0.707f, 0.707f
                               };
                st = mul((diagonalMatrix), uv);
                #else
                st = uv;
                #endif

                float2 nearest = 2.0 * frac(_Frequency * st) - 1.0;
                float dist = length(nearest);
                float radius = _Radius;

                #if _SIZE_ON
                    radius *= sqrt(NdotL);
                #endif
                //float radius = _Radius * NdotL;
                float3 fragColor;
                if(dist < radius)
                    fragColor = dots;
                else
                    fragColor = color;
                //float3 color = mix(dots, color, smoothstep(radius, dist)); pendiente de hacer suavizado entre base y dots
                return fragColor;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float detail = 1.0f/_Stripes;

                // All info from i transformed
                float3 normal = normalize(i.worldNormal);
                float3 viewDir = normalize(i.viewDir);
                float4 position = i.vertex;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float2 uv = i.uv;
                // Value from 0 to 1 where 0 is shadow and 1 is not
                float shadow = SHADOW_ATTENUATION(i);
                float ToonRange = Toon(normal, lightDir);

                float lightIntensity = smoothstep(0, 0.01, ToonRange * shadow);	
				float4 light = lightIntensity * _LightColor0;

				// H from Blinn model
				float3 halfVector = normalize(lightDir + viewDir);
				float NdotH = dot(normal, halfVector);
				// Glossines is squared because makes easier to achieve
				// the ideal glossiness value easier in the inspector
				float specularIntensity = pow(NdotH * lightIntensity, pow(_Glossiness,2));
				float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
				float4 specular = specularIntensitySmooth * _SpecularColor;

                // Calculate rim lighting.
				float rimDot = 1 - dot(viewDir, normal);
				// We only want rim to appear on the lit side of the surface,
				// so multiply it by NdotL, raised to a power to smoothly blend it.
				float rimIntensity = rimDot * pow(ToonRange, _RimThreshold);
				rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
				float4 rim = rimIntensity * _RimColor;

                float halftones[4] =
                    {
                        _Halftone1,
                        _Halftone2,
                        _Halftone3,
                        _Halftone4
                    };
                
               #if _PALETA_ON
                    //col *= ToonRange * _ColorPaleta;
                    col.xyz *= halftone(_ColorHalftone.xyz, floor(ToonRange/detail) * _ColorPaleta, uv, ToonRange);
               #else
                    // Must be done in dinamic number
                    float4 colors[4] =
                    {
                        _Color1,
                        _Color2,
                        _Color3,
                        _Color4
                    };
                
                    for(int i = 0; i < 4; i++)
                    {
                        if(ToonRange > detail*i && ToonRange < detail*(i+1))
                        {
                            if(halftones[halftones.Length-i-1])
                                col.xyz *= halftone(_ColorHalftone.xyz, colors[colors.Length-i-1], uv, ToonRange);
                            else
                                col *= colors[colors.Length-i-1];
                        }
                    }
                #endif
                // If no halftone wanted, set frequency to 0

                float4 fragColor;
                if(outline(normal, viewDir)< _OutlineThreshold)
                {
                    fragColor.xyz = _OutlineColor.xyz;
                }
                else
                {
                    fragColor.xyz = col * (light + _AmbientColor ) + rim + specular;
                }
                fragColor.w = 1;
                return fragColor;
            }
            ENDCG
        }
    }
}
