varying vec2 vUv;
uniform sampler2D tInput;
uniform sampler2D tDepth;
uniform sampler2D tBlurred;
uniform vec2 resolution;

void main() {

	vec4 a = texture2D( tInput, vUv );
	vec4 b = texture2D( tBlurred, vUv );
	vec4 d = clamp( texture2D( tDepth, vUv ), 0., 1. );
	gl_FragColor = mix( a, b, d );

}
