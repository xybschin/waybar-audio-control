use serde::Deserialize;
use std::fs;

#[derive(Deserialize)]
pub struct Config {
    #[serde(default)]
    pub colors: Colors,
    #[serde(default)]
    pub position: Position,
}

#[derive(Deserialize)]
pub struct Colors {
    #[serde(default = "default_fg")]
    pub foreground: String,
    #[serde(default = "default_bg")]
    pub background: String,
    #[serde(default = "default_accent")]
    pub accent: String,
}

#[derive(Deserialize)]
pub struct Position {
    #[serde(default = "default_anchor")]
    pub anchor: String,   // "top-right" | "top-left" | "bottom-right" | "bottom-left"
    #[serde(default = "default_margin")]
    pub margin_top: i32,
    #[serde(default = "default_margin")]
    pub margin_right: i32,
    #[serde(default = "default_margin")]
    pub margin_bottom: i32,
    #[serde(default = "default_margin")]
    pub margin_left: i32,
}

impl Default for Config {
    fn default() -> Self {
        toml::from_str("").unwrap()
    }
}

impl Default for Colors {
    fn default() -> Self {
        toml::from_str("").unwrap()
    }
}

impl Default for Position {
    fn default() -> Self {
        toml::from_str("").unwrap()
    }
}

fn default_fg()     -> String { "#cdd6f4".to_string() }
fn default_bg()     -> String { "#1e1e2e".to_string() }
fn default_accent() -> String { "#f5c2e7".to_string() }
fn default_anchor() -> String { "top-right".to_string() }
fn default_margin() -> i32    { 10 }

pub fn load() -> Config {
    let path = dirs_path();
    match fs::read_to_string(&path) {
        Ok(content) => toml::from_str(&content).unwrap_or_else(|e| {
            eprintln!("Failed to parse config at {}: {e}", path.display());
            Config::default()
        }),
        Err(_) => Config::default(),
    }
}

fn dirs_path() -> std::path::PathBuf {
    let home = std::env::var("HOME").unwrap_or_default();
    std::path::PathBuf::from(home)
        .join(".config")
        .join("waybar-audio-control")
        .join("config.toml")
}
