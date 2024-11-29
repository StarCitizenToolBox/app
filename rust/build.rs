use rust2go::RegenArgs;

fn main() {
    rust2go::Builder::new()
        .with_go_src("./go")
        .with_regen_arg(RegenArgs {
            src: "./src/go/go_api.rs".into(),
            dst: "./go/rs_gen.go".into(),
            ..Default::default()
        })
        .build();
}