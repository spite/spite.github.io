varying vec2 vUv;
uniform vec2 repeat;
varying vec3 vNormal;

void main() {

	gl_FragColor = vec4( mod( vUv * repeat, vec2( 1. ) ), 0., 1. );
//	gl_FragColor = vec4( mod( vNormal.xy * repeat, vec2( 1. ) ), 0., 1. );

}	