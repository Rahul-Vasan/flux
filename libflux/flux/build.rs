extern crate fluxcore;

use std::{env, fs, io, io::Write, path};

use deflate::deflate_bytes;
use fluxcore::semantic::bootstrap;
use fluxcore::semantic::bootstrap::stdlib_docs;
use fluxcore::semantic::env::Environment;
use fluxcore::semantic::flatbuffers::types as fb;
use fluxcore::semantic::sub::Substitutable;

#[derive(Debug)]
struct Error {
    msg: String,
}

impl From<env::VarError> for Error {
    fn from(err: env::VarError) -> Error {
        Error {
            msg: err.to_string(),
        }
    }
}

impl From<io::Error> for Error {
    fn from(err: io::Error) -> Error {
        Error {
            msg: format!("{:?}", err),
        }
    }
}

impl From<bootstrap::Error> for Error {
    fn from(err: bootstrap::Error) -> Error {
        Error { msg: err.msg }
    }
}

fn serialize<'a, T, S, F>(ty: T, f: F, path: &path::Path) -> Result<(), Error>
where
    F: Fn(&mut flatbuffers::FlatBufferBuilder<'a>, T) -> flatbuffers::WIPOffset<S>,
{
    let mut builder = flatbuffers::FlatBufferBuilder::new();
    let buf = fb::serialize(&mut builder, ty, f);
    let mut file = fs::File::create(path)?;
    file.write_all(buf)?;
    Ok(())
}

fn main() -> Result<(), Error> {
    let dir = path::PathBuf::from(env::var("OUT_DIR")?);

    let stdlib_enabled = env::var_os("CARGO_FEATURE_STDLIB").is_some();
    if stdlib_enabled {
        let std_lib_values = bootstrap::infer_stdlib()?;
        let (pre, lib, libmap, files, file_map) = (
            std_lib_values.prelude,
            std_lib_values.importer,
            std_lib_values.importermap,
            std_lib_values.rerun_if_changed,
            std_lib_values.files,
        );
        for f in files.iter() {
            println!("cargo:rerun-if-changed={}", f);
        }

        // Validate there aren't any free type variables in the environment
        for (name, ty) in &pre {
            if !ty.free_vars().is_empty() {
                return Err(Error {
                    msg: format!("found free variables in type of {}: {}", name, ty),
                });
            }
        }
        for (name, ty) in &lib {
            if !ty.free_vars().is_empty() {
                return Err(Error {
                    msg: format!("found free variables in type of package {}: {}", name, ty),
                });
            }
        }

        let path = dir.join("prelude.data");
        serialize(Environment::from(pre), fb::build_env, &path)?;

        let path = dir.join("stdlib.data");
        serialize(Environment::from(lib), fb::build_env, &path)?;

        let docs_enabled = env::var_os("CARGO_FEATURE_STDLIB").is_some();
        if docs_enabled {
            let new_docs = stdlib_docs(&libmap, &file_map).unwrap();
            let json_docs = serde_json::to_vec(&new_docs).unwrap();
            let comp_docs = deflate_bytes(&json_docs);
            let path = dir.join("docs.json");
            let mut file = fs::File::create(path)?;
            file.write_all(&comp_docs)?;
        }
    }

    Ok(())
}
