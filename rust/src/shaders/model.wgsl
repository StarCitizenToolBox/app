struct Uniforms {
    mvp: mat4x4<f32>,
    light_dir: vec4<f32>,
    camera_pos: vec4<f32>,
}

@group(0) @binding(0) var<uniform> uniforms: Uniforms;

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) normal: vec3<f32>,
    @location(2) color: vec3<f32>,
    @location(3) uv: vec2<f32>,
    @location(4) alpha: f32,
    @location(5) alpha_cutoff: f32,
    @location(6) texture_strength: f32,
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) normal: vec3<f32>,
    @location(1) world_pos: vec3<f32>,
    @location(2) color: vec3<f32>,
    @location(3) uv: vec2<f32>,
    @location(4) alpha: f32,
    @location(5) alpha_cutoff: f32,
    @location(6) texture_strength: f32,
}

@vertex
fn vs_main(input: VertexInput) -> VertexOutput {
    var output: VertexOutput;
    output.clip_position = uniforms.mvp * vec4<f32>(input.position, 1.0);
    output.normal = input.normal;
    output.world_pos = input.position;
    output.color = input.color;
    output.uv = input.uv;
    output.alpha = input.alpha;
    output.alpha_cutoff = input.alpha_cutoff;
    output.texture_strength = input.texture_strength;
    return output;
}

@group(0) @binding(1) var base_texture: texture_2d<f32>;
@group(0) @binding(2) var base_sampler: sampler;

@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
    if (input.texture_strength < 0.0) {
        return vec4<f32>(0.055, 0.065, 0.070, 0.30);
    }

    let raw_normal = normalize(input.normal);
    let view_dir = normalize(uniforms.camera_pos.xyz - input.world_pos);
    let normal = select(-raw_normal, raw_normal, dot(raw_normal, view_dir) >= 0.0);
    let key_dir = normalize(uniforms.light_dir.xyz);
    let fill_dir = normalize(vec3<f32>(0.62, -0.18, 0.76));
    let top_dir = normalize(vec3<f32>(-0.25, 0.92, 0.20));

    let key = max(dot(normal, key_dir), 0.0) * 0.42;
    let fill = max(dot(normal, fill_dir), 0.0) * 0.18;
    let top = max(dot(normal, top_dir), 0.0) * 0.16;
    let hemi = (normal.y * 0.5 + 0.5) * 0.10;
    let rim = pow(1.0 - clamp(dot(normal, view_dir), 0.0, 1.0), 2.0) * 0.20;

    let texel = textureSample(base_texture, base_sampler, input.uv);
    if ((texel.a * input.alpha) <= input.alpha_cutoff) {
        discard;
    }
    let tex_luma = dot(texel.rgb, vec3<f32>(0.2126, 0.7152, 0.0722));
    let detail = mix(1.0, tex_luma, input.texture_strength);
    let material_color = input.color * detail;
    let base_color = mix(vec3<f32>(0.42, 0.46, 0.48), material_color, 0.62);
    let shade = 0.42 + key + fill + top + hemi;
    let color = base_color * shade + vec3<f32>(0.16, 0.18, 0.19) * rim;
    
    return vec4<f32>(color, 1.0);
}
