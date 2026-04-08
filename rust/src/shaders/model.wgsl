struct Uniforms {
    mvp: mat4x4<f32>,
    light_dir: vec4<f32>,
}

@group(0) @binding(0) var<uniform> uniforms: Uniforms;

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) normal: vec3<f32>,
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) normal: vec3<f32>,
    @location(1) world_pos: vec3<f32>,
}

@vertex
fn vs_main(input: VertexInput) -> VertexOutput {
    var output: VertexOutput;
    output.clip_position = uniforms.mvp * vec4<f32>(input.position, 1.0);
    output.normal = input.normal;
    output.world_pos = input.position;
    return output;
}

@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
    let normal = normalize(input.normal);
    let light_dir = normalize(uniforms.light_dir.xyz);
    
    let ambient = 0.2;
    let diffuse = max(dot(normal, light_dir), 0.0) * 0.7;
    
    let base_color = vec3<f32>(0.6, 0.65, 0.7);
    let color = base_color * (ambient + diffuse);
    
    return vec4<f32>(color, 1.0);
}
