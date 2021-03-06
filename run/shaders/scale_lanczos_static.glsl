// scale (optimized for 720p->1080p)


uniform sampler2D source;
uniform sampler2D lanczosLut;

const float scaleFactor = 2.0/3.0;

const float xPitch = 1.0/FRAME_WIDTH;
const float yPitch = 1.0/FRAME_HEIGHT;

float lanczos(float dist, float N) {
  return texture2D(lanczosLut, vec2(dist*0.1,N)).r;
}

void main(void)
{
  vec2 tc = vec2(gl_TexCoord[0]);
  vec4 result = vec4(0.0);
  float fsum = 0.0;
  
  for(float x=-2.0*scaleFactor; x<2.1*scaleFactor; x+=scaleFactor) {
    for(float y=-2.0*scaleFactor; y<2.1*scaleFactor; y+=scaleFactor) {
      vec2 dist = vec2(x, y);
      float ll = length(dist);
      float weight = lanczos(ll, 1.0);
      fsum += weight;
      result += weight*texture2D(source, tc + dist*vec2(xPitch,yPitch));
    }
  }

  //gl_FragColor = vec4(vec3(lanczos(length((tc-0.5)*2.0), N))/2.0+0.5,1.0);
  gl_FragColor = result/fsum;
}
