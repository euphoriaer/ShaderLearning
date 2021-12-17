Shader "Custom/HalfLambert"
{
   Properties
   {
      _MainColor("MainColor",color)=(1,1,1,1)
      
   }

   SubShader
   {
      pass
      {
         CGPROGRAM
         #pragma vertex vert2;
         #pragma fragment frag;

         fixed4 _MainColor;
         #include "UnityCG.cginc"
         #include "UnityLightingCommon.cginc"

         struct v2f
         {
            float4 pos:SV_POSITION;
            fixed4 dif:COLOR;
         };



         v2f vert2(appdata_base v)//appdata_base是头文件声明过的结构体
         {
           v2f o;
           o.pos=UnityObjectToClipPos(v.vertex);
           //法线向量
           float3 n=UnityObjectToWorldNormal(v.normal);
           n=normalize(n);

           //灯光方向向量
           fixed3 lignt=normalize(_WorldSpaceLightPos0.xyz);

           //漫反射公式
           fixed ndotLight=dot(n,lignt);
          o.dif=_LightColor0*_MainColor*(0.5*ndotLight+0.5);//
           return o;
         }
         
         fixed4 frag(v2f i):SV_TARGET
         {
           return i.dif;
         }
         ENDCG
      }
   }
}