uniform sampler2D tInput;
uniform sampler2D tUV;
varying vec2 vUv;

uniform sampler2D hatch1;
uniform sampler2D hatch2;
uniform sampler2D hatch3;
uniform sampler2D hatch4;
uniform sampler2D hatch5;
uniform sampler2D hatch6;
uniform sampler2D paper;
uniform vec2 resolution;
uniform vec2 bkgResolution;

//uniform vec4 inkColor;
const vec4 lumcoeff = vec4(0.299,0.587,0.114,0.);

void main() {

    vec4 inkColor = vec4( 1., 1., 1., 1. );
    float luminance = dot( texture2D( tInput, vUv ), lumcoeff );
    float shading = luminance;
    vec2 uv = texture2D( tUV, vUv ).rg;

    vec4 c;
    float step = 1. / 6.;
    if( shading <= step ){   
        c = mix( texture2D( hatch6, uv ), texture2D( hatch5, uv ), 6. * shading );
    }
    if( shading > step && shading <= 2. * step ){
        c = mix( texture2D( hatch5, uv ), texture2D( hatch4, uv) , 6. * ( shading - step ) );
    }
    if( shading > 2. * step && shading <= 3. * step ){
        c = mix( texture2D( hatch4, uv ), texture2D( hatch3, uv ), 6. * ( shading - 2. * step ) );
    }
    if( shading > 3. * step && shading <= 4. * step ){
        c = mix( texture2D( hatch3, uv ), texture2D( hatch2, uv ), 6. * ( shading - 3. * step ) );
    }
    if( shading > 4. * step && shading <= 5. * step ){
        c = mix( texture2D( hatch2, uv ), texture2D( hatch1, uv ), 6. * ( shading - 4. * step ) );
    }
    if( shading > 5. * step ){
        c = mix( texture2D( hatch1, uv ), vec4( 1. ), 6. * ( shading - 5. * step ) );
    }

    vec4 src = mix( mix( inkColor, vec4( 1. ), c.r ), c, .5 );

    //gl_FragColor = texture2D( tInput, vUv );
    //gl_FragColor = vec4( uv, 0., 1. );
    gl_FragColor = src;
    
}