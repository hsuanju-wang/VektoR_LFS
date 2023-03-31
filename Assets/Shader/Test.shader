Shader "PBRShader_Transparent_updated"
{
    Properties
    {
        [NoScaleOffset]Texture2D_ec50edea71214e07bc4cfb77983db49f("BaseColorMap", 2D) = "white" {}
        [NoScaleOffset]Texture2D_98116176718c475ca3b239599d5b53ca("NormalMap", 2D) = "white" {}
        [NoScaleOffset]Texture2D_91f8c02a431f4308b428800cefa7b5df("RoughnessMap", 2D) = "white" {}
        [NoScaleOffset]Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9("MetallicMap", 2D) = "white" {}
        Vector1_245fbb9dcbcb4b3a86a80aab76f77f15("RoughnessStrength", Float) = 1
        Vector2_87395831f82d40a8bcbc0aabaab1f06d("Tiling", Vector) = (1, 1, 0, 0)
        [NoScaleOffset]Texture2D_52343b76b8f34c2e91b0b402cf2b7963("EmissionMap", 2D) = "black" {}
        Vector1_d4ef3517ca024ab6a8a9aca59ede67ca("EmissionStrength", Float) = 1
        Vector2_5a68a335082046e09dc20eeeb64ae333("Offset", Vector) = (0, 0, 0, 0)
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha

        Stencil {
                  Ref 10
                  ReadMask 10
                  Comp NotEqual
                  Pass Replace
              }


        ZTest LEqual
        ZWrite Off
        //ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 sh;
            #endif
            float4 fogFactorAndVertexLight;
            float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            float4 interp3 : TEXCOORD3;
            float3 interp4 : TEXCOORD4;
            #if defined(LIGHTMAP_ON)
            float2 interp5 : TEXCOORD5;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 interp6 : TEXCOORD6;
            #endif
            float4 interp7 : TEXCOORD7;
            float4 interp8 : TEXCOORD8;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2fb2815e81df4af98998364899f97e1a_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ec50edea71214e07bc4cfb77983db49f);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2fb2815e81df4af98998364899f97e1a_Out_0.tex, _Property_2fb2815e81df4af98998364899f97e1a_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_101b94000f274906a234185fce095734_R_4 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.r;
            float _SampleTexture2D_101b94000f274906a234185fce095734_G_5 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.g;
            float _SampleTexture2D_101b94000f274906a234185fce095734_B_6 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.b;
            float _SampleTexture2D_101b94000f274906a234185fce095734_A_7 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.a;
            UnityTexture2D _Property_a28efde2314f4feda1782c53d6065657_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_98116176718c475ca3b239599d5b53ca);
            float4 _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a28efde2314f4feda1782c53d6065657_Out_0.tex, _Property_a28efde2314f4feda1782c53d6065657_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_R_4 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.r;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_G_5 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.g;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_B_6 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.b;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_A_7 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.a;
            UnityTexture2D _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
            float4 _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.tex, _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_R_4 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.r;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_G_5 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.g;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_B_6 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.b;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_A_7 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.a;
            float _Property_74bda778d83f447bb2076adf2f72acbc_Out_0 = Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
            float4 _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2;
            Unity_Multiply_float(_SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0, (_Property_74bda778d83f447bb2076adf2f72acbc_Out_0.xxxx), _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2);
            UnityTexture2D _Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
            float4 _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0.tex, _Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_R_4 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.r;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_G_5 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.g;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_B_6 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.b;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_A_7 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.a;
            UnityTexture2D _Property_101c7434d996406992200e46a9aa07f9_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_91f8c02a431f4308b428800cefa7b5df);
            float4 _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_101c7434d996406992200e46a9aa07f9_Out_0.tex, _Property_101c7434d996406992200e46a9aa07f9_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_R_4 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.r;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_G_5 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.g;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_B_6 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.b;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_A_7 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.a;
            float4 _OneMinus_cd657aebf69c4753a96200697661fd57_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0, _OneMinus_cd657aebf69c4753a96200697661fd57_Out_1);
            float _Property_e13547d020f64acf9bfbaf80c6279e1c_Out_0 = Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
            float4 _Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2;
            Unity_Multiply_float(_OneMinus_cd657aebf69c4753a96200697661fd57_Out_1, (_Property_e13547d020f64acf9bfbaf80c6279e1c_Out_0.xxxx), _Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2);
            surface.BaseColor = (_SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.xyz);
            surface.NormalTS = (_SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.xyz);
            surface.Emission = (_Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2.xyz);
            surface.Metallic = (_SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0).x;
            surface.Smoothness = (_Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2).x;
            surface.Occlusion = 1;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_GBUFFER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 sh;
            #endif
            float4 fogFactorAndVertexLight;
            float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            float4 interp3 : TEXCOORD3;
            float3 interp4 : TEXCOORD4;
            #if defined(LIGHTMAP_ON)
            float2 interp5 : TEXCOORD5;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 interp6 : TEXCOORD6;
            #endif
            float4 interp7 : TEXCOORD7;
            float4 interp8 : TEXCOORD8;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2fb2815e81df4af98998364899f97e1a_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ec50edea71214e07bc4cfb77983db49f);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2fb2815e81df4af98998364899f97e1a_Out_0.tex, _Property_2fb2815e81df4af98998364899f97e1a_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_101b94000f274906a234185fce095734_R_4 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.r;
            float _SampleTexture2D_101b94000f274906a234185fce095734_G_5 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.g;
            float _SampleTexture2D_101b94000f274906a234185fce095734_B_6 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.b;
            float _SampleTexture2D_101b94000f274906a234185fce095734_A_7 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.a;
            UnityTexture2D _Property_a28efde2314f4feda1782c53d6065657_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_98116176718c475ca3b239599d5b53ca);
            float4 _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a28efde2314f4feda1782c53d6065657_Out_0.tex, _Property_a28efde2314f4feda1782c53d6065657_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_R_4 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.r;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_G_5 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.g;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_B_6 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.b;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_A_7 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.a;
            UnityTexture2D _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
            float4 _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.tex, _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_R_4 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.r;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_G_5 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.g;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_B_6 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.b;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_A_7 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.a;
            float _Property_74bda778d83f447bb2076adf2f72acbc_Out_0 = Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
            float4 _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2;
            Unity_Multiply_float(_SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0, (_Property_74bda778d83f447bb2076adf2f72acbc_Out_0.xxxx), _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2);
            UnityTexture2D _Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
            float4 _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0.tex, _Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_R_4 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.r;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_G_5 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.g;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_B_6 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.b;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_A_7 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.a;
            UnityTexture2D _Property_101c7434d996406992200e46a9aa07f9_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_91f8c02a431f4308b428800cefa7b5df);
            float4 _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_101c7434d996406992200e46a9aa07f9_Out_0.tex, _Property_101c7434d996406992200e46a9aa07f9_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_R_4 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.r;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_G_5 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.g;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_B_6 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.b;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_A_7 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.a;
            float4 _OneMinus_cd657aebf69c4753a96200697661fd57_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0, _OneMinus_cd657aebf69c4753a96200697661fd57_Out_1);
            float _Property_e13547d020f64acf9bfbaf80c6279e1c_Out_0 = Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
            float4 _Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2;
            Unity_Multiply_float(_OneMinus_cd657aebf69c4753a96200697661fd57_Out_1, (_Property_e13547d020f64acf9bfbaf80c6279e1c_Out_0.xxxx), _Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2);
            surface.BaseColor = (_SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.xyz);
            surface.NormalTS = (_SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.xyz);
            surface.Emission = (_Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2.xyz);
            surface.Metallic = (_SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0).x;
            surface.Smoothness = (_Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2).x;
            surface.Occlusion = 1;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_NORMAL_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_a28efde2314f4feda1782c53d6065657_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_98116176718c475ca3b239599d5b53ca);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a28efde2314f4feda1782c53d6065657_Out_0.tex, _Property_a28efde2314f4feda1782c53d6065657_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_R_4 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.r;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_G_5 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.g;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_B_6 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.b;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_A_7 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.a;
            surface.NormalTS = (_SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.xyz);
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2fb2815e81df4af98998364899f97e1a_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ec50edea71214e07bc4cfb77983db49f);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2fb2815e81df4af98998364899f97e1a_Out_0.tex, _Property_2fb2815e81df4af98998364899f97e1a_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_101b94000f274906a234185fce095734_R_4 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.r;
            float _SampleTexture2D_101b94000f274906a234185fce095734_G_5 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.g;
            float _SampleTexture2D_101b94000f274906a234185fce095734_B_6 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.b;
            float _SampleTexture2D_101b94000f274906a234185fce095734_A_7 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.a;
            UnityTexture2D _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
            float4 _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.tex, _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_R_4 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.r;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_G_5 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.g;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_B_6 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.b;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_A_7 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.a;
            float _Property_74bda778d83f447bb2076adf2f72acbc_Out_0 = Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
            float4 _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2;
            Unity_Multiply_float(_SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0, (_Property_74bda778d83f447bb2076adf2f72acbc_Out_0.xxxx), _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2);
            surface.BaseColor = (_SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.xyz);
            surface.Emission = (_Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2.xyz);
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2fb2815e81df4af98998364899f97e1a_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ec50edea71214e07bc4cfb77983db49f);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2fb2815e81df4af98998364899f97e1a_Out_0.tex, _Property_2fb2815e81df4af98998364899f97e1a_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_101b94000f274906a234185fce095734_R_4 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.r;
            float _SampleTexture2D_101b94000f274906a234185fce095734_G_5 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.g;
            float _SampleTexture2D_101b94000f274906a234185fce095734_B_6 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.b;
            float _SampleTexture2D_101b94000f274906a234185fce095734_A_7 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.a;
            surface.BaseColor = (_SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.xyz);
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 sh;
            #endif
            float4 fogFactorAndVertexLight;
            float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float3 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            float4 interp3 : TEXCOORD3;
            float3 interp4 : TEXCOORD4;
            #if defined(LIGHTMAP_ON)
            float2 interp5 : TEXCOORD5;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 interp6 : TEXCOORD6;
            #endif
            float4 interp7 : TEXCOORD7;
            float4 interp8 : TEXCOORD8;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2fb2815e81df4af98998364899f97e1a_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ec50edea71214e07bc4cfb77983db49f);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2fb2815e81df4af98998364899f97e1a_Out_0.tex, _Property_2fb2815e81df4af98998364899f97e1a_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_101b94000f274906a234185fce095734_R_4 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.r;
            float _SampleTexture2D_101b94000f274906a234185fce095734_G_5 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.g;
            float _SampleTexture2D_101b94000f274906a234185fce095734_B_6 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.b;
            float _SampleTexture2D_101b94000f274906a234185fce095734_A_7 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.a;
            UnityTexture2D _Property_a28efde2314f4feda1782c53d6065657_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_98116176718c475ca3b239599d5b53ca);
            float4 _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a28efde2314f4feda1782c53d6065657_Out_0.tex, _Property_a28efde2314f4feda1782c53d6065657_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_R_4 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.r;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_G_5 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.g;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_B_6 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.b;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_A_7 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.a;
            UnityTexture2D _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
            float4 _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.tex, _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_R_4 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.r;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_G_5 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.g;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_B_6 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.b;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_A_7 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.a;
            float _Property_74bda778d83f447bb2076adf2f72acbc_Out_0 = Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
            float4 _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2;
            Unity_Multiply_float(_SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0, (_Property_74bda778d83f447bb2076adf2f72acbc_Out_0.xxxx), _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2);
            UnityTexture2D _Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
            float4 _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0.tex, _Property_ee895be2e3f54c04bcb6e6f98a4bf41f_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_R_4 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.r;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_G_5 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.g;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_B_6 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.b;
            float _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_A_7 = _SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0.a;
            UnityTexture2D _Property_101c7434d996406992200e46a9aa07f9_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_91f8c02a431f4308b428800cefa7b5df);
            float4 _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0 = SAMPLE_TEXTURE2D(_Property_101c7434d996406992200e46a9aa07f9_Out_0.tex, _Property_101c7434d996406992200e46a9aa07f9_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_R_4 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.r;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_G_5 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.g;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_B_6 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.b;
            float _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_A_7 = _SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0.a;
            float4 _OneMinus_cd657aebf69c4753a96200697661fd57_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_696e332cc9bc4aeb8f3786c4e1fe33ae_RGBA_0, _OneMinus_cd657aebf69c4753a96200697661fd57_Out_1);
            float _Property_e13547d020f64acf9bfbaf80c6279e1c_Out_0 = Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
            float4 _Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2;
            Unity_Multiply_float(_OneMinus_cd657aebf69c4753a96200697661fd57_Out_1, (_Property_e13547d020f64acf9bfbaf80c6279e1c_Out_0.xxxx), _Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2);
            surface.BaseColor = (_SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.xyz);
            surface.NormalTS = (_SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.xyz);
            surface.Emission = (_Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2.xyz);
            surface.Metallic = (_SampleTexture2D_bab23b72e8634bdca161c3dcffaa3c60_RGBA_0).x;
            surface.Smoothness = (_Multiply_cdc1dc000ddb43b7a2f194743f83416e_Out_2).x;
            surface.Occlusion = 1;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_NORMAL_WS
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            // GraphFunctions: <None>

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_a28efde2314f4feda1782c53d6065657_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_98116176718c475ca3b239599d5b53ca);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0 = SAMPLE_TEXTURE2D(_Property_a28efde2314f4feda1782c53d6065657_Out_0.tex, _Property_a28efde2314f4feda1782c53d6065657_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_R_4 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.r;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_G_5 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.g;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_B_6 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.b;
            float _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_A_7 = _SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.a;
            surface.NormalTS = (_SampleTexture2D_04d46d54042448d09d964d27b7e562a6_RGBA_0.xyz);
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);


            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2fb2815e81df4af98998364899f97e1a_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ec50edea71214e07bc4cfb77983db49f);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2fb2815e81df4af98998364899f97e1a_Out_0.tex, _Property_2fb2815e81df4af98998364899f97e1a_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_101b94000f274906a234185fce095734_R_4 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.r;
            float _SampleTexture2D_101b94000f274906a234185fce095734_G_5 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.g;
            float _SampleTexture2D_101b94000f274906a234185fce095734_B_6 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.b;
            float _SampleTexture2D_101b94000f274906a234185fce095734_A_7 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.a;
            UnityTexture2D _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
            float4 _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.tex, _Property_0ccd8216022d4aa4b196a69ad1481e82_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_R_4 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.r;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_G_5 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.g;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_B_6 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.b;
            float _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_A_7 = _SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0.a;
            float _Property_74bda778d83f447bb2076adf2f72acbc_Out_0 = Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
            float4 _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2;
            Unity_Multiply_float(_SampleTexture2D_e4ccbe4ec836405da8b53c7ba5e71ef1_RGBA_0, (_Property_74bda778d83f447bb2076adf2f72acbc_Out_0.xxxx), _Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2);
            surface.BaseColor = (_SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.xyz);
            surface.Emission = (_Multiply_de5eaceefff940f9a5bfee13c99cc295_Out_2.xyz);
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float4 interp0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 Texture2D_ec50edea71214e07bc4cfb77983db49f_TexelSize;
        float4 Texture2D_98116176718c475ca3b239599d5b53ca_TexelSize;
        float4 Texture2D_91f8c02a431f4308b428800cefa7b5df_TexelSize;
        float4 Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9_TexelSize;
        float Vector1_245fbb9dcbcb4b3a86a80aab76f77f15;
        float2 Vector2_87395831f82d40a8bcbc0aabaab1f06d;
        float4 Texture2D_52343b76b8f34c2e91b0b402cf2b7963_TexelSize;
        float Vector1_d4ef3517ca024ab6a8a9aca59ede67ca;
        float2 Vector2_5a68a335082046e09dc20eeeb64ae333;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_ec50edea71214e07bc4cfb77983db49f);
        SAMPLER(samplerTexture2D_ec50edea71214e07bc4cfb77983db49f);
        TEXTURE2D(Texture2D_98116176718c475ca3b239599d5b53ca);
        SAMPLER(samplerTexture2D_98116176718c475ca3b239599d5b53ca);
        TEXTURE2D(Texture2D_91f8c02a431f4308b428800cefa7b5df);
        SAMPLER(samplerTexture2D_91f8c02a431f4308b428800cefa7b5df);
        TEXTURE2D(Texture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        SAMPLER(samplerTexture2D_c188744d004b4ef0a30c2a9f37c9c7c9);
        TEXTURE2D(Texture2D_52343b76b8f34c2e91b0b402cf2b7963);
        SAMPLER(samplerTexture2D_52343b76b8f34c2e91b0b402cf2b7963);

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_2fb2815e81df4af98998364899f97e1a_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_ec50edea71214e07bc4cfb77983db49f);
            float2 _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0 = Vector2_87395831f82d40a8bcbc0aabaab1f06d;
            float2 _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0 = Vector2_5a68a335082046e09dc20eeeb64ae333;
            float2 _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_9d31bfc9399e4caa9638c34929d25ce1_Out_0, _Property_a04a1eea9f094aa59f4fab45f2ff052f_Out_0, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float4 _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0 = SAMPLE_TEXTURE2D(_Property_2fb2815e81df4af98998364899f97e1a_Out_0.tex, _Property_2fb2815e81df4af98998364899f97e1a_Out_0.samplerstate, _TilingAndOffset_c5d0527afdda48c0a2bcb14b7b7d5843_Out_3);
            float _SampleTexture2D_101b94000f274906a234185fce095734_R_4 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.r;
            float _SampleTexture2D_101b94000f274906a234185fce095734_G_5 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.g;
            float _SampleTexture2D_101b94000f274906a234185fce095734_B_6 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.b;
            float _SampleTexture2D_101b94000f274906a234185fce095734_A_7 = _SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.a;
            surface.BaseColor = (_SampleTexture2D_101b94000f274906a234185fce095734_RGBA_0.xyz);
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    CustomEditor "ShaderGraph.PBRMasterGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}