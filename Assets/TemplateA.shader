Shader "Custom/Template"
{
  SubShader
  {
    Tags{"Queue"="Geometry-1"}
    Pass
    {
      // 设置模板测试转台
      Stencil
      {
        Ref 1
        Comp Always
        Pass Replace
      }

      ColorMask 0
      ZWrite Off

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      float4 vert(in float4 vertex:POSITION):SV_POSITION
      {
        float4 pos=UnityObjectToClipPos(vertex);
        return pos;

      }

      float4 frag():SV_TARGET
      {
        return fixed4(0,0,0,0);
      }
      ENDCG
    }
  }
}
