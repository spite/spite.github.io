varying vec2 vUv;
uniform sampler2D tDepth;
uniform sampler2D tInput;
uniform vec2 resolution;

//uniform sampler2D LuminanceTexture;

#define PI 3.14159265

float width = resolution.x; //texture width
float height = resolution.y; //texture height

float near = 1.0; //Z-near
float far = 5000.0; //Z-far

int samples = 3; //samples on the each ring (3-7)
int rings = 3; //ring count (2-8)

vec2 texCoord = vUv;

vec2 rand(in vec2 coord) //generating random noise
{
float noiseX = (fract(sin(dot(coord ,vec2(12.9898,78.233))) * 43758.5453));
float noiseY = (fract(sin(dot(coord ,vec2(12.9898,78.233)*2.0)) * 43758.5453));
return vec2(noiseX,noiseY)*0.004;
}

float readDepth(in vec2 coord) 
{
return (2.0 * near) / (far + near - texture2D(tDepth, coord ).x * (far-near)); 
}

float compareDepths( in float depth1, in float depth2 )
{
float aoCap = 1.0;
float aoMultiplier = 100.0;
float depthTolerance = 0.0000;
float aorange = 60.0;// units in space the AO effect extends to (this gets divided by the camera far range
float diff = sqrt(clamp(1.0-(depth1-depth2) / (aorange/(far-near)),0.0,1.0));
float ao = min(aoCap,max(0.0,depth1-depth2-depthTolerance) * aoMultiplier) * diff;
return ao;
}

void main(void)
{	
float depth = readDepth(texCoord);
float d;

float aspect = width/height;
vec2 noise = rand(texCoord);

float w = (1.0 / width)/clamp(depth,0.05,1.0)+(noise.x*(1.0-noise.x));
float h = (1.0 / height)/clamp(depth,0.05,1.0)+(noise.y*(1.0-noise.y));

float pw;
float ph;

float ao;	
float s;

for (int i = -3 ; i < 3; i += 1)
{
for (int j = -3 ; j < 3; j += 1)
{
float step = PI*2.0 / float(samples*i);
pw = (cos(float(j)*step)*float(i));
ph = (sin(float(j)*step)*float(i))*aspect;
d = readDepth( vec2(texCoord.s+pw*w,texCoord.t+ph*h));
ao += compareDepths(depth,d);	
s += 1.0;
}
}

ao /= s;
ao = 1.0-ao;	

vec3 color = texture2D(tInput,texCoord).rgb;
vec3 luminance = vec3( 1. );//texture2D(LuminanceTexture,texCoord).rgb;
vec3 white = vec3(1.0,1.0,1.0);
vec3 black = vec3(0.0,0.0,0.0);
vec3 treshold = vec3(0.2,0.2,0.2);

luminance = vec3( 0. );//clamp(max(black,luminance-treshold)+max(black,luminance-treshold)+max(black,luminance-treshold),0.0,1.0);

gl_FragColor = vec4(color*mix(vec3(ao,ao,ao),white,luminance),1.0);
//gl_FragColor = vec4( vec3( ao ), 1. );
//gl_FragColor = texture2D( tDepth, vUv );
}