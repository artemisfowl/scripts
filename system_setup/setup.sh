#!/bin/bash

# Author : Sayantan Bhattacharya(sb)
# Copyright (C) 2018 Sayantan Bhattacharya, Nilangshu Bidyanta
# Fri, 08 Nov 2019 01:00:07 +0530

# file : setup.sh
# brief : setup any new system with the same set of directories and programs, automate the entire process of setting up the new installations.
# currently supported : currently this script will be supported for Ubuntu only. Meybe this will be extendable to debian based systems

# [<source_of_program>] <string_for_the_user>
# this will be format which will be followed for displaying to the user from which source type the program was installed


#-----------------------------------------------------------------------------------
# CONSTANTS

# brief : bashrc file location
BASHRC_LOCATION="$HOME/.bashrc"

# brief : setting up the colors to be used
color_1="\e[1;37m"
color_2="\e[1;31m"
color_3="\e[1;33m"

# brief : for logging purposes
LOG_WARNING=$color_1
LOG_ERROR=$color_2
LOG_INFO=$color_3

#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# First create the directory structure

# function : append_bash_config()
# brief : add the 256 color support to the bashrc file location specified
append_bash_config() {
  echo -e "case \"$TERM\" in" >> "$BASHRC_LOCATION"
  echo -e "    xterm-color|*-256color) color_prompt=yes;;" >> "$BASHRC_LOCATION"
  echo -e "esac\n" >> "$BASHRC_LOCATION"
}

# function : print_fancy()
# brief : print the argument passed with a beautiful color
# params : [in] type of logging level; [in] string or value to be printed
print_fancy() {
  #echo -e "\e[38;5;227m$1 \e[1;38;5;76m$2\e[0m"
  echo -e "$1$2\e[0m"
}

# function : print_info()
# brief : print the string provided in info colors
# params : [in] string to be printed
print_info() {
  print_fancy "$LOG_INFO" "$1"
}

# function : print_warning()
# brief : print the string provided in warning colors
# params : [in] string to be printed
print_warning() {
  print_fancy "$LOG_WARNING" "$1"
}

# function : print_sep()
# brief : Print a separator as and when required
print_sep() {
  print_warning "-------------------------------------------------------------------"
}

# function : check_color_support()
# brief : check if the terminal is supporting 256 color support
check_color_support() {
  term_colors=$(tput colors)
  if [[ $term_colors -eq 256 ]]; then
    print_info "Terminal supports 256 color mode"
  else
    print_warning "Terminal has support for $(tput colors) colors only"
    print_info "Adding the support for 256 colors to the bash configuration file"

    # do this in a dummy bashrc file
    # since the file needs to be appended with this information, assume that the file exists.
    # yet perform a check if the file exists or not. In some cases it might not be present - let's not take a risk

    # this text needs to be added
    # set a fancy prompt (non-color, unless we know we "want" color)
    #   case "$TERM" in
    #       xterm-color|*-256color) color_prompt=yes;;
    #   esac
    if [ -f "$BASHRC_LOCATION" ]; then
      print_info "File found - appending to the file"
      append_bash_config
    else
      print_warning "File not found - creating the file"
      touch "$BASHRC_LOCATION"
      append_bash_config
    fi
  fi
  TERM=xterm-256color
}

