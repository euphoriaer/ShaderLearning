Shader "Custom/NewSurfaceShader"
{
   Properties
   {
      _MainColor("MainColor",Color)=(1,1,1,1)
      _SpecularColor("SpecularColor",Color)=(0,0,0,0)
      _Shininess("Shininess",Range(1,100))=1
   }

   SubShader
   {
      Pass
      {
         CGPROGRAM
         #pragma vertex vert;
         #pragma fragment frag;
         #include "UnityCG.cginc"
         #include "Lighting.cginc"
         

         struct v2f
         {
            float4 pos:SV_POSITION;
            fixed4 color:COLOR0;
         };

         fixed4 _MainColor;
         fixed4 _SpecularColor;
         half _Shininess;

         v2f vert(appdata_base v)//appdata_base是头文件声明过的结构体
         {
            v2f o;
            o.pos=UnityObjectToClipPos(v.vertex);
            //顶点法线向量
            float3 n=UnityObjectToWorldNormal(v.normal);//计算顶点的世界空间法向量，因为要在世界空间计算镜面反射
            n=normalize(n);//归一化，只需要向量方向，wo:感觉不用不到，法向量本身就是单位向量了,实测

            //灯光方向向量 顶点->灯光，所有Wordspace取到的都是顶点为起点的向量（如下面的顶点->视角方向）
            fixed3 light=normalize(_WorldSpaceLightPos0.xyz);

            //漫反射公式
            fixed ndotLight=saturate(dot(n,light));//saturate截取，避免取负
            fixed4 dif=_LightColor0*_MainColor*ndotLight;

            //计算镜面反射视角方向(顶点->人眼，摄像机方向向量)
            fixed3 view=normalize(WorldSpaceViewDir(v.vertex)); 

            //计算光线反射向量
            float3 ref=reflect(-light,n);//参数1:入射方向，参数2:法向量，函数结果:根据入射向量和法向量，计算反射向量（反射向量到法线量与入射向量到法向量的夹角相等）。
            //取-是因为入射是 灯光->顶点，所以取反
            ref=normalize(ref);
            
            // // 镜面反射公式  phong
            //  fixed rdotv=saturate(dot(ref,view));
            //  fixed4 spec=_LightColor0*_SpecularColor*pow(rdotv,_Shininess);

            //镜面反射公式  Blinn-phong
            fixed3 h=normalize(light+view);//求半角向量
            fixed ndoth=saturate(dot(n,h));
            fixed4 spec=_LightColor0*_SpecularColor*pow(ndoth,_Shininess);

            //公式
            o.color=unity_AmbientSky+dif+spec;
            //o.color=unity_AmbientSky;
            //o.color=dif;
            //o.color=spec;
            return o;
         }
         
         fixed4 frag(v2f i):SV_TARGET
         {
            return i.color;
         }
         ENDCG
      }
   }
}