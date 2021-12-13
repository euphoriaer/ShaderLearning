Shader "Custom/surf透明测试"
{
    Properties
    {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
        _AlphaTest("Color",Range(0,1))=0
    }
    SubShader
    {

        Tags{"Queue"="AlphaTest"}
        CGPROGRAM
        //开启透明测试，_AlphaTest控制透明度
        //开启阴影修正（透明部分不产生阴影）
        #pragma surface surf Lambert alphatest:_AlphaTest 

        struct Input 
        {
            float2 uv_MainTex;
            
        };

        sampler2D _MainTex;


        // 表面函数
        void surf(Input IN,inout SurfaceOutput o) 
        {
            o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;//根据lambert 模型需要输出的结构体，设置颜色
            o.Alpha=tex2D(_MainTex,IN.uv_MainTex).a;//采样贴图alpha通道，设置输出透明度

        }
        ENDCG

    }
    FallBack "Diffuse"
}