# function : display_logo()
# brief : this function will display a snazzy logo for the Ubuntu systems provided 256 color support is enabled in the
# terminal
display_logo() {
  # first check if 256 color support is enabled or not
  # if not enabled - enable it
  # else display the logo
  check_color_support

  # now that the color support is setup - just show the logo
  # change the logo so that it reflects the colorscheme desired
  echo -e "$color_3                          \`oo++'\`     \e[0m"
  echo -e "${color_2}                          ./+o+-      "
  echo -e "${color_1}                  yyyyy- ${color_2}-yyyyyy+     "
  echo -e "${color_1}               ${color_1}://+//////${color_2}-yyyyyyo     "
  echo -e "${color_3}           .++ ${color_1}.:/++++++/-${color_2}.+sss/\`     "
  echo -e "${color_3}         .:++o:  ${color_1}/++++++++/:--:/-     "
  echo -e "${color_3}        o:+o+:++.${color_1}\`..\`\`\`.-/oo+++++/    "
  echo -e "${color_3}       .:+o:+o/.${color_1}          \`+sssoo+/   "
  echo -e "${color_1}  .++/+:${color_3}+oo+o:\`${color_1}             /sssooo.  "
  echo -e "${color_1} /+++//+:${color_3}\`oo+o${color_1}               /::--:.  "
  echo -e "${color_1} \+/+o+++${color_3}\`o++o${color_2}               ++////.  "
  echo -e "${color_1}  .++.o+${color_3}++oo+:\`${color_2}             /dddhhh.  "
  echo -e "${color_3}       .+.o+oo:.${color_2}          \`oddhhhh+   "
  echo -e "${color_3}        \+.++o+o\`${color_2}\`-\`\`\`\`.:ohdhhhhh+    "
  echo -e "${color_3}         \`:o+++ ${color_2}\`ohhhhhhhhyo++os:     "
  echo -e "${color_3}           .o:${color_2}\`.syhhhhhhh/${color_3}.oo++o\`     "
  echo -e "${color_2}               /osyyyyyyo${color_3}++ooo+++/    "
  echo -e "${color_2}                   \`\`\`\`\` ${color_3}+oo+++o\:    "
  echo -e "${color_3}                          \`oo++.      "

}

# function : cr_dir()
# brief : read in the array and then create the directories in the specified location
# params : [in] location where the subdirectories need to be created; [in] the array which has the sub directory names
cr_dir() {
  local location="$1"
  print_info "\nDirectories to be created in : $location\n"
  # first read in an array and then display the details
  local dir_arr=("${@}")
  for dir_name in "${dir_arr[@]}"
  do
    if [[ "$dir_name" != "$location" ]]; then
      print_info "Creating $location/$dir_name"
      mkdir -p "$location/$dir_name"
    fi
  done
  print_sep
}

# function : create_std_dir
# brief : function to create the standard directory structure in the new environment
create_std_dir() {
  # creating the basic directories
  cd "$1"
  mkdir -p "$1/data/code/"
  mkdir -p "$1/data/programs/"
  mkdir -p "$1/data/storage/"

  #------------------ code components and sub-directories ------------------
  # create the arrays holding the subdirectory names
  local code_sub_dirs=( commit test_bed misc )

  local commit_sub_dir=( bitbucket github )
  local tbed_sub_dirs=( skunkworks standalone )

  # commit component sub directories
  local bitbucket_sub_dirs=( git hg )

  # test_bed component sub directories
  local skunkworks_sub_dirs=( android eclipse intellij kern psp pycharm venv )
  local standalone_sub_dirs=( asm c cpp flex_bison ipython_notebooks java javascript misc python2 python3 shell TeX )

  # skunkworks - component sub directories
  local venv_sub_dirs=( python2 python3 )

  # standalone - component sub directories
  local js_sub_dirs=( angular jquery node )

  #------------------ programs components and sub-directories ------------------
  # first level sub directories under the program directory
  local programs_sub_dirs=( code_ref nix_execs repo_clone )

  # repo_clone component sub directories
  local repo_clone_sub_dirs=( cvs git hg svn wgetf )

  #------------------ storage components and sub-directories ------------------
  local storage_sub_dirs=( games misc mvc OS transmission youtube )

  # games - component sub directories
  local games_sub_dirs=( AAA indie )

  # transmission component sub directories
  local transmission_sub_dirs=( games misc mvc OS tv )

  # youtube component sub directories
  local youtube_sub_dirs=( misc music_videos tut_videos )

  # now let's make the directories
  # the function for creating the directories will take in an array for looping through the directory names
  # the other parameter would be the location where the sub directories would be created
	print_info "Creating code directory and subdirectories"
  cr_dir "$1/data/code" "${code_sub_dirs[@]}"
  cr_dir "$1/data/code/commit" "${commit_sub_dir[@]}"
  cr_dir "$1/data/code/commit/bitbucket" "${bitbucket_sub_dirs[@]}"
  cr_dir "$1/data/code/test_bed/" "${tbed_sub_dirs[@]}"
  cr_dir "$1/data/code/test_bed/skunkworks" "${skunkworks_sub_dirs[@]}"
  cr_dir "$1/data/code/test_bed/skunkworks/venv" "${venv_sub_dirs[@]}"
  cr_dir "$1/data/code/test_bed/standalone" "${standalone_sub_dirs[@]}"
  cr_dir "$1/data/code/test_bed/standalone/javascript" "${js_sub_dirs[@]}"

	print_info "Creating programs directory and subdirectories"
  cr_dir "$1/data/programs" "${programs_sub_dirs[@]}"
  cr_dir "$1/data/programs/repo_clone" "${repo_clone_sub_dirs[@]}"

	print_info "Creating storage directory and subdirectories"
  cr_dir "$1/data/storage" "${storage_sub_dirs[@]}"
  cr_dir "$1/data/storage/games" "${games_sub_dirs[@]}"
  cr_dir "$1/data/storage/transmission" "${transmission_sub_dirs[@]}"
  cr_dir "$1/data/storage/youtube" "${youtube_sub_dirs[@]}"
}

