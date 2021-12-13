Shader "Custom/shadow"
{
    Properties
    {
        _MainColor("MainColor",Color)=(1,1,1,1)
    }
    SubShader
    {
        //第一个Pass为平行光投射阴影

        pass
        {

            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert;
            #pragma fragment frag;
            #pragma mult_compile_fwdbase;

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct v2f
            {
                float4 pos:SV_POSITION;
                float3 normal:TEXCOORD0;
                float4 vertex:TEXCOORD1;
                
                SHADOW_COORDS(2) //预定义宏 保存阴影坐标

            };
            fixed4 _MainColor;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.normal=v.normal;
                o.vertex=v.vertex;
                TRANSFER_SHADOW(o) //预定义宏变换阴影坐标
                return o;
            }

            fixed4 frag(v2f i):SV_TARGET
            {
                float3 n=UnityObjectToWorldNormal(i.normal);
                n=normalize(n);

                float3  light=WorldSpaceLightDir(i.vertex);
                light=normalize(light);
                float4 worldPos=mul(unity_ObjectToWorld,i.vertex);

                //Lambert 光照
                fixed ndotL=saturate(dot(n,light));
                fixed4 color=_LightColor0*_MainColor*ndotL;

                //加上4个点光源的光照
                color.rgb+=Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
                unity_LightColor[0].rgb,
                unity_LightColor[1].rgb,
                unity_LightColor[2].rgb,
                unity_LightColor[3].rgb,
                unity_4LightAtten0,worldPos.rgb,n)*_MainColor;

                //加环境光照
                color+=unity_AmbientSky;
                //计算阴影系数
                UNITY_LIGHT_ATTENUATION(shadowmask,i,worldPos.rgb)
                //阴影合成
                color.rgb*=shadowmask;
                return color;
            }
            ENDCG
         }

        //为其余逐像素灯光产生投影，important或者自动识别成为逐像素渲染的灯光
        pass
        {
            Tags{"LightMode"="ForwardAdd"}//forwardAdd与forwardBase区别？
            
            //与上一个pass 混合模式
            Blend one one
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct v2f
            {
                float4 pos:SV_POSITION;
                float3 normal:TEXCOORD0;
                float4 vertex:TEXCOORD1;
                SHADOW_COORDS(2)//使用预定义宏保存阴影图标
            };

            fixed4 _MainColor;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.normal=v.normal;
                o.vertex=v.vertex;
                TRANSFER_SHADOW(o) //预定义宏变换阴影坐标
                return o;

            }
            
            fixed4 frag(v2f i):SV_TARGET
            {
                //法向量
                float3 n=UnityObjectToWorldNormal(i.normal);
                n=normalize(n);

                //灯光
                float3 light=WorldSpaceLightDir(i.vertex);
                light=normalize(light);

                float4 worldPos=mul(unity_ObjectToWorld,i.vertex);

                //Lambert 光照
                fixed ndotL=saturate(dot(n,light));
                fixed4 color=_LightColor0*_MainColor*ndotL;

                //加上4个点光源的光照
                color.rgb+=Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
                unity_LightColor[0].rgb,
                unity_LightColor[1].rgb,
                unity_LightColor[2].rgb,
                unity_LightColor[3].rgb,
                unity_4LightAtten0,worldPos.rgb,n)*_MainColor;

                
                //计算阴影系数
                UNITY_LIGHT_ATTENUATION(shadowmask,i,worldPos.rgb)
                //阴影合成
                color.rgb*=shadowmask;
                return color;
            }
            ENDCG
        }

    }

    Fallback "Diffuse"
}
