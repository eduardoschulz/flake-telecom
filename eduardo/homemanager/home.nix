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
			feh
			fuse-common
			freetype
			gcc
			gimp
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
			nerdfonts
			go
			screen
			
			librewolf
			htop
			meslo-lg
			
			
			
			st
			dmenu
			slstatus
			dunst
			kubectl
			networkmanagerapplet 
			pasystray
			

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

		#	colors = {
		#		bright = {
		#			black = "0x988BA2";
		#			blue = "0x96CDFB";
	#				cyan = "0x89DCEB";
	#				green = "0xABE9B3";
	#				magenta = "0xF5C2E7";
	#				red = "0xF28FAD";
	#				white = "0xD9E0EE";
	#				yellow = "0xFAE3B0";
	#			};
	#			cursor = {
	#				cursor = "0xF5E0DC";
	#				text = "0x1E1D2F";
	#			};
	#			normal = {
	#				black = "0x6E6C7E";
	#				blue = "0x96CDFB";
	#				cyan = "0x89DCEB";
	#				green = "0xABE9B3";
	#				magenta = "0xF5C2E7";
	#				red = "0xF28FAD";
	#				white = "0xD9E0EE";
	#				yellow = "0xFAE3B0";
	#			};
	#			primary = {
	#				background = "0x1E1D2F";
	#				foreground = "0xD9E0EE";
	#			};
	#		};
			
			font = {
				size = 14;
				normal.family = "Meslo LG L ";
				italic.family = "Meslo LG L ";
				bold.family = "Meslo LG L ";
		};

		mouse = {
			hide_when_typing = true;
		};
		};


	};
	
services.dunst = {
	enable = true;
	catppuccin.enable = true;
};

 stylix = { #TODO figure out how this thing works
    targets.gtk.enable = false;
    targets.firefox.enable = false;
	};

#TODO Split into multiple config files
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
