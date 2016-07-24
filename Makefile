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

all: clean-backups update-submodules install-bash install-vim
.PHONY: clean-backups update-submodules install-bash install-vim

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
