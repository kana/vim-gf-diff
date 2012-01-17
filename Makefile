# Makefile for usual Vim plugin

REPOS_TYPE := vim-script
INSTALLATION_DIR := $(HOME)/.vim
TARGETS_STATIC = $(filter %.vim %.txt,$(all_files_in_repos))
TARGETS_ARCHIVED = $(all_files_in_repos) mduem/Makefile
DEPS := vim-gf-user
DEP_vim_gf_user_URI := git://github.com/kana/vim-gf-user.git
DEP_vim_gf_user_VERSION := 0.0.0




include mduem/Makefile

# __END__
