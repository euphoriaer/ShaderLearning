Shader "Custom/AlphaShader"
{
    Properties
    {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _AlphaTest("Alpha Test",Range(0,1))=0
    }
    SubShader
    {  
        Tags
        {
            "Queue"="AlphaTest"
            "RenderType"="TrannsparentCutout"
            "IgnoreProjector"="True"
        }

        pass
        {
            Tags { "LightMode"="ForwardBase" }
          
            Cull Off
            CGPROGRAM
            #pragma fragment frag
            #pragma vertex vert 
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            
            struct v2f 
            {
                float4 pos:SV_POSITION;
                float4 worldPos:TEXCOORD0;
                float2 texcoord:TEXCOORD1;
                float3 worldNormal:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _AlphaTest;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);
                o.texcoord=TRANSFORM_TEX(v.texcoord,_MainTex);


                float3 worldNormal=UnityObjectToWorldNormal(v.normal);
                o.worldNormal=normalize(worldNormal);

                return o;
            }

            fixed4 frag(v2f i):SV_TARGET
            {
                float3 worldLight=UnityWorldSpaceLightDir(i.worldPos.xyz);
                worldLight=normalize(worldLight);
                fixed NdotL=saturate(dot(i.worldNormal,worldLight));
                fixed4 color=tex2D(_MainTex,i.texcoord);

                //开启Alpha测试
                clip(color.a-_AlphaTest);
               
                color.rgb*=NdotL*_LightColor0;
                color.rgb+=unity_AmbientSky;
                return color;
            }
            ENDCG
        }
    }
}
