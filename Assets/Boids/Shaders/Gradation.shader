Shader "Unlit/Gradation"
{
    Properties
    {
        _Color1 ("Color1", Color) = (1, 1, 1, 1)
        _Color2 ("Color2", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Background" "Queue" = "Background" "PreviewType" = "Skybox" }
        LOD 100
        
        Pass
        {
            ZWrite Off
            Cull Off
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex: POSITION;
                float3 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 vertex: SV_POSITION;
                float3 texcoord: TEXCOORD0;
            };
            fixed4 _Color1;
            fixed4 _Color2;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                return lerp(_Color2, _Color1, i.texcoord.y * 0.5 + 0.5);
            }
            ENDCG
            
        }
    }
}