# function : is_installed()
# brief : function to check whether the provided program is installed or not
# params : [in] program to be installed
# return : [out] 0 if not installed, 1 if installed - maybe I will be changing this later while I start implementing the code
is_installed() {
  which $1 > /dev/null
  if [ "$?" -eq "1" ]; then
    return 0 # program is not installed
  else
    return 1 # program is installed
  fi
}

# function : proceed_ops()
# brief : function to check with the user whether to proceed to the next step or get out of the script execution
proceed_ops() {
  while true; do
    echo -en "\e[38;5;156mDo you wish to continue? [y/n]: \e[0m"
    read yn
    case "$yn" in
      [Yy]* ) break;;
      [Nn]* ) exit 1;;
      * ) ;;
    esac
  done
}

# function : install()
# brief : function to install the library or package passed to it
# params : [in] name of the library or package to be installed; [in] prog for type{program}, dpkg for type{package}
install() {
  # first check if the check needs to be done for dpkg or for program type
  if [ "$1" == "prog" ]; then
    # implement special checks for certain package names
    if [ "$2" == "neovim" ]; then
      is_installed "nvim"
    else
      is_installed "$2"
    fi
    # now check the status of the is_installed call
    if [ "$?" -eq "0" ]; then
      sudo apt install -y "$2"
    fi
  elif [ "$1" == "dpkg" ]; then
    # check the package name for liblua5.1 In Ubuntu 16.04 it is liblua5.1-0-dev and hence is kicking the install script to
    # try and install the package once again. Upon giving the root password, aptitude is automatically resolving it to the
    # correct name
    if [ "$(dpkg -s $2 | grep 'Status')" != "Status: install ok installed" ]; then
      sudo apt install -y "$2"
    fi
  fi
}

