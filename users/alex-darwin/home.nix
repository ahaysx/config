{ config, lib, ... }: {
  # Import the common configuration
  imports = [ ../common-home.nix ];
  
  home.username = "alex";
  home.homeDirectory = "/Users/alex";
}

