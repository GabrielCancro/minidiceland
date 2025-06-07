shader_type canvas_item;

// Texturas para cada cara
uniform sampler2D texture_pos_x;
uniform sampler2D texture_neg_x;
uniform sampler2D texture_pos_y;
uniform sampler2D texture_neg_y;
uniform sampler2D texture_pos_z;
uniform sampler2D texture_neg_z;

uniform float rotation_speed = 1.0;
uniform float cube_size = 1.0;
uniform float zoom = 1.0;
uniform int initial_face = 0; // 0=+X, 1=−X, 2=+Y, 3=−Y, 4=+Z, 5=−Z

uniform float border_thickness = 0.05; // tamaño del borde
uniform float border_strength = 0.4;   // qué tan oscuro es el borde

const float EPSILON = 0.0001;
uniform float time = 1.0;
uniform float opacity = 1.0;

vec3 rotate_y(vec3 p, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z);
}

vec3 rotate_x(vec3 p, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
}

vec2 get_initial_angles(int face_index) {
    if (face_index == 0) return vec2(-1.5708, 0.0); // +X
    if (face_index == 1) return vec2(1.5708, 0.0);  // -X
    if (face_index == 2) return vec2(0.0, -1.5708); // +Y
    if (face_index == 3) return vec2(0.0, 1.5708);  // -Y
    if (face_index == 4) return vec2(0.0, 0.0);     // +Z
    if (face_index == 5) return vec2(3.1416, 0.0);  // -Z
    return vec2(0.0);
}

bool intersect_cube(vec3 ro, vec3 rd, out vec3 hit_normal, out vec2 uv, out int face_index) {
    vec3 min_b = vec3(-cube_size);
    vec3 max_b = vec3(cube_size);

    vec3 inv_rd = 1.0 / (rd + EPSILON);
    vec3 t0s = (min_b - ro) * inv_rd;
    vec3 t1s = (max_b - ro) * inv_rd;

    vec3 tsmaller = min(t0s, t1s);
    vec3 tbigger = max(t0s, t1s);

    float tmin = max(max(tsmaller.x, tsmaller.y), tsmaller.z);
    float tmax = min(min(tbigger.x, tbigger.y), tbigger.z);

    if (tmin > tmax || tmax < 0.0) return false;

    float t = tmin > 0.0 ? tmin : tmax;
    vec3 pos = ro + rd * t;

    vec3 abs_pos = abs(pos);
    if (abs_pos.x > abs_pos.y && abs_pos.x > abs_pos.z) {
        hit_normal = vec3(sign(pos.x), 0.0, 0.0);
        uv = pos.yz;
        face_index = pos.x > 0.0 ? 0 : 1;
    } else if (abs_pos.y > abs_pos.x && abs_pos.y > abs_pos.z) {
        hit_normal = vec3(0.0, sign(pos.y), 0.0);
        uv = pos.xz;
        face_index = pos.y > 0.0 ? 2 : 3;
    } else {
        hit_normal = vec3(0.0, 0.0, sign(pos.z));
        uv = pos.xy;
        face_index = pos.z > 0.0 ? 4 : 5;
    }

    uv = uv * 0.5 / cube_size + 0.5;
    return true;
}

vec4 get_face_color(int face_index, vec2 uv) {
    if (face_index == 0) return texture(texture_pos_x, uv);
    if (face_index == 1) return texture(texture_neg_x, uv);
    if (face_index == 2) return texture(texture_pos_y, uv);
    if (face_index == 3) return texture(texture_neg_y, uv);
    if (face_index == 4) return texture(texture_pos_z, uv);
    if (face_index == 5) return texture(texture_neg_z, uv);
    return vec4(1.0, 0.0, 1.0, 1.0); // fallback: rosa
}

float get_border_mask(vec2 uv) {
    float d = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));
    return smoothstep(border_thickness, 0.0, d);
}

void fragment() {
    vec2 uv = (UV - 0.5) * zoom;

    vec3 ro = vec3(0.0, 0.0, -3.0);
    vec3 rd = normalize(vec3(uv.x, uv.y, 1.0));

    float t = time * rotation_speed;
    vec2 angles = get_initial_angles(initial_face);

    ro = rotate_y(ro, t + angles.x);
    rd = rotate_y(rd, t + angles.x);
    ro = rotate_x(ro, t * 0.5 + angles.y);
    rd = rotate_x(rd, t * 0.5 + angles.y);

    vec3 normal;
    vec2 local_uv;
    int face_index;

    if (intersect_cube(ro, rd, normal, local_uv, face_index)) {
        vec4 color = get_face_color(face_index, local_uv);
        float border = get_border_mask(local_uv);
        color.rgb *= mix(1.0, border_strength, border); // Aplica sombra en los bordes
        COLOR = color*opacity;
    } else {
        COLOR = vec4(0.0);
    }
}
