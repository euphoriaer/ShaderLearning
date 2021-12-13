Shader "Custom/膨胀"
{
    Properties
    {
        _Expansion("Expansion",Range(0,0.1))=0
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
    }
    SubShader
    {
        CGPROGRAM
        //声明表面着色器 使用Lambert模型,声明顶点修改函数
        #pragma surface surf Lambert vertex:vert 
        

        struct Input 
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed _Expansion;

        // 顶点函数
        void vert(inout appdata_full v) //appdata_full 既是顶点输入，也是输出
        {
            v.vertex.xyz+=v.normal*_Expansion;// 将顶点的xyz 加上法线乘以膨胀系数的值，结果是每个顶点向法线方向移动一段距离，即膨胀效果
        }

        // 表面函数
        void surf(Input IN,inout SurfaceOutput o) 
        {
            o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;//根据lambert 模型需要输出的结构体，设置里面的值
        }
        ENDCG

    }
    FallBack "Diffuse"
}