# function : install_vim()
# brief : function to clone, build and install Vim from source
# params : [in] Vim installation dependencies
install_vim() {
  local vim_dep_arr=("${@}")
  print_warning "[Aptitude - Universe/Multiverse Packages] Following packages are present in the system now - required for Vim\n"
  for dep in "${vim_dep_arr[@]}"
  do
    install "dpkg" "$dep"
    print_info "$dep"
  done
  print_sep
  print_warning "\n[Aptitude - Universe/Multiverse Packages] Dependencies for installing vim have been met\n"
  print_sep
  print_warning "[Git] Starting to clone vim to the specified location\n"

  # seems like the current directory is the one I want the script to be in
  print_info "Cloning the vim repository into $(pwd)/data/programs/repo_clone/git/vim/\n"
  git clone https://github.com/vim/vim.git "$(pwd)/data/programs/repo_clone/git/vim/" --progress

  # now start the build process
  cd "$(pwd)/data/programs/repo_clone/git/vim/"
  # cleaning before the configuration
  make clean
  make distclean

  # Configure Vim before starting the compilation
  ./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-pythoninterp=yes --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu --enable-python3interp=yes --with-python3-config-dir=/usr/lib/python3.5/config-3.6m-x86_64-linux-gnu --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 --enable-cscope --prefix=/usr/local
  make
  proceed_ops

  if [ "$?" -eq "0" ]; then
    sudo make install
  fi

  # go back to the parent directory - something went wrong here
  cd -
  #print_info "\nNow in $(pwd)\n"
}

# function : install_ag()
# brief : function to automate build from source and installation of silver-searcher
install_ag() {
  local dep_arr=( "$@" )
  print_warning "[Aptitude - Universe/Multiverse Packages] Following packages are present in the system now - required for silversearcher-ag for the system\n"
  for pkg_name in "${dep_arr[@]}"
  do
    install "dpkg" "${dep_arr[@]}"
    print_info "$pkg_name"
  done

  # now to clone the directory to the required location
  initial_location="$(pwd)"
  desired_location="$(pwd)/data/programs/repo_clone/git/the_silver_searcher/"
  # cloning the repository to the desired location/the_silver_searcher
  git clone https://github.com/ggreer/the_silver_searcher.git "$desired_location"

  # change the directory to the desired location
  cd "$desired_location"
  # executing the build script
  chmod +x ./build.sh
  ./build.sh

  # now run the sudo make install for installing it system wide
  print_info "silversearcher will be installed after this"
  sudo make install
  cd "$initial_location"
  #print_warning "$(pwd)"
  print_sep
}

# function : setup_plugs_dots()
# brief : function to set up the dot files as well as the vim plugins
# params : [in] dotfile url - the files need to be cloned from this repository
setup_plugs_dots() {
  print_info "[Git] Getting configuration files and scripts from : $1"
  initial_location="$(pwd)"
  desired_location="$(pwd)/data/programs/repo_clone/git/sb_personal_configs/"
  # change the directory to the location where all the cloning will take place
  mkdir -p "$desired_location"
  cd "$desired_location"
  git clone "$1"

  # now copy the files from this directory and get them set up - this needs to be changed a bit
	# assuming that it is inside desired_location - need to go inside the directory of scripts/dotfiles/bundle_heavy
	# bundle_heavy since this is a system core setup script
	cd "$desired_location/scripts/dotfiles/bundle_heavy"
	print_info "[vim] Copying bundle heavy vim configuration to home directory of current user"
  cp ./.vimrc "$HOME"

	print_info "[tmux] Copying tmux configuration file to home directory of current user"
	cd "$desired_location/dotfiles/"
  cp ./.tmux.conf "$HOME"

	# print the detail that the custom status bar configuration file can be found in which location
	print_info "[tmux-advanced] The custom statusbar configuration of tmux can be found in $desired_location/dotfiles/multiplexer_custom_sbar"

	# copying the screen configuration file to the home directory for the current user
	print_info "[screen] Copying screen configuration file to home directory of current user"
  cp ./.screenrc "$HOME"

  # edit the next bashrc from the one that is already present - default created in the installation
  # finally return back to the initial location
  cd "$initial_location"

	# start creating the locations for the vim plugins
	local vim_config_dir=( .vim )
	local vim_config_subdir=( bundle colors )

	print_info "[vim-setup] Setting vim configuration directories"
	cr_dir "$HOME" ${vim_config_dir[@]}
	cr_dir "$HOME/.vim/" ${vim_config_subdir[@]}

	# set up Vundle
	print_info "[vim-setup] Setting up Vim plugin manager - Vundle"
	print_info "[vim-setup] navigating to bundle directory"
	cd "$HOME/.vim/bundle"
	print_info "[vim-setup] Cloning the Vundle plugin manager from git"
	vundle_git_loc="https://github.com/VundleVim/Vundle.vim.git"
	git clone "$vundle_git_loc"

	print_info "[vim-setup] Initiating plugin installs"
	vim +BundleInstall +qall

	# Tue, 19 Nov 2019 02:36:00 +0530 : Now to start building YCM for Vim
	cd "$HOME/.vim/bundle/YouCompleteMe"
	# perform the recusive module cloning command
}

