Shader "Hidden/ScreenTransitionImageEffect" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _TransitionTex ("Transition Texture", 2D) = "white" {}
        _Cutoff ("Cutoff", Range(0, 1)) = 0
        _CutoffColor ("Cutoff Color", color) = (0, 0, 0, 0)
    }

    SubShader {
        Cull Off ZWrite Off ZTest Always

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct VertIn {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertOut {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            VertOut vert (VertIn v) {
                VertOut o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _TransitionTex;
            float _Cutoff;
            float4 _CutoffColor;

            fixed4 frag(VertOut i) : SV_Target{
                float transVal = tex2D(_TransitionTex, i.uv).r;

                if (transVal < _Cutoff) {
                    return _CutoffColor;
                } return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
