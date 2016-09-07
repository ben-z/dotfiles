DOTFILES := $(shell pwd)
BAK_SUFFIX = .dotfiles.bak

# vim
VIM_PATH = ~/.vim
VIMRC_PATH = ~/.vimrc
VIM_DOTFILES_PATH = vim

# bash
BASH_ALIASES_PATH = ~/.bash_aliases
BASH_PROFILE_PATH = ~/.bash_profile
BASH_LOGOUT_PATH = ~/.bash_logout
BASHRC_PATH = ~/.bashrc
BASH_DOTFILES_PATH = bash

# xmonad
DOT_XMONAD_PATH = ~/.xmonad
DOT_STALONETRAYRC_PATH = ~/.stalonetrayrc
DOT_XMOBARRC_PATH = ~/.xmobarrc
XMONAD_DOTFILES_PATH = xmonad

# nixos
NIXOS_DOTFILES_PATH = nixos
NIXOS_CONFIGURATION_PATH = /etc/nixos/configuration.nix

# terminator
TERMINATOR_DOTFILES_PATH = terminator
TERMINATOR_CONFIGURATION_PATH = ~/.config/terminator/config

all: clean-backups update-submodules install-bash install-vim
.PHONY: clean-backups update-submodules install-bash install-vim install-xmonad

update-submodules:
	git submodule update --init

clean-backups:
	cd && rm -f *$(BAK_SUFFIX) && rm -f .*$(BAK_SUFFIX)

install-bash:
# backup .bash* if they already exist in ~
ifneq ("$(wildcard $(BASH_ALIASES_PATH))","")
	mv $(BASH_ALIASES_PATH) $(BASH_ALIASES_PATH)$(BAK_SUFFIX)
endif
ifneq ("$(wildcard $(BASH_PROFILE_PATH))","")
	mv $(BASH_PROFILE_PATH) $(BASH_PROFILE_PATH)$(BAK_SUFFIX)
endif
ifneq ("$(wildcard $(BASH_LOGOUT_PATH))","")
	mv $(BASH_LOGOUT_PATH) $(BASH_LOGOUT_PATH)$(BAK_SUFFIX)
endif
ifneq ("$(wildcard $(BASHRC_PATH))","")
	mv $(BASHRC_PATH) $(BASHRC_PATH)$(BAK_SUFFIX)
endif

# link .bash*
	ln -s $(DOTFILES)/$(BASH_DOTFILES_PATH)/$(notdir $(BASH_ALIASES_PATH)) $(BASH_ALIASES_PATH)
	ln -s $(DOTFILES)/$(BASH_DOTFILES_PATH)/$(notdir $(BASH_PROFILE_PATH)) $(BASH_PROFILE_PATH)
	ln -s $(DOTFILES)/$(BASH_DOTFILES_PATH)/$(notdir $(BASH_LOGOUT_PATH)) $(BASH_LOGOUT_PATH)
	ln -s $(DOTFILES)/$(BASH_DOTFILES_PATH)/$(notdir $(BASHRC_PATH)) $(BASHRC_PATH)

install-vim:
# backup .vim and .vimrc if they already exist in ~
ifneq ("$(wildcard $(VIM_PATH))","")
	mv $(VIM_PATH) $(VIM_PATH)$(BAK_SUFFIX)
endif
ifneq ("$(wildcard $(VIMRC_PATH))","")
	mv $(VIMRC_PATH) $(VIMRC_PATH)$(BAK_SUFFIX)
endif

# link .vim and .vimrc
	ln -s $(DOTFILES)/$(VIM_DOTFILES_PATH)/$(notdir $(VIM_PATH)) $(VIM_PATH)
	ln -s $(DOTFILES)/$(VIM_DOTFILES_PATH)/$(notdir $(VIMRC_PATH)) $(VIMRC_PATH)

install-xmonad:
ifneq ("$(wildcard $(DOT_XMONAD_PATH))","")
	mv -T $(DOT_XMONAD_PATH) $(DOT_XMONAD_PATH)$(BAK_SUFFIX)
endif
ifneq ("$(wildcard $(DOT_XMOBARRC_PATH))","")
	mv $(DOT_XMOBARRC_PATH) $(DOT_XMOBARRC_PATH)$(BAK_SUFFIX)
endif
ifneq ("$(wildcard $(DOT_STALONETRAYRC_PATH))","")
	mv $(DOT_STALONETRAYRC_PATH) $(DOT_STALONETRAYRC_PATH)$(BAK_SUFFIX)
endif
	ln -s $(DOTFILES)/$(XMONAD_DOTFILES_PATH)/$(notdir $(DOT_XMONAD_PATH)) $(DOT_XMONAD_PATH)
	ln -s $(DOTFILES)/$(XMONAD_DOTFILES_PATH)/$(notdir $(DOT_XMOBARRC_PATH)) $(DOT_XMOBARRC_PATH)
	ln -s $(DOTFILES)/$(XMONAD_DOTFILES_PATH)/$(notdir $(DOT_STALONETRAYRC_PATH)) $(DOT_STALONETRAYRC_PATH)

install-nixos:
ifneq ("$(wildcard $(NIXOS_CONFIGURATION_PATH))","")
	sudo mv $(NIXOS_CONFIGURATION_PATH) $(NIXOS_CONFIGURATION_PATH)$(BAK_SUFFIX)
endif
	sudo ln -s $(DOTFILES)/$(NIXOS_DOTFILES_PATH)/$(notdir $(NIXOS_CONFIGURATION_PATH)) $(NIXOS_CONFIGURATION_PATH)

install-terminator:
	mkdir -p $(dir $(TERMINATOR_CONFIGURATION_PATH))
ifneq ("$(wildcard $(TERMINATOR_CONFIGURATION_PATH))","")
	mv -T $(TERMINATOR_CONFIGURATION_PATH) $(TERMINATOR_CONFIGURATION_PATH)$(BAK_SUFFIX)
endif
	ln -s $(DOTFILES)/$(TERMINATOR_DOTFILES_PATH)/$(notdir $(TERMINATOR_CONFIGURATION_PATH)) $(TERMINATOR_CONFIGURATION_PATH)