# function : setup_progs()
# brief : function to set up the programs based on priority and requirement
setup_progs() {
  # let's make the arrays according to the requirement
  local apt_install_arr=( git mc tmux irssi g++ clang neovim axel synaptic vlc alpine gnome-tweak-tool python python-pip python3-pip  ranger )
  # NOTE : gnome-tweak-tool will be required for Ubuntu 18.04 Bionic Beaver/PopOS as well.
  # NOTE : Because I require python 2.x also installed in my system. Installing the python package will install python2.7 base
  # in the system. Also pip will be required for both Python 3.x and 2.x
  local build_source_arr=( vim ag )
  local vim_deps=( libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 liblua5.1-0-dev libperl-dev )

	# silversearcher dependencies
  local ag_deps=( automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev )

	# for LaTeX
  local packages_arr=( texlive-full )

  # aptitude packages installation
  for prog_name in "${apt_install_arr[@]}"
  do
    install "prog" "$prog_name"
  done

  print_warning "[Repositories] Following programs are present in the system\n"
  for prog_name in "${apt_install_arr[@]}"
  do
    print_info "$prog_name"
  done
  print_sep

  # standalone aptitude package installation
  for prog_name in "${packages_arr[@]}"
  do
    install "dpkg" "$prog_name"
  done

  print_warning "[Aptitude - Universe/Multiverse Packages] Following packages are present in the system now\n"
  for prog_name in "${packages_arr[@]}"
  do
    print_info "$prog_name"
  done
  print_sep

  # build programs from source
  for prog_name in "${build_source_arr[@]}"
  do
    if [ "$prog_name" == "vim" ]; then
      install_vim "${vim_deps[@]}"
      print_warning "Vim will be installed\n"
    elif [ "$prog_name" == "ag" ]; then
      install_ag "${ag_deps[@]}" # there is some problem with the liblzma portion - have to check it
      print_warning "Silversearcher-ag will be installed\n"
    fi
  done
  print_sep

  # install the texlive-full package
  for pkg_name in "${packages_arr[@]}"
  do
    print_info "$pkg_name"
  done
  print_sep

  # now copy and set up the vim plugins - change the link for the dotfiles and figure out a way for getting the right system name
  dotfile_url="https://github.com/artemisfowl/scripts.git"
  # call the function for setting up the dotfiles and plugins
  setup_plugs_dots "$dotfile_url"
}

# function : main()
# brief : main function housing all other function calls
main() {
  display_logo
  print_info "\nEnvironment setup script - devel mode\nAuthor : sb, nb0dy\n\nProceeding to create the standard directory structure\n"
  print_sep
  # for testing purposes
  #temp_dir_location=$(mktemp -d)
  create_std_dir "$HOME"
  print_info "\nStarting to install the terminal based programs\n"
  proceed_ops
  print_sep
  setup_progs "$HOME"
  print_info "\nAll tasks completed - script execution ends here\n"
  print_sep

  # Start adding the function for setting up the minimal vimrc and other configurations
  # Also add the installation of urxvt to the list of applications
  # Try to setup the key combinations for installed applications
}

#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# Function execution block

# creating a main function which will be housing the calls to every other function
main
