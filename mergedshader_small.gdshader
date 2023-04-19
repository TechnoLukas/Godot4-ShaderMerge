//originally https://www.shadertoy.com/view/ltcGDl
//originally https://www.shadertoy.com/view/ldSBRc
// with mainly https://github.com/jayaarrgh/shadertoy2godot and hand fixing

shader_type canvas_item;
uniform vec2 iMouse;
//--------------------------------------------------HUD

//originally https://www.shadertoy.com/view/ldSBRc
// with mainly https://github.com/jayaarrgh/shadertoy2godot and hand fixing

float getBox(vec2 st, float left, float bottom, float width, float height) {
    float sm = 0.002;
    float x_range = smoothstep(left - sm, left, st.x) - smoothstep(left + width, left + width + sm, st.x);
    float y_range = smoothstep(bottom - sm, bottom, st.y) - smoothstep(bottom + height,bottom + height + sm, st.y);
    
    return x_range * y_range;
}

float getCircle(vec2 st, vec2 center, float radius, float thickness, float sm) {
    float distance = distance(st, center);
    return smoothstep(radius, radius + sm, distance) - smoothstep(radius + thickness, radius + thickness + sm, distance);
}

float getDottedCircle(vec2 st, vec2 center, float radius, float thickness, float sm) {
    float distance = distance(st, center);
    float circle = smoothstep(radius, radius + sm, distance) - smoothstep(radius + thickness, radius + thickness + sm, distance);
    
    vec2 vector = center - st;
    float angle = atan(vector.y, vector.x);
    angle = ((angle * 0.5) + (3.14 * 0.5)) / 3.14;
    circle *= step(8., mod(floor(angle / 0.001), 10.0));
    
    return circle;
}

