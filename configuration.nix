# Daniel's config NixOS

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- BOOT E KERNEL ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest; # Kernel mais atual para performance

  # --- REDE ---
  networking.hostName = "nixos-dani";
  networking.networkmanager.enable = true;

  # --- LOCALIZAÇÃO E IDIOMA ---
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  
  # Garante que as mensagens de erro de Locale sumam de vez
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configuração de Teclado (Padrão Brasileiro ABNT2)
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  # --- INTERFACE GRÁFICA (KDE PLASMA 6) ---
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # --- AUTOLOGIN ---
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dani";

  # --- PACOTES DO SISTEMA ---
  environment.systemPackages = with pkgs; [
    # Essenciais para o sistema não "sumir" com nada
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.systemsettings
    kdePackages.ark        # Para descompactar arquivos
    kdePackages.kate       # Editor de texto gráfico melhor que nano
    
    # Seus Apps
    google-chrome
    vscode
    steam
    git
    fastfetch
    pciutils               # Útil para ver hardware na VM
  ];

  # --- CONFIGURAÇÃO DE USUÁRIO ---
  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel";
    extraGroups = [ "networkmanager" "wheel" ];
    # Opcional: define a senha inicial como "nixos" para não travar no primeiro login
    initialPassword = "nixos"; 
  };

  # --- CONFIGURAÇÕES EXTRAS ---
  nixpkgs.config.allowUnfree = true; # Para Chrome e Steam funcionarem

 # Habilitar Steam e suporte a jogos
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Abre portas para o Steam Remote Play
    dedicatedServer.openFirewall = true; # Abre portas para servidores dedicados
  };


  # Garante que o comando "nix-command" e "flakes" funcionem se você quiser testar depois
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11"; 
}
