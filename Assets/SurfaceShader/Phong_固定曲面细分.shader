Shader "Custom/Phong_固定曲面细分"
{
    Properties
    {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Tessellation("Tessellation",Range(1,32))=1
        _Phong("Phong_Tessellation",Range(0,1))=0.2
    }
    SubShader
    {
        CGPROGRAM
       
        half _Tessellation;
        fixed _Phong;
        //声明曲面细分函数  和Phong 细分编译指令
        #pragma surface surf Lambert tessellate:tessellation tessphong:_Phong

        

        float4 tessellation()
        {
            return _Tessellation;
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
