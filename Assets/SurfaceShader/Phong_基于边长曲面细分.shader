Shader "Custom/Phong_基于边长曲面细分"
{
    Properties
    {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _EdgeLength("_EdgeLength",Range(1,32))=1
        _Phong("Phong_Tessellation",Range(0,1))=0.2
    }
    SubShader
    {
        CGPROGRAM
        
        float _EdgeLength;
        fixed _Phong;
        //声明曲面细分函数  和Phong 细分编译指令
        #pragma surface surf Lambert tessellate:tessellateEdge  tessphong:_Phong
        #include "Tessellation.cginc"
        
        float4 tessellateEdge(appdata_full v0,appdata_full v1,appdata_full v2)
        {
            return UnityEdgeLengthBasedTess(v0.vertex,v1.vertex,v2.vertex,_EdgeLength);//传入的是三角形的三个顶点坐标，三角形在屏幕上的长度
        }

        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        sampler2D _MainTex;
        
        // 表面函数
        void surf(Input IN,inout SurfaceOutput o) 
        {
            o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;//根据lambert 模型需要输出的结构体，设置里面的值


        }
        ENDCG

    }
    FallBack "Diffuse"
}
