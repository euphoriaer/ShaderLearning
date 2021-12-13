Shader "Custom/TemplateB"
{
    Properties
    {
        _MainColor("MainColor",Color)=(1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }

            Stencil
            {
                Ref 1
                Comp NotEqual
                Pass Keep
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float4 pos:SV_POSITION;
                float4 worldPos:TEXCOORD0;
                float3 worldNormal:TEXCOORD1;
                float2 texcoord:TEXCOORD2;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;
            
            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);

                float3 worldNormal=UnityObjectToWorldNormal(v.normal);
                o.worldNormal=normalize(worldNormal);
                o.texcoord=TRANSFORM_TEX(v.texcoord,_MainTex);

                return o;
            }

            fixed4 frag(v2f i):SV_TARGET
            {
                float3 worldLight=UnityWorldSpaceLightDir(i.worldPos.xyz);
                worldLight=normalize(worldLight);

                fixed NdotL=saturate(dot(i.worldNormal,worldLight));

                fixed4 color=tex2D(_MainTex,i.texcoord);
                color.rgb*=_MainColor*NdotL*_LightColor0.rgb;
                color.rgb+=unity_AmbientSky.rgb;
                return color;
            }
            ENDCG
        }
    }
}
