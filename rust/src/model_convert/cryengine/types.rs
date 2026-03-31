#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FileSignature {
    CrCh,
    Ivo,
    CryTek,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ChunkType {
    Unknown(u32),
    // CryEngine/CGF
    MtlName,
    Node,
    Mesh,
    MeshSubsets,
    DataStream,
    CompiledMorphTargets,
    CompiledMorphTargetsSc,
    Timing,
    // Star Citizen IVO
    IvoSkin,
    IvoSkin2,
    NodeMeshCombo,
}

impl ChunkType {
    pub fn from_raw(raw: u32) -> Self {
        match raw {
            0xCCCC_000C => Self::MtlName,
            0xCCCC_000B => Self::Node,
            0xCCCC_0000 => Self::Mesh,
            0xCCCC_0017 => Self::MeshSubsets,
            0xCCCC_0001 => Self::DataStream,
            0xACDC_0002 => Self::CompiledMorphTargets,
            0xCCCC_1002 => Self::CompiledMorphTargetsSc,
            0xCCCC_000E => Self::Timing,
            0xB875_B2D9 => Self::IvoSkin,
            0xB875_7777 => Self::IvoSkin2,
            0x7069_7FDA => Self::NodeMeshCombo,
            other => Self::Unknown(other),
        }
    }

    pub fn raw(self) -> u32 {
        match self {
            Self::MtlName => 0xCCCC_000C,
            Self::Node => 0xCCCC_000B,
            Self::Mesh => 0xCCCC_0000,
            Self::MeshSubsets => 0xCCCC_0017,
            Self::DataStream => 0xCCCC_0001,
            Self::CompiledMorphTargets => 0xACDC_0002,
            Self::CompiledMorphTargetsSc => 0xCCCC_1002,
            Self::Timing => 0xCCCC_000E,
            Self::IvoSkin => 0xB875_B2D9,
            Self::IvoSkin2 => 0xB875_7777,
            Self::NodeMeshCombo => 0x7069_7FDA,
            Self::Unknown(raw) => raw,
        }
    }
}
