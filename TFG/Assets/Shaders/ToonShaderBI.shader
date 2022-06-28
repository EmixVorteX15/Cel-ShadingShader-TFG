Shader "Unlit/ToonShaderBI"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        [IntRange]
        _Stripes("Stripes", Range(0,10)) = 3
        
        _Color1("Color1", Color) = (1,1,1,1)
        _Color2("Color2", Color) = (1,1,1,1)
        _Color3("Color3", Color) = (1,1,1,1)
        _Color4("Color4", Color) = (1,1,1,1)
        
        [Toggle] 
        _Paleta("Paleta de colores", Float) = 0
        
        _ColorPaleta("ColorPaleta", Color) = (1,1,1,1)

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
            #pragma shader_feature      // needed for Toggle
            #pragma shader_feature _PALETA_ON
            #pragma multi_compile       // needed for IntRange too

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
                float4 vertex : SV_POSITION;
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
            int _Stripes;

            float Toon(float3 normal, float3 lightDir)
            {
                float NdotL = max(0.0,dot(normalize(normal), normalize(lightDir)));
                float detail = 1.0f/_Stripes;
                #if _PALETA_ON
                    return floor(NdotL/detail);
                #else
                    return NdotL;
                #endif
            }
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
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
               #if _PALETA_ON
                    col *= Toon(normal, _WorldSpaceLightPos0.xyz) * _ColorPaleta;
               #else
                    
                    float4 colors[4] =
                    {
                        _Color1,
                        _Color2,
                        _Color3,
                        _Color4
                    };
                
                    for(int i = 0; i < 4; i++)
                    {
                        if(Toon(normal, _WorldSpaceLightPos0.xyz) > detail*i &&  Toon(normal, _WorldSpaceLightPos0.xyz) < detail*(i+1))
                        {
                            col = colors[colors.Length-i-1];
                        }
                    }
                #endif
                // apply fog
                return col;
            }
            ENDCG
        }
    }
}
