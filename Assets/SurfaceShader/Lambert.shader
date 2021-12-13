Shader "Custom/Lambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
    }
    SubShader
    {
        
        CGPROGRAM
        #pragma surface surf Lambert //声明表面着色器 使用Lambert模型

        struct Input 
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        fixed4 _Color;

        // 表面函数
        void surf(Input IN,inout SurfaceOutput o) 
        {
            fixed4 c=tex2D(_MainTex,IN.uv_MainTex)*_Color;

            o.Albedo=c.rgb;//根据lambert 模型需要输出的结构体，设置里面的值
        }
        ENDCG

    }
    FallBack "Diffuse"
}
