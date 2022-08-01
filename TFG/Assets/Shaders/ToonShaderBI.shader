Shader "Unlit/ToonShaderBI"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
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
        Tags { "RenderType"="Opaque" }
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
            #pragma multi_compile               

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

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
                float4 color : COLOR;
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

            float outline(float3 normal, float3 pos)
            {
                float3 ecPos = -_WorldSpaceCameraPos + pos;
                return dot(normalize(normal), normalize(ecPos));
            }

            float Toon(float3 normal, float3 lightDir)
            {
                float NdotL = max(0.0,dot(normalize(normal), normalize(lightDir)));
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.color = _LightColor0;
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float detail = 1.0f/_Stripes;
                float3 normal = i.worldNormal;
                float4 position = mul(UNITY_MATRIX_MV,i.vertex);
                float2 uv = i.uv;
                float halftones[4] =
                    {
                        _Halftone1,
                        _Halftone2,
                        _Halftone3,
                        _Halftone4
                    };
                float ToonRange = Toon(normal, _WorldSpaceLightPos0.xyz);
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
                if(outline(normal, position)< 0.01)
                {
                    fragColor.xyz = float3(1.0f,1.0f,1.0f);
                }
                else
                {
                    fragColor.xyz = col;
                }
                fragColor.w = 1;
                return fragColor;
            }
            ENDCG
        }
    }
}
