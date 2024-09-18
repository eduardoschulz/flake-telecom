{ config, pkgs, inputs, ...}: let
	username = "demo";
	nixvimconfig = import ./nixvim;

in {
	fonts.fontconfig.enable = true;
	xdg = {
		enable = true;
		userDirs = {
			enable = true;
			createDirectories = true;
		};
	};

	catppuccin.flavor = "macchiato";

	nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };	

	programs.home-manager.enable = true;
	home = {
		username = "${username}";
		homeDirectory = "/home/${username}";
		stateVersion = "24.05";

		packages = with pkgs; [
			wget
			neofetch
			cargo
			dunst
			fuse-common
			freetype
			gcc
			git
			unzip
			virt-manager
			xdg-desktop-portal-gtk
			zoxide
			firefox
			zathura
			pandoc
			texliveFull
			pavucontrol
			go
			screen
			
			librewolf
			htop
			meslo-lg
			
			kubectl
			networkmanagerapplet 
			

		];
	};
	
	programs.alacritty = {
		enable = true;
		catppuccin.enable = true;
		settings = {
			window = {
				opacity = 0.9;
				blur = true;
				decorations = "full";
				dynamic_title = true;
			};
			bell.animation = "EaseOutExpo";
			bell.duration = 0;

			
			font = {
				size = 14;
				normal.family = "Meslo LG L ";
				italic.family = "Meslo LG L ";
				bold.family = "Meslo LG L ";
		};

		mouse = {
			hide_when_typing = false;
		};
		};


	};
	
services.dunst = {
	enable = true;
	catppuccin.enable = true;
};

programs.neovim = 
	let
    		toLua = str: "lua << EOF\n${str}\nEOF\n";
    		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    	in
	{
	
		enable = true;
		extraPackages = with pkgs; [


			gopls
			lua-language-server
			xclip
			wl-clipboard
		];

		plugins = with pkgs.vimPlugins; [
		
			{
				plugin = nvim-lspconfig;
				config = toLuaFile ./nvim/plugin/lsp.lua; 
			}

			{
				plugin = comment-nvim;
				config = toLua "require(\"Comment\").setup()";
			}
			
			{
				plugin = nvim-cmp;
				config = toLuaFile ./nvim/plugin/lsp.lua;

			}
			
			cmp_luasnip
			cmp-nvim-lsp
			luasnip
			friendly-snippets
			catppuccin-nvim
		];
		
		extraLuaConfig = ''
			${builtins.readFile ./nvim/options.lua}
		'';
	};

programs.tmux = { enable = true;
	keyMode = "vi";
};

services.picom = {
	enable = true;
	vSync = true;
};

}
