Shader "Unlit/ToonShaderBI"
{
    
    Properties
    {
        [Header(Main Texture)]
        [Space(5)]
        _MainTex ("  Texture", 2D) = "white" {}
        
        [Space(10)]
        [Header(Lighting Properties)]
        [Space(10)]
        // Ambient light is applied uniformly to all surfaces on the object.
		[HDR]
		_AmbientColor("   Ambient Color", Color) = (0.5,0.5,0.5,1) // 
		[HDR]
		_SpecularColor("   Specular Color", Color) = (0.9,0.9,0.9,1)
		// Controls the size of the specular reflection.
		_Glossiness("   Glossiness", Float) = 32
        [HDR]
		_RimColor("   Rim Color", Color) = (1,1,1,1)
		_RimAmount("   Rim Amount", Range(0, 1)) = 0.716
		// Control how smoothly the rim blends when approaching unlit
		// parts of the surface.
		_RimThreshold("   Rim Threshold", Range(0, 1)) = 0.1		

        [Header(Color Properties)]
        [Space(10)]
        // Number of stripes
        [IntRange]
        _Stripes("      Stripes", Range(1,5)) = 3
        // Dropdown for modes
        [KeywordEnum(Tonality, Custom)]
        _Mode("      Mode", Float) = 0

        [Header(Tonality Mode)]
        [Space(10)]
        // Tonality Mode
        [HDR]
        _ColorPaleta("      Tonality Color", Color) = (1,1,1,1)

        [Header(Custom Mode)]
        [Space(10)]
        // Custom colors
        [HDR]
        _Color1("       Color 1", Color) = (1,1,1,1)
        
        [HDR]
        _Color2("       Color 2", Color) = (1,1,1,1)
        
        [HDR]
        _Color3("       Color 3", Color) = (1,1,1,1)
        
        [HDR]
        _Color4("       Color 4", Color) = (1,1,1,1)
        
        [HDR]
        _Color5("       Color 5", Color) = (1,1,1,1)
        
        
       
        // Outline
        [Toggle]
        _Outline("Outline", Float) = 0
        [HDR]
        _OutlineColor("Outline Color", Color) = (1,1,1,1)
        _OutlineThreshold("Outline Threshold", Range(0,1)) = 0.1
        _OutlineThickness ("Outline Thickness", Range(0,.1)) = 0.03

        [Header(Halftone)]
        [Space(10)]
        // Halftone
        [IntRange]
        _Frequency("Frequency", Range(0,200)) = 0
        _Radius("Radius", Range(0,2)) = 0.5
        [Toggle] 
        _Diagonal("Diagonal", Float) = 0
        [Toggle] 
        _Size("Size", Float) = 0
        [Toggle] 
        _Halftone1("Halftone 1", Float) = 0
        [HDR]
        _ColorHalftone1("Halftone Color 1", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone2("Halftone 2", Float) = 0
        [HDR]
        _ColorHalftone2("Halftone Color 2", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone3("Halftone 3", Float) = 0
        [HDR]
        _ColorHalftone3("Halftone Color 3", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone4("Halftone 4", Float) = 0
        [HDR]
        _ColorHalftone4("Halftone Color 4", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone5("Halftone 5", Float) = 0 
        [HDR]
        _ColorHalftone5("Halftone Color 5", Color) = (1,1,1,1)
        
        [Toggle]
        _HalftoneFigures("Halftone With Texture", Float) = 0
        [Header(Halftone Texture)]
        [Space(5)]
        _HalftoneTex ("  Texture", 2D) = "white" {}
        
        
        
        
        
        

        // Tiling Stripes
        [HDR]
		_TilingColor1("Tiling Color 1", Color) = (0.0,0.0,0.0,1)
        [HDR]
		_TilingColor2("Tiling Color 2", Color) = (0.0,0.0,0.0,1)
        [HDR]
		_TilingColor3("Tiling Color 3", Color) = (0.0,0.0,0.0,1)
        [HDR]
		_TilingColor4("Tiling Color 4", Color) = (0.0,0.0,0.0,1)
        [HDR]
		_TilingColor5("Tiling Color 5", Color) = (0.0,0.0,0.0,1)
        [IntRange]
        _Tiling ("Tiling", Range(1, 500)) = 10
        _Rotation ("Rotation", Range(0, 1)) = 0
        _WarpScale ("Warp Scale", Range(0, 1)) = 0
	    _WarpTiling ("Warp Tiling", Range(1, 10)) = 1
        _WidthShift ("Width Shift", Range(-1, 1)) = 0
        [Toggle] 
        _Tiling1("Tiling 1", Float) = 0
        [Toggle] 
        _Tiling2("Tiling 2", Float) = 0
        [Toggle] 
        _Tiling3("Tiling 3", Float) = 0
        [Toggle] 
        _Tiling4("Tiling 4", Float) = 0
        [Toggle] 
        _Tiling5("Tiling 5", Float) = 0
        [Toggle] 
        _TillingSize("Size", Float) = 0

        // Miscelaneous
        [KeywordEnum(UV, Camera)]
        _Coordinates ("Coordinates", Float) = 0
        [Toggle]
        _BackColor("Back Color", Float) = 0
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
            #pragma shader_feature _OUTLINE_ON  
            #pragma shader_feature _BACKCOLOR_ON  
            #pragma shader_feature _TILINGSIZE_ON  
            #pragma shader_feature _HALFTONEFIGURES_ON  
            #pragma multi_compile   _COORDINATES_UV _COORDINATES_CAMERA    
            #pragma multi_compile   _MODE_TONALITY _MODE_CUSTOM    
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
                float4 screenPos : TEXCOORD4;
            };
            

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _HalftoneTex;
            float4 _HalftoneTex_ST;
            float4 _ColorPaleta;
            float4 _Color1;
            float4 _Color2;
            float4 _Color3;
            float4 _Color4;
            float4 _Color5;
            float4 _ColorHalftone1;
            float4 _ColorHalftone2;
            float4 _ColorHalftone3;
            float4 _ColorHalftone4;
            float4 _ColorHalftone5;
            int _Stripes;
            float _Radius;
            int _Frequency;
            float _Halftone1;
            float _Halftone2;
            float _Halftone3;
            float _Halftone4;
            float _Halftone5;
            float _HalftoneFigures; 

            // Tiling
            int _Tiling;
            float4 _TilingColor1;
            float4 _TilingColor2;
            float4 _TilingColor3;
            float4 _TilingColor4;
            float4 _TilingColor5;
            float _Rotation;
            float _WarpScale;
            float _WarpTiling;   
            float _WidthShift;   

            float _Tiling1;
            float _Tiling2;
            float _Tiling3;
            float _Tiling4;
            float _Tiling5;
            float _TillingSize;

            // Outline
            float _Outline;
            float _OutlineThreshold;
            float _OutlineThickness;
            float4 _OutlineColor;

            // Blinn-Phong
            float4 _AmbientColor;
			float4 _SpecularColor;
			float _Glossiness;

            float4 _RimColor;
			float _RimAmount;
			float _RimThreshold;

            // Miscelaneous
            float _BackColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.viewDir = WorldSpaceViewDir(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.screenPos = ComputeScreenPos(o.vertex);
                // Compute shadow data taken from Autolight.cginc
                TRANSFER_SHADOW(o)
                return o;
            }

            int outline(float3 normal, float3 viewDir)
            {
                return (dot(normal, viewDir) < _OutlineThreshold);
            }

            float Toon(float3 normal, float3 lightDir)
            {
                float NdotL;
                #if _BACKCOLOR_ON
                    NdotL = abs(dot(normal, lightDir));
                #else
                    NdotL = max(0.0, dot(normal, lightDir));
                #endif
                return NdotL;
            }

            /*float3 halftone(float3 dots, float3 color, float2 uv, float NdotL)
            {
                
                float2 st;
                #if _DIAGONAL_ON
                matrix <float, 2, 2> diagonalMatrix = { 0.707f, -0.707f, 
                                0.707f, 0.707f
                               };
                st = mul((diagonalMatrix), uv);
                #else
                st = uv;
                #endif
                //st = map(st, _RemapInputMin, _RemapInputMax, _RemapOutputMin, _RemapOutputMax);
                float2 nearest = 2.0 * frac(_Frequency * st) - 1.0;
                float dist = length(nearest);
                float radius = _Radius;

                #if _SIZE_ON
                    radius *= NdotL;
                #endif
                float3 fragColor = lerp(dots, color, smoothstep(radius*0.95, radius*1.05, dist)); // Que tenga algo que ver con la frecuencia tambien
                return fragColor;
            }*/
            float2 rotatePoint(float2 pt, float2 center, float angle)
            {
				float sinAngle = sin(angle);
				float cosAngle = cos(angle);
				pt -= center;
				float2 r;
				r.x = pt.x * cosAngle - pt.y * sinAngle;
				r.y = pt.x * sinAngle + pt.y * cosAngle;
				r += center;
				return r;
			}

            float3 tiling(float2 uv, float3 colorBack, float3 colorFront, float NdotL)
            {
                const float PI = 3.14159;
                float2 pos = rotatePoint(uv, float2(0.5, 0.5), _Rotation * 2 * PI);
                float sizeFactor;

                pos.x += sin(pos.y * _WarpTiling * PI * 2) * _WarpScale;
                pos.x *= _Tiling; 
                
                if(_TillingSize)
                    sizeFactor = (1-pow(NdotL,2));
                else
                    sizeFactor = 1;
                fixed value = floor(frac(pos) + _WidthShift * sizeFactor);
                return lerp(colorBack, colorFront, value);;
            }
            float3 halftone(float3 dots, float3 color, float2 uv, float NdotL)
            {
                float2 st;
                float3 fragColor;
                float3 backgroundThreshold = float3(0.85f,0.85f,0.85f);

                #if _DIAGONAL_ON
                matrix <float, 2, 2> diagonalMatrix = { 0.707f, -0.707f, 
                                0.707f, 0.707f
                               };
                st = mul((diagonalMatrix), uv);
                #else
                st = uv;
                #endif
                float2 nearest = 2 * frac(_Frequency * st) - 1.0;
                float dist = length(nearest);
                float radius = _Radius;
                float pixelDist = fwidth(dist);   // Multiplied by 2 because gives a bigger antialiasing effect
                #if _SIZE_ON
                    radius *= NdotL;
                #endif
                #if _HALFTONEFIGURES_ON
                    st = (st - 0.5) / _Radius + 0.5;
                    fixed4 halftoneTex = tex2D(_HalftoneTex, st*_Frequency);
                
                    if(all(halftoneTex.xyz > backgroundThreshold))
                        fragColor = halftoneTex.xyz * dots;
                    else
                        fragColor = color;
                #else
                    fragColor = lerp(dots, color, smoothstep(radius-pixelDist, radius+pixelDist, dist));
                #endif

                return fragColor;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                //fixed4 halftoneTex = tex2D(_HalftoneTex, i.uv);

                float detail = 1.0f/(_Stripes+1); // +1 because black does not count as a stripe
                
                // Colors to mix
                float3 color1;
                float3 color2;
                // All info from i transformed
                float3 normal = normalize(i.worldNormal);
                float3 viewDir = normalize(i.viewDir);
                float4 position = i.vertex;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float2 uv;
                
                //setup UVs 
                #if _COORDINATES_UV
                    uv = i.uv;
                #elif _COORDINATES_CAMERA
                    float aspect = _ScreenParams.x / _ScreenParams.y;
                    float2 screenPosition = i.screenPos.xy / i.screenPos.w;
                    screenPosition.x = screenPosition.x * aspect;
                    uv = screenPosition;
                #endif

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
               
                #if _MODE_TONALITY
                    float smooth = smoothstep(floor(1.0f + ToonRange/detail) - 0.02f, floor(1.0f + ToonRange/detail) , ToonRange/detail);
                    
                    color1 = halftone(_ColorHalftone1.xyz, floor(ToonRange/detail) * _ColorPaleta, uv, ToonRange);
                    color2 = halftone(_ColorHalftone1.xyz, floor(1+ToonRange/detail) * _ColorPaleta, uv, ToonRange);
                    float3 colNoTil = lerp(color1, color2, smooth);
                    col.xyz *= tiling(uv, colNoTil, _TilingColor1, ToonRange);
                   //col.xyz *= lerp(color1, color2, smooth);
                #elif _MODE_CUSTOM
                    int value = floor(ToonRange/detail);
                    value = clamp(value, 0, _Stripes-1);
                    switch(value)
                    {
                        case 1: 
                            if(_Halftone2)
                                col.xyz = halftone(_ColorHalftone2.xyz, _Color2, uv, ToonRange);
                            else
                                //col.xyz *= tiling(uv, col.xyz, _TilingColor);
                                col.xyz *= _Color2;
                            
                            if(_Tiling2)
                                col.xyz = tiling(uv, col.xyz, _TilingColor2, ToonRange);
                            break;
                        case 2: 
                            if(_Halftone3)
                                col.xyz = halftone(_ColorHalftone3.xyz, _Color3, uv, ToonRange);
                            else
                                col.xyz *= _Color3;
                            if(_Tiling3)
                                col.xyz = tiling(uv, col.xyz, _TilingColor3, ToonRange);
                            break;
                        case 3: 
                            if(_Halftone4)
                                col.xyz = halftone(_ColorHalftone4.xyz, _Color4, uv, ToonRange);
                            else
                                col.xyz *= _Color4;
                            if(_Tiling4)
                                col.xyz = tiling(uv, col.xyz, _TilingColor4, ToonRange);
                            break;          
                        case 4: 
                            if(_Halftone5)
                                col.xyz = halftone(_ColorHalftone5.xyz, _Color5, uv, ToonRange);
                            else
                                col.xyz *= _Color5;
                            if(_Tiling4)
                                col.xyz = tiling(uv, col.xyz, _TilingColor5, ToonRange);
                            break;          
                        default: 
                            if(_Halftone1)
                                col.xyz = halftone(_ColorHalftone1.xyz, _Color1, uv, ToonRange);
                            else
                                col.xyz *= _Color1;
                            if(_Tiling1)
                                col.xyz = tiling(uv, col.xyz, _TilingColor1, ToonRange);
                            break;
                    }
                    /*  NO BORRAR OPTIMIZACIÓN
                    for(int i = 0; i < 4; i++)
                    {
                        if(ToonRange > detail*i && ToonRange < detail*(i+1))
                        {
                            float smooth = smoothstep(floor(ToonRange/detail) - 0.01f, ToonRange/detail , floor(ToonRange/detail));
                            if(halftones[halftones.Length-i-1])
                                color1 = halftone(_ColorHalftone.xyz, colors[colors.Length-i-1], uv, ToonRange);
                            else
                                color1 = colors[colors.Length-i-1];

                            if(halftones[halftones.Length-i])
                                color2 = halftone(_ColorHalftone.xyz, colors[colors.Length-i], uv, ToonRange);
                            else
                                color2 = colors[colors.Length-i];

                            col.xyz *= lerp(color1, color2, smooth); 
                        }
                    }*/
                #endif
                
                float4 fragColor;
                int outlineEffect = 0;
                #if _OUTLINE_ON
                    outlineEffect = outline(normal, viewDir);
                #endif
                if(outlineEffect)
                {
                    fragColor.xyz = _OutlineColor.xyz;
                }
                else
                {
                fragColor.xyz = col * (light + _AmbientColor ) + rim + specular;
                fragColor.w = 1;
                }
                return fragColor;
            }
            ENDCG
        }  
            UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
