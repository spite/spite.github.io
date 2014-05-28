uniform sampler2D rnm;
uniform sampler2D tDepth;
varying vec2 vUv;
const float totStrength = 1.38;
const float strength = 0.07;
const float offset = 18.0;
const float falloff = 0.000002;
const float rad = 0.006;
#define SAMPLES 10 // 10 is good
const float invSamples = -1.38/10.0;
uniform vec3 pSphere[ 10 ];

void main(void) {
	
	// these are the random vectors inside a unit sphere
	
   // grab a normal for reflecting the sample rays later on
   vec3 fres = vec3( .5 );//normalize((texture2D(rnm,vUv*offset).xyz*2.0) - vec3(1.0));
 
   vec4 currentPixelSample = texture2D(tDepth,vUv);
 
   float currentPixelDepth = currentPixelSample.a;
 
   // current fragment coords in screen space
   vec3 ep = vec3(vUv.xy,currentPixelDepth);
  // get the normal of current fragment
   vec3 norm = currentPixelSample.xyz;
 
   float bl = 0.0;
   // adjust for the depth ( not shure if this is good..)
   float radD = rad/currentPixelDepth;
 
   //vec3 ray, se, occNorm;
   float occluderDepth, depthDifference;
   vec4 occluderFragment;
   vec3 ray;
   for(int i=0; i < SAMPLES;++i)
   {
      // get a vector (randomized inside of a sphere with radius 1.0) from a texture and reflect it
      ray = radD*reflect(pSphere[i],fres);
 
      // get the depth of the occluder fragment
      occluderFragment = texture2D(tDepth,ep.xy + sign(dot(ray,norm) )*ray.xy);
    // if depthDifference is negative = occluder is behind current fragment
      depthDifference = currentPixelDepth-occluderFragment.a;
 
      // calculate the difference between the normals as a weight
 // the falloff equation, starts at falloff and is kind of 1/x^2 falling
      bl += step(falloff,depthDifference)*(1.0-dot(occluderFragment.xyz,norm))*(1.0-smoothstep(falloff,strength,depthDifference));
   }
 
   // output the result
   gl_FragColor = vec4( 0., 0., 0., 1. );
  	gl_FragColor.r = 1.0+bl*invSamples;
  // gl_FragColor = vec4( vec3( currentPixelSample.a ), 1. );


}