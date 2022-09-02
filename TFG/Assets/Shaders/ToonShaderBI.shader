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
		_AmbientColor("      Ambient Color", Color) = (0.5,0.5,0.5,1) // 
		[HDR]
		_SpecularColor("      Specular Color", Color) = (0.9,0.9,0.9,1)
		// Controls the size of the specular reflection.
		_Glossiness("      Glossiness", Float) = 32

        [HDR]
		_RimColor("      Rim Color", Color) = (1,1,1,1)
		_RimAmount("      Rim Amount", Range(0, 1)) = 0.716
		// Control how smoothly the rim blends when approaching unlit
		// parts of the surface.
		_RimThreshold("      Rim Threshold", Range(0, 1)) = 0.1		

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
        
        
       
        [Header(Outline)]
        [Space(10)]
        // Outline
        [KeywordEnum(None, Scale, Dot)]
        _Outline("      Outline", Float) = 0
        [HDR]
        _OutlineColor("      Outline Color", Color) = (1,1,1,1)
        _OutlineThreshold("      Outline Threshold", Range(0,1)) = 0.1
        _OutlineThickness ("      Outline Thickness", Range(0,.1)) = 0.03

        [Header(Halftone colors)]
        [Space(10)]
        // Halftone
        
        [Toggle] 
        _Halftone1("      Halftone 1", Float) = 0
        [HDR]
        _ColorHalftone1("      Color", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone2("      Halftone 2", Float) = 0
        [HDR]
        _ColorHalftone2("      Color", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone3("      Halftone 3", Float) = 0
        [HDR]
        _ColorHalftone3("      Color", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone4("      Halftone 4", Float) = 0
        [HDR]
        _ColorHalftone4("      Color", Color) = (1,1,1,1)
        [Toggle] 
        _Halftone5("      Halftone 5", Float) = 0 
        [HDR]
        _ColorHalftone5("      Color", Color) = (1,1,1,1)
        
        [Header(Halftone Params)]
        [Space(5)]
        [IntRange]
        _Frequency("      Frequency", Range(0,200)) = 0
        _Radius("      Radius", Range(0,2)) = 0.5
        [Toggle] 
        _Diagonal("      Diagonal", Float) = 0
        [KeywordEnum(None, Smaller, Bigger)]
        _Size("      Modify Size", Float) = 0

        
        [Header(Halftone Texture)]
        [Space(5)]
        _HalftoneTex ("  Texture", 2D) = "white" {}
        [Toggle]
        _HalftoneFigures("Halftone With Texture", Float) = 0
        
        [Header(Tiling)]
        [Space(5)]
        // Tiling Stripes
        [Toggle] 
        _Tiling1("      Tiling 1", Float) = 0
        [HDR]
		_TilingColor1("       Color", Color) = (0.0,0.0,0.0,1)
        [Toggle] 
        _Tiling2("      Tiling 2", Float) = 0
        [HDR]
		_TilingColor2("       Color", Color) = (0.0,0.0,0.0,1)
        [Toggle] 
        _Tiling3("      Tiling 3", Float) = 0
        [HDR]
		_TilingColor3("       Color", Color) = (0.0,0.0,0.0,1)
        [Toggle] 
        _Tiling4("      Tiling 4", Float) = 0
        [HDR]
		_TilingColor4("       Color", Color) = (0.0,0.0,0.0,1)
        [Toggle] 
        _Tiling5("      Tiling 5", Float) = 0
        [HDR]
		_TilingColor5("       Color", Color) = (0.0,0.0,0.0,1)

        [Header(Tiling params)]
        [Space(10)]
        [IntRange]
        _Tiling ("      Tiling", Range(0, 500)) = 10
        _WidthShift ("      Width Shift", Range(-1, 1)) = 0
        _Rotation ("      Rotation", Range(0, 1)) = 0
        _WarpScale ("      Warp Scale", Range(0, 1)) = 0
	    _WarpTiling ("      Warp Tiling", Range(1, 10)) = 1
        
        [KeywordEnum(None, Smaller, Bigger)]
        _TilingSize("      Modify Size", Float) = 0
        
        [Header(Miscellaneous)]
        [Space(10)]
        // Miscelaneous
        [KeywordEnum(UV, Screenspace)]
        _Coordinates ("      Coordinates", Float) = 0
        [Toggle]
        _BackColor("      Back Color", Float) = 0
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
            #pragma shader_feature _OUTLINE_ON  
            #pragma shader_feature _BACKCOLOR_ON  
            #pragma shader_feature _HALFTONEFIGURES_ON 

            // declaration for keywords enumerations 
            #pragma multi_compile   _COORDINATES_UV _COORDINATES_SCREENSPACE
            #pragma multi_compile   _MODE_TONALITY _MODE_CUSTOM    
            #pragma multi_compile   _SIZE_NONE _SIZE_BIGGER _SIZE_SMALLER 
            #pragma multi_compile   _TILINGSIZE_NONE _TILINGSIZE_BIGGER _TILINGSIZE_SMALLER 
            #pragma multi_compile   _OUTLINE_NONE _OUTLINE_SCALE _OUTLINE_DOT

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
                float4 screenPos : TEXCOORD4;   // Needed for coordinates of screenspace
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
                // Computes shadows taken from Autolight.cginc
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

            float2 rotate(float2 pt, float2 center, float angle)
            {
				float sinAngle = sin(angle);
				float cosAngle = cos(angle);
				pt -= center;
                matrix <float, 2, 2> rotateZ = { cosAngle, -sinAngle, 
                                sinAngle, cosAngle
                               };
                pt = mul(rotateZ, pt);
				pt += center;
				return pt;
			}

            float3 tiling(float2 uv, float3 colorBack, float3 colorFront, float NdotL)
            {
                float PI = 3.14159;
                float2 pos = rotate(uv, float2(0.5, 0.5), _Rotation * 2 * PI);
                float sizeFactor;

                pos.x += sin(pos.y * _WarpTiling * PI * 2) * _WarpScale;
                pos.x *= _Tiling; 
                
                #if _TILINGSIZE_BIGGER
                    sizeFactor = pow((1-pow(NdotL,2)),-1);
                #elif _TILINGSIZE_SMALLER
                    sizeFactor = (1-NdotL);
                #else
                    sizeFactor = 1;
                #endif

                float value = floor(frac(pos) + _WidthShift * sizeFactor);
                return lerp(colorBack, colorFront, value);;
            }

            float3 halftone(float3 dots, float3 color, float2 uv, float NdotL)
            {
                float2 st;
                float3 fragColor;
                float3 backgroundThreshold = float3(0.85f,0.85f,0.85f);

                matrix <float, 2, 2> diagonalMatrix = 
                    {   
                        0.707f, -0.707f, 
                        0.707f, 0.707f
                    };

                #if _DIAGONAL_ON
                    st = mul((diagonalMatrix), uv);
                #else
                    st = uv;
                #endif

                float2 nearest = 2 * frac(_Frequency * st) - 1.0;
                float dist = length(nearest);
                float radius;
                float pixelDist = fwidth(dist); 

                #if _SIZE_BIGGER
                    radius = _Radius*pow(NdotL,2);
                #elif _SIZE_SMALLER
                    radius = _Radius*pow(NdotL,-1);
                #else 
                    radius = _Radius;
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
                
                // Colors
                float3 color1;
                float3 color2;
                float4 specular;
                float4 rim;
                
                // All info from i transformed
                float3 normal = normalize(i.worldNormal);
                float3 viewDir = normalize(i.viewDir);
                float4 position = i.vertex;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float2 uv;
                
                //setup UVs 
                #if _COORDINATES_UV
                    uv = i.uv;
                #elif _COORDINATES_SCREENSPACE
                    float aspect = _ScreenParams.x / _ScreenParams.y;
                    float2 screenPosition = i.screenPos.xy / i.screenPos.w;
                    screenPosition.x = screenPosition.x * aspect;
                    uv = screenPosition;
                #endif

                // Value from 0 to 1 where 0 is shadow and 1 is not
                float shadow = SHADOW_ATTENUATION(i);
                float ToonRange = Toon(normal, lightDir);

                // Light Calculation
                float lightIntensity = smoothstep(0, 0.01, ToonRange * shadow);	
				float4 light = lightIntensity * _LightColor0;

                // SPECULAR
                // H needed for Blinn
                float3 halfVector = normalize(lightDir + viewDir);
                float NdotH = dot(normal, halfVector);
                // Glossines is squared because makes easier to achieve
                // the ideal glossiness value in the inspector
                float specularIntensity = pow(NdotH, pow(_Glossiness,2));
                specularIntensity = smoothstep(0.005, 0.01, specularIntensity);
                
                specular = specularIntensity * _SpecularColor;

                // RIM
                float rimDot = 1 - dot(viewDir, normal);
                // We only want rim to appear on the lit side of the surface,
                // so multiply it by NdotL, raised to a power to smoothly blend it.
                float rimIntensity = rimDot * pow(ToonRange, _RimThreshold);
                rimIntensity = smoothstep((1-_RimAmount) - 0.01, (1-_RimAmount) + 0.01, rimIntensity);
                rim = rimIntensity * _RimColor;
                
                int range = floor(ToonRange/detail);
                float pixelDist = 2*fwidth(ToonRange/detail); 
                float antiaAliasFactor = smoothstep(range+1 - pixelDist, range+1, ToonRange/detail);

                #if _MODE_TONALITY
                                        
                    color1 = halftone(_ColorHalftone1.xyz, range * _ColorPaleta, uv, ToonRange);
                    color2 = halftone(_ColorHalftone1.xyz, (range+1) * _ColorPaleta, uv, ToonRange);
                    float3 colNoTil = lerp(color1, color2, antiaAliasFactor);
                    col.xyz *= tiling(uv, colNoTil, _TilingColor1, ToonRange);
                #elif _MODE_CUSTOM
                   
                    range = clamp(range, 0, _Stripes-1);
                    float3 baseColor, baseColor2, halfColor, tilColor;
                    float halftone_bool, tiling_bool;
                    switch(range)
                    {
                        case 1: 
                            baseColor = _Color2;
                            baseColor2 = _Color3;

                            halftone_bool = _Halftone2;
                            halfColor = _ColorHalftone2.xyz;

                            tiling_bool = _Tiling2;
                            tilColor = _TilingColor2;
                            break;
                        case 2: 
                            baseColor = _Color3;
                            baseColor2 = _Color4;

                            halftone_bool = _Halftone3;
                            halfColor = _ColorHalftone3.xyz;

                            tiling_bool = _Tiling3;
                            tilColor = _TilingColor3;
                            break;
                        case 3: 
                            baseColor = _Color4;
                            baseColor2 = _Color5;

                            halftone_bool = _Halftone4;
                            halfColor = _ColorHalftone4.xyz;

                            tiling_bool = _Tiling4;
                            tilColor = _TilingColor4;
                            break;       
                        case 4: 
                            baseColor = _Color5;
                            baseColor2 = _Color5;

                            halftone_bool = _Halftone5;
                            halfColor = _ColorHalftone5.xyz;

                            tiling_bool = _Tiling5;
                            tilColor = _TilingColor5;
                            break;  
                        default: 
                            baseColor = _Color1;
                            baseColor2 = _Color2;

                            halftone_bool = _Halftone1;
                            halfColor = _ColorHalftone1.xyz;

                            tiling_bool = _Tiling1;
                            tilColor = _TilingColor1;
                            break;
                    }
                    float3 color_aux = lerp(baseColor, baseColor2, antiaAliasFactor);
                    if(halftone_bool)
                        col.xyz = halftone(halfColor.xyz, color_aux, uv, ToonRange);
                    else if(tiling_bool)
                        col.xyz = tiling(uv, color_aux, tilColor, ToonRange);
                    else
                        col.xyz *= color_aux;

                    
                #endif
                
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

                float4 fragColor;
                int outlineEffect;
                #if _OUTLINE_DOT
                    outlineEffect = outline(normal, viewDir);
                #else
                    outlineEffect = 0;
                #endif
                float4 finalColor = (col * (light + _AmbientColor )  + rim + specular);
                fragColor.xyz = lerp(finalColor, _OutlineColor.xyz, outlineEffect);
                fragColor.w = 1;
                return fragColor;
            }
            ENDCG
        }  
        
        Pass{
            Cull Front

            CGPROGRAM
            
                //include useful shader functions
                #include "UnityCG.cginc"

                //define vertex and fragment shader
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile   _OUTLINE_NONE _OUTLINE_SCALE _OUTLINE_DOT

                //tint of the texture
                fixed4 _OutlineColor;
                float _OutlineThickness;

                //the object data that's put into the vertex shader
                struct appdata{
                    float4 vertex : POSITION;
                    float4 normal : NORMAL;
                };

                //the data that's used to generate fragments and can be read by the fragment shader
                struct v2f{
                    float4 position : SV_POSITION;
                };
                
                //the vertex shader
                v2f vert(appdata v){

                    v2f o;
                    //convert the vertex positions from object space to clip space so they can be rendered
                    #if _OUTLINE_SCALE
                        o.position = UnityObjectToClipPos(v.vertex + normalize(v.normal) * _OutlineThickness);
                    #else 
                        o.position = UnityObjectToClipPos(v.vertex);
                    #endif
                    return o;
                }

                //the fragment shader
                fixed4 frag(v2f i) : SV_TARGET{
                    return _OutlineColor;
                }
                
            ENDCG
        }
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
            
