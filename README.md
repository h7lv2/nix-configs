idk why you'd want to copy my configs but here you are 

`nixos/` contains the actual configs, the root of the project is only used for documentation and stuff like gitignores 
flakes are defined as such:
 - `hermes` is a flake defined around my laptop. doesnt include nvidia drivers as im tired of constant [prime](https://wiki.archlinux.org/title/PRIME) issues
 - (currently undefined) `zeus` flake defined around my desktop
 - a `home-manager` config, currently mostly unpopulated

the repo also includes a few `botches` to fix some stupid nixos problems, they may or may not work. use at your own peril lmao 
