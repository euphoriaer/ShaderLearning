Shader "Custom/surf混合透明"
{
    Properties
    {
        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
        _Color("Color",Color)=(1,1,1,1)
    }
    SubShader
    {

        Tags{"Queue"="Transparent"}
        CGPROGRAM
        
        #pragma surface surf Lambert alpha
        struct Input 
        {
            float2 uv_MainTex;
            
        };

        sampler2D _MainTex;
        fixed4 _Color;

        // 表面函数
        void surf(Input IN,inout SurfaceOutput o) 
        {
            o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb*_Color.rgb;//根据lambert 模型需要输出的结构体，设置颜色
            o.Alpha=tex2D(_MainTex,IN.uv_MainTex).a*_Color.a;//采样贴图alpha通道，设置输出透明度

        }
        ENDCG

    }
    FallBack "Diffuse"
}
