uniform sampler2D tInput;
uniform vec2 resolution;
varying vec2 vUv;

uniform sampler2D fromMap;
uniform sampler2D toMap;
uniform float mixRatio;

void main() {

	vec4 from = texture2D( fromMap, vUv );
	vec4 to = texture2D( toMap, vUv );
	
	gl_FragColor = vec4( mix( from.rgb, to.rgb, mixRatio ), 1. );

}