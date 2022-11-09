Shader "Unlit/Butterfy01"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" }
        LOD 100
        Cull Off
        ZWrite Off

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex: SV_POSITION;
                float3 col: COLOR0;
            };

            float4 flap(float4 vertex, float rot)
            {
                float sinZ = sin(radians(rot));
                float cosZ = cos(radians(rot));
                float2x2 rotMaxZp = float2x2(float2(cosZ, -sinZ), float2(sinZ, cosZ));
                float2x2 rotMaxZn = float2x2(float2(cosZ, sinZ), float2(-sinZ, cosZ));
                vertex.xy = lerp(mul(rotMaxZn, vertex.xy), mul(rotMaxZp, vertex.xy), step(0, vertex.x));
                return vertex;
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.col = v.vertex.xyz;
                v.vertex = flap(v.vertex, sin(-_Time.y * 5 + v.vertex.z * 0.7) * 40 + 20);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                // fixed4 col = float4(i.col, 1);
                fixed4 col = tex2D(_MainTex, i.uv);
                // col.w = 1 * col.x;
                return col;
            }
            ENDCG
            
        }
    }
}