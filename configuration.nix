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

  # Fixa o caminho do nixpkgs para evitar erros de canal sumido
    nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

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
  services.displayManager.autoLogin.user = "daniel";

  # --- CONFIGURAÇÃO DO SHELL ---
  programs.zsh.enable = true; # Habilita o ZSH no sistema
  
  # Define o ZSH como shell padrão para o seu usuário
  users.users.daniel.shell = pkgs.zsh;


  # --- PACOTES DO SISTEMA ---
  environment.systemPackages = with pkgs; [
    # Essenciais para o sistema não "sumir" com nada
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.systemsettings
    kdePackages.ark        # Para descompactar arquivos
    kdePackages.kate       # Editor de texto gráfico melhor que nano
    kdePackages.plasma-workspace-wallpapers
    kdePackages.partitionmanager
    kdePackages.isoimagewriter
    kdePackages.kdeconnect-kde
    kdePackages.elisa
    kdePackages.ktorrent
    kdePackages.kweather

    # Seus Apps
    google-chrome
    vscode
    git
    fastfetch
    pciutils               # Útil para ver hardware na VM
    thermald
    android-tools
    wget
    nodejs_25
    zsh
    oh-my-zsh
    papirus-icon-theme
    catppuccin-papirus-folders
    reversal-icon-theme
    flatpak
  ];

  fonts.packages = with pkgs; [
    fira
    fira-code
    google-fonts
    nerd-fonts.jetbrains-mono
  ];

 # --- HARDWARE E PERFORMANCE ---
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  zramSwap.enable = true;
  
  nix.settings = {
    max-jobs = "auto";
    cores = 0;
    experimental-features = [ "nix-command" "flakes" ];
  };

 # --- GRÁFICOS AMD (RX 6600) ---  # Só descomentar se usar no Xeon
 # hardware.graphics = {
 #   enable = true;
 #   enable32Bit = true; # Essencial para Steam / Jogos antigos
 # };
 # services.xserver.videoDrivers = [ "amdgpu" ];

  # --- CONFIGURAÇÃO DE USUÁRIO ---
  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel";
    extraGroups = [ "networkmanager" "wheel" ];
    # Opcional: define a senha inicial como "nixos" para não travar no primeiro login
    initialPassword = "nixos"; 
  };

  # --- HABILITAR FLATPAK
  services.flatpak.enable = true;


  # --- CONFIGURAÇÕES EXTRAS ---
  nixpkgs.config.allowUnfree = true; # Para Chrome e Steam funcionarem

 # Habilitar Steam e suporte a jogos
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Abre portas para o Steam Remote Play
    dedicatedServer.openFirewall = true; # Abre portas para servidores dedicados
  };


  # --- ATUALIZAR BRANCH KDE PARA UNSTABLE ---
  # sudo nix-channel --update && sudo nixos-rebuild switch --upgrade --fallback

  # Limpar lixo e snapshots antigas do sistema
  # Só usar depois de reiniciar na mais atual
  # sudo nix-collect-garbage -d



  # NUNCA ALTERAR A LINHA ABAIXO, ELA É IMPORTANTE PARA INFORMAR PRO SISTEMA, QUAL FOI A VERSÃO ORIGINAL QUE FOI INSTALADA
  system.stateVersion = "24.11"; 
}
