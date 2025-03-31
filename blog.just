shebang := if os() == 'windows' {
  'pwsh.exe'
} else {
  '/usr/bin/env pwsh'
}
set shell := ["pwsh", "-c"]
set windows-shell := ["pwsh.exe", "-NoProfile", "-Command"]

environment := env("DEPLOYMENT_ENVIRONMENT", "dev")

# Lists all available recipies
help:
  @just --list

_hello name="world":
  @echo "Hello, {{name}}"

# Deploys infrastructure to defined environment
deploy: _hello
  @echo "Deploying to {{environment}}"

# Initializes the configuration toml
init:
  #!{{shebang}}
  $toml = @"
[package]
name = "my-project"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
toml = "0.7"
"@

  $toml | Out-File -FilePath "Cargo.toml"
  Write-Host "Created Cargo.toml"


# Test without
without:
  Write-Host "Without"
  $some_var = "Without"
  Write-Host $some_var

# Test with
with:
  #!{{shebang}}
  Set-PSDebug -Trace 1
  Write-Host "With"
  $some_var = "With"
  Write-Host $some_var
  Set-PSDebug -Off
