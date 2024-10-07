## Tutorial NixOS

## Instalar pacotes

Procurar pacotes no

 https://search.nixos.org/packages

 Colocar dentro de

  > environment.systemPackages = [
  >
  >  ] 


Após isso, fazer uma nova snapshot com

 `sudo nixos-rebuild switch`


## Atualizar

`nixos-rebuild switch --upgrade` 

[Ativar upgrade automático](https://nlewo.github.io/nixos-manual-sphinx/installation/upgrading.xml.html#automatic-upgrades) (não recomendado para branch instável

## Remover Snapshots antigas

> sudo nix-collect-garbage -d
> 
> sudo nixos-rebuild switch