mat2 rotate(in float angle) {
    return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

vec2 getRotation(vec2 st, vec2 origin, float angle) {
    vec2 rotatedCoord = st - vec2(origin);
    rotatedCoord = rotate(angle) * rotatedCoord;
    rotatedCoord += vec2(origin);
    
    return rotatedCoord;
}

mat2 scale(in float x, in float y) {
    return mat2(vec2(x, 0.0),vec2(.0, y));
}

vec2 getScaling(vec2 st, vec2 origin, float x, float y) {
    vec2 scaledCoord = st - vec2(origin);
    scaledCoord = scale(x, y) * scaledCoord;
    scaledCoord += vec2(origin);
    
    return scaledCoord;
}

float getInnetDial(vec2 st, float center, float radius) {
 	float lineThickness = 0.002;
    float sm = 0.003;
    
    float circle2 = getCircle(st, vec2(center), radius - 0.015, lineThickness, sm);
    circle2 *= step(st.x, -0.254);
    
    float circle2dash1 = getBox(st, -0.254, 0.134, 0.100, lineThickness);
    circle2 += circle2dash1;
    float circle2dash1_2 = getBox(st, -0.204, 0.134, 0.052, lineThickness * 2.);
    circle2 += circle2dash1_2;
    float circle2dash2 = getBox(st, -0.288, 0.068, 0.031, lineThickness);
    circle2 += circle2dash2;
    float circle2dash2_2 = getBox(st, -0.247, 0.068, 0.096, lineThickness);
    circle2 += circle2dash2_2;
    float circle2dash3 = getBox(st, -0.350, 0.0, 0.215, lineThickness);
    circle2 += circle2dash3;
    float circle2dash3_2 = getBox(st, -0.19, 0.0, 0.055, lineThickness * 2.);
    circle2 += circle2dash3_2;
    float circle2dash3_3 = getBox(st, -0.36, 0.0, lineThickness * 2., lineThickness * 2.);
    circle2 += circle2dash3_3;
    float circle2dash4 = getBox(st, -0.288, -0.068, 0.031, lineThickness);
    circle2 += circle2dash4;
    float circle2dash4_2 = getBox(st, -0.247, -0.068, 0.096, lineThickness);
    circle2 += circle2dash4_2;
    
    float circle2dash5 = getBox(st, -0.13, 0.0, 0.01, lineThickness);
    circle2 += circle2dash5;
    float circle2dash5_1 = getBox(st, -0.12, -0.03, lineThickness, 0.06);
    circle2 += circle2dash5_1;
    float circle2dash5_2 = getBox(st, -0.118, 0.03, 0.01, lineThickness);
    circle2 += circle2dash5_2;
    float circle2dash5_3 = getBox(st, -0.118, -0.03, 0.01, lineThickness);
    circle2 += circle2dash5_3;
    
    return circle2;
}

float getSideLine(vec2 st, float left, float top, float lineThickness) {
    float lineEdgeLength = 0.008;
    float sideLine = getBox(st, left, top, lineThickness, 0.236);
    sideLine += getBox(st, left + lineThickness, top + 0.234, lineEdgeLength, lineThickness);
    sideLine += getBox(st, left + lineThickness, top, lineEdgeLength, lineThickness);
    sideLine += getBox(st, left + lineThickness + 0.006, 0.0, lineThickness, lineThickness);
    
    return sideLine;
}

vec4 HUD_fragment(vec2 SPS, vec2 UVp, vec4 C) {//SPS SCREEN_PIXEL_SIZE,  FC FRAGCOORD
	//vec2 st = FRAGCOORD.xy.xy / (1.0/SCREEN_PIXEL_SIZE).xy;
    //st -= 0.5;
    //st.x *= (1.0/SCREEN_PIXEL_SIZE).x/(1.0/SCREEN_PIXEL_SIZE).y;
	vec2 uv = UVp;
	uv.y=uv.y-0.5;
	uv.x=uv.x-0.5;
	uv.x=uv.x*1.75; //temp solution, until i will find better one
	uv.y=uv.y*0.75; //temp solution, until i will find better one
	vec2 st=uv;
	//COLOR = vec4(st,0.5+0.5*sin(TIME),1.0);
    
    float center = 0.0;
    float radius = 0.3;
    float sm = 0.003;
    float lineThickness = 0.002;
    float angle = atan(st.y, st.x);
    angle = (angle + 3.1416) / (2.0 * 3.1416);

    vec3 color = vec3(0.);
    
    st = getRotation(st, vec2(center), -TIME);
    float circle1 = getCircle(st, vec2(0.), radius, lineThickness, sm);
    circle1 *= (step(st.x, -0.25) + step(0.25, st.x));
    st = getRotation(st, vec2(center), TIME);
    
    
    
    float dottedCircle = getDottedCircle(st, vec2(center), radius + 0.015, lineThickness + 0.002, sm);
    dottedCircle *= (
        (step(0.02, angle) - step(0.08, angle)) +
        (step(0.09, angle) - step(0.16, angle)) +
        (step(0.32, angle) - step(0.4, angle)) +
        (step(0.41, angle) - step(0.48, angle)) +
        
        (step(0.52, angle) - step(0.59, angle)) +
        (step(0.6, angle) - step(0.66, angle)) +
        (step(0.83, angle) - step(0.89, angle)) +
        (step(0.9, angle) - step(0.98, angle))
    );
    
    float timeFactor = 3.14 * 0.2 * cos(TIME * 0.5);
    st = getRotation(st, vec2(center), timeFactor);
    float dial1 = getDottedCircle(st, vec2(center), radius + 0.04, lineThickness + 0.01, sm);
    
    float dial2 = getDottedCircle(st, vec2(center), radius + -0.04, lineThickness + 0.01, sm);
    dial2 += getDottedCircle(st, vec2(center), radius + -0.02, lineThickness + 0.001, sm);
    st = getRotation(st, vec2(center), -timeFactor);
    
    
    dial1 *= (step(0.662, angle) - step(0.84, angle));
    dial2 *= (step(0.682, angle) - step(0.82, angle));
    
    
    float sideLine = getSideLine(st, -0.4, -0.116, 0.002);
    st = getScaling(st, vec2(0.0), -1.0, 1.0);
    sideLine += getSideLine(st, -0.4, -0.116, 0.002);
    st = getScaling(st, vec2(0.0), -1.0, 1.0);
    
    st = getRotation(st, vec2(center), 3.14 * 0.1 * sin(TIME));
    
    float innerDial = getInnetDial(st, center, radius);
    st = getScaling(st, vec2(0.0), -1.0, 1.0);
    innerDial += getInnetDial(st, center, radius);
    st = getScaling(st, vec2(0.0), -1.0, 1.0);
    
    
    st = getRotation(st, vec2(center), 3.14 / 4.);
    float box = getBox(st, -0.068, -0.057, 0.004, 0.115);
    box += getBox(st, 0.066, -0.057, 0.004, 0.115);
    box += getBox(st, -0.057, 0.070, 0.115, 0.004);
    box += getBox(st, -0.057, -0.070, 0.115, 0.004);
    box -= getBox(st, -0.036, -0.036, 0.072, 0.072);
    
    box += getBox(st, -0.05, -0.05, 0.006, 0.006);
    box += getBox(st, 0.048, -0.05, 0.006, 0.006);
    box += getBox(st, 0.048, 0.046, 0.006, 0.006);
    box += getBox(st, -0.05, 0.046, 0.006, 0.006);
    
    float innerBox = getBox(st, -0.04, -0.04, 0.08, 0.08);
    innerBox -= getBox(st, -0.036, -0.036, 0.072, 0.072);
    innerBox += getBox(st, -0.07, -0.07, 0.006, 0.006);
    innerBox += getBox(st, 0.066, -0.07, 0.006, 0.006);
    innerBox += getBox(st, 0.066, 0.066, 0.006, 0.006);
    innerBox += getBox(st, -0.07, 0.066, 0.006, 0.006);
    st = getRotation(st, vec2(center), -3.14 / 4.);
    
    st = getRotation(st, vec2(center), -3.14 * 0.1 * sin(TIME));
    
    float sideMarks = step(18., mod(floor((st.y + 0.1 * sin(TIME)) / 0.002), 20.0));
    sideMarks *= (
        (step(-0.44, st.x) - step(-0.415, st.x)) +
        (step(0.415, st.x) - step(0.44, st.x))
    );
    sideMarks *= (step(-0.12, st.y) - step(0.12, st.y));
    
    float sideMarksBox = getBox(st, -0.45, -0.015, 0.04, 0.03);
    sideMarksBox -= getBox(st, -0.448, -0.013, 0.036, 0.026);
    st = getScaling(st, vec2(0.0), -1.0, 1.0);
    sideMarksBox += getBox(st, -0.45, -0.015, 0.04, 0.03);
    sideMarksBox -= getBox(st, -0.448, -0.013, 0.036, 0.026);
    st = getScaling(st, vec2(0.0), -1.0, 1.0);
    
    sideMarksBox += getBox(st, -0.0025, 0.33, 0.005, 0.005);
    sideMarksBox += getBox(st, -0.0025, 0.25, 0.005, 0.005);
    
    box *= (0.2 + 0.8 * pow(abs(sin(TIME * 4.)), 2.));

    color += vec3(1.000,0.345,0.287) * circle1;
    color += vec3(0.39,0.61,0.65) * dottedCircle;
    color += vec3(0.39,0.61,0.65) * dial1;
    color += vec3(0.39,0.61,0.65) * dial2;
    color += vec3(0.39,0.61,0.65) * innerDial;
    color += vec3(0.39,0.61,0.65) * sideLine;
    color += vec3(0.39,0.61,0.65) * sideMarks;
    color += vec3(0.39,0.61,0.65) * sideMarksBox;
    color += vec3(0.995,0.425,0.003) * box;
    color += vec3(0.96, 0.98, 0.8) * innerBox;
    
    return vec4(color,1.0);
}

//--------------------------------------------------sand

vec2 hash( vec2 p )
{
	p = vec2( dot(p,vec2(127.1,311.7)),
			  dot(p,vec2(269.5,183.3)) );

	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( hash( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
                     dot( hash( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( hash( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
                     dot( hash( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

float terrainH( in vec2 p)
{

    //small
	float valS = noise(p * 0.5) + 0.5;//0~1
    valS = 1.0 - abs(valS - 0.5) * 2.0;
    valS = pow(valS,2.0);

    //middle
    float valM = noise(p * 0.26) + 0.5;//0~1
    valM = 1.0 - abs(valM - 0.5) * 2.0;
    valM = pow(valM,2.0);
    
    //big
    float valB = smoothstep(0.0,1.0,noise(p * 0.2) + 0.5);//0~1

    float val = valS * 0.01 + valM * 0.19 + valB * 0.8;

    return val * 1.3 - 0.3;
}

float softShadow(in vec3 ro, in vec3 rd )
{
    // real shadows	
    float res = 1.0;
    float t = 0.001;
	for( int i=0; i<40; i++ )
	{
	    vec3  p = ro + t*rd;
        float h = p.y - terrainH( p.xz );
		res = min( res, 16.0*h/t );
		t += h;
		if( res<0.01 ||p.y>(200.0) ) break;
	}
	return clamp( res, 0.0, 1.0 );
}


float interesct( in vec3 ro, in vec3 rd, in float tmin, in float tmax )
{
    float t = tmin;
	for( int i=0; i<128; i++ )
	{
        vec3 pos = ro + t*rd;
		float h = pos.y - terrainH( pos.xz );
		if( h<(0.002*t) || t>tmax ) break;
		t += 0.5*h;
	}
	return t;
}


vec3 calcNormal( in vec3 pos, float t )
{
    vec2  eps = vec2( 0.002*t, 0.0 );
    return normalize( vec3( terrainH(pos.xz-eps.xy) - terrainH(pos.xz+eps.xy),
                            2.0*eps.x,
                            terrainH(pos.xz-eps.yx) - terrainH(pos.xz+eps.yx) ) );
}

vec3 render( in vec3 ro, in vec3 rd )
{   
    vec3 lightDir = normalize( vec3(-0.8,0.3,-0.3) );
    vec3 lightColor = vec3(1.0);
    vec3 sandColor = vec3(0.9,0.70,0.4);
    vec3 ambientColor = vec3(0.5);

    float tmin = 1.0;
    float tmax = 30.0;
    float t = interesct(ro,rd,tmin,tmax);

    vec3 col;
    if(t>tmax){
        vec3 sky0 = vec3(0.8,0.7,0.5) * 1.2;
        vec3 sky1 = vec3(0.4,0.6,0.8) * 1.2;
        col = mix(sky0,sky1,pow(max(rd.y + 0.15,0.0),0.5));
        col += vec3(pow(max(dot(rd,lightDir),0.0),50.0));
    }
    else{
        vec3 pos = ro + t*rd;
        
        float shadow = softShadow(pos + lightDir *0.01,lightDir);
        
        vec3 normal = calcNormal( pos, t );
        normal = normalize(normal + vec3(sin(pos.x * 100.0 + sin(pos.z * 31.0) + sin(pos.y) * 200.0) * 0.02,0,0));
        vec3 viewDir = -rd;

        float lambertian = max(dot(lightDir,normal), 0.0);

        float shininess =  20.0;
        vec3 halfDir = normalize(lightDir + viewDir);
        float specAngle = max(dot(halfDir, normal), 0.0);
        float specular1 = pow(specAngle, shininess);
        float specular2 = pow(specAngle, shininess / 2.0) * noise(pos.xz * 10000.0) * 1.0f;// * pow(texture(iChannel0,pos.xz * 10.0).x,3.0);

        vec3 diff = sandColor * lambertian * lightColor;
        vec3 spec = (specular1 *0.3 + specular2 * 0.2) * lightColor;
        vec3 ambient = ambientColor * sandColor;
        col = shadow * (diff + spec) + ambient;

    }
    return col;
}

vec4 sand_fragment(vec2 SPS, vec2 UVp) {//SPS SCREEN_PIXEL_SIZE,  FC FRAGCOORD

    float time = TIME * 0.5;

    float yaw;
    float pitch;
    
    if(iMouse.x == 0.0 && iMouse.y == 0.0){
    	yaw = time;
    	pitch = 1.2;        
    }
    else{
        yaw = iMouse.x * 0.05;
    	pitch = clamp(iMouse.y  * 2.0 /(1.0/SPS).y,-PI * 0.5,PI * 0.5);
    }
	
	vec2 uv = UVp;
	uv.y=0.5-uv.y;
	uv.x=0.5-uv.x;
	
	vec2 p0 = uv;
    
    vec3 ro = 1.1*vec3(2.5*sin(0.25*yaw),2.5 * cos(pitch),2.5*cos(0.25*yaw));
    vec3 ww = normalize(vec3(0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p0.x*uu + p0.y*vv + 2.5*ww );

    vec3 col = render( vec3(time,1.8,0.0), rd );
    
    return vec4(col,1);
}


void fragment() {
	vec4 s = sand_fragment(SCREEN_PIXEL_SIZE,UV);
	vec4 h = HUD_fragment(SCREEN_PIXEL_SIZE,UV,COLOR);
	
    // Output to screen
    COLOR = s+h; //Note simple color summarising. //texture(iChannel0, uvA) + texture(iChannel1, uvB);
	//in case of more presize color controlling if statement needed.
}
