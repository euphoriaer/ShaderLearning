Shader "Custom/surf模板测试"
{
    Properties
    {
        _Color("Color",Color)=(1,1,1,1)
    }
    SubShader
    {

        Tags{"Queue"="AlphaTest"}
        //设置模板测试状态
        Stencil
        {
            Ref 1
            Comp NotEqual
            Pass replace
        }

        CGPROGRAM

        #pragma surface surf Lambert alpha
        struct Input 
        {
            float2 uv_MainTex;
        };
        fixed4 _Color;
        // 表面函数
        void surf(Input IN,inout SurfaceOutput o) 
        {
            o.Albedo=_Color.rgb;//根据lambert 模型需要输出的结构体，设置颜色
            o.Alpha=_Color.a;//采样贴图alpha通道，设置输出透明度
        }
        ENDCG

    }
    FallBack "Diffuse"
}