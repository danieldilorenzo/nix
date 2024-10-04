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
