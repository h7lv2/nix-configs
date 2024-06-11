idk why you'd want to copy my configs but here you are 

`nixos/` contains the actual configs, the root of the project is only used for documentation and stuff like gitignores 

flakes are defined as such:
 - `hermes` is a flake defined around my laptop. doesnt include nvidia drivers as im tired of constant [prime](https://wiki.archlinux.org/title/PRIME) issues
 - `zeus` flake defined around my desktop
 - a `home-manager` config, which i mostly use for user-level package management and occasionally as a config tool if it's sane enough 

technically speaking the configs are not fully reproducible because `nixos/configs/hardware/secrets.nix` is intentionally missing and one would need to copy it from an already functional machine
