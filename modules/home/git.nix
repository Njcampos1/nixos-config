{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "njcampos1";
        email = "njcampos1@uc.cl";
      };

      safe = {
        directory = "/etc/nixos";
      };
      
      core = {
        sshCommand = "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes";
      };

      init = {
        defaultBranch = "main";
      };

      pull = {
        rebase = true;
      };
    };

    includes = [
      {
        condition = "gitdir:~/dev/azure-projects/";
        contents = {
          user = {
            email = "njcampos1@uc.cl";
            name = "Nestor Campos (Azure)"; 
          };
          core = {
            sshCommand = "ssh -i ~/.ssh/keys/upper-key.pem -o IdentitiesOnly=yes";
          };
        };
      }
    ];
  };
}