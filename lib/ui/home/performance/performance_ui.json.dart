final performanceUIConfJsonData = [
  {
    "key": "r_ssdo",
    "name": "屏幕光线后处理",
    "info": "调整光线后处理等级",
    "type": "int",
    "max": 2,
    "min": 0,
    "value": 1,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "r_AntialiasingMode",
    "name": "抗锯齿",
    "info": "0 关闭，1 SMAA，2 时间过滤+SMAA，3 时间滤波和投影矩阵抖动的 SMAA",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_gameeffects",
    "name": "特效等级",
    "info": "游戏特效等级",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_texture",
    "name": "纹理等级",
    "info": "模型纹理细节",
    "type": "int",
    "max": 3,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_volumetriceffects",
    "name": "体积效果",
    "info": "体积云、体积光照等",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_water",
    "name": "水体效果",
    "info": "各种水的等级",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_objectdetail",
    "name": "对象细节",
    "info": "模型对象细节，影响LOD等..",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_particles",
    "name": "粒子细节",
    "info": "",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_physics",
    "name": "物理细节",
    "info": "物理效果范围",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_shading",
    "name": "着色器细节",
    "info": "着色器相关",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_shadows",
    "name": "阴影细节",
    "info": "阴影效果",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "sys_spec_postprocessing",
    "name": "后处理细节",
    "info": "后处理着色器，动态模糊效果 等",
    "type": "int",
    "max": 4,
    "min": 1,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_Renderer",
    "name": "渲染器质量",
    "info": "cryengine 渲染器质量",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderDecal",
    "name": "贴花质量",
    "info": "（LOGO、标志等）",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderPostProcess",
    "name": "着色器质量",
    "info": "",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 3,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderFX",
    "name": "FX 质量",
    "info": "",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderGeneral",
    "name": "常规质量",
    "info": "整体模型质量",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderGlass",
    "name": "玻璃质量",
    "info": "窗、镜子等",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderHDR",
    "name": "HDR质量",
    "info": "HDR色差，亮度层级 处理 等",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderParticle",
    "name": "粒子质量",
    "info": "粒子效果质量",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderTerrain",
    "name": "地面质量",
    "info": "",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderShadow",
    "name": "阴影质量",
    "info": "",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "q_ShaderSky",
    "name": "天空质量",
    "info": "",
    "type": "int",
    "max": 3,
    "min": 0,
    "value": 2,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "e_ParticlesObjectCollisions",
    "name": "粒子碰撞",
    "info": "1 仅静态粒子 2 包括动态粒子",
    "type": "int",
    "max": 2,
    "min": 1,
    "value": 1,
    "group": "图形（修改后建议清理着色器）"
  },
  {
    "key": "r_displayinfo",
    "name": "屏幕信息（展示帧率）",
    "info": "在屏幕右上角展示帧率，服务器信息等",
    "type": "int",
    "max": 4,
    "min": 0,
    "value": 1,
    "group": "设置"
  },
  {
    "key": "sys_maxFps",
    "name": "最大帧率",
    "info": "调整游戏最高帧率，0为不限制",
    "type": "int",
    "max": 300,
    "min": 0,
    "value": 0,
    "group": "设置"
  },
  {
    "key": "r_DisplaySessionInfo",
    "name": "显示会话信息",
    "info": "开启后在屏幕上显示一个二维码，用于反馈时让 CIG 快速定位相关信息",
    "type": "bool",
    "max": 1,
    "min": 0,
    "value": 0,
    "group": "设置"
  },
  {
    "key": "r_VSync",
    "name": "垂直同步",
    "info": "开启以防止撕裂，关闭以提高帧率",
    "type": "bool",
    "max": 1,
    "min": 0,
    "value": 0,
    "group": "设置"
  },
  {
    "key": "r_MotionBlur",
    "name": "动态模糊",
    "info": "开启以提高运动感，关闭提升观感",
    "type": "bool",
    "max": 1,
    "min": 0,
    "value": 0,
    "group": "设置"
  },
  {
    "key": "cl_fov",
    "name": "FOV",
    "info": "设置视角FOV",
    "type": "int",
    "max": 160,
    "min": 25,
    "value": 90,
    "group": "设置"
  },
  {
    "key": "ui_disableScreenFade",
    "name": "UI 淡入淡出动画",
    "info": "",
    "type": "bool",
    "max": 1,
    "min": 0,
    "value": 1,
    "group": "设置"
  },
  {
    "key": "customize",
    "name": "自定义参数",
    "info": "",
    "type": "customize",
    "max": 1,
    "min": 0,
    "value": 1,
    "group": "自定义"
  }
];
