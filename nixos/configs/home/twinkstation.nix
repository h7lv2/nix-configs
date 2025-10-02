{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];
}
{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    xivlauncher
    protonup-qt
  ];

  # systemd.user.enable = true;
  # systemd.user = {
  #   services.sunshine = {
  #     enable = true;
      
  #     Description = "Sunshine streaming service";
  #     After = [ "graphical.target "];
  #     Script = "${config.security.wrapperDir}/sunshine";
  #     Restart = "on-failure";
  #     RestartSec = "5s";
  #   };
  # };
}
