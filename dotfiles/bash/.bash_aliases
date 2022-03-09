# Alias for tmux
alias tmux="tmux -u"

# Alias for Emacs
alias emacs="emacs -nw"

# Exporting for sudo prompt
export SUDO_PROMPT='[sudo] password for %p:⚷ '

# function for getting the weather
function weather() {
	curl wttr.in/"$1"
}

# function for creating package for java projects
function package() {
	i="$1"
	mkdir -p "${i//./\/}"
}

# creating an alias for the COMMERCIAL PORTABLE APPLICATIONS
COMMERCIAL_BASE_PATH="/home/bbsb/data/programs/nix_execs/commercial/"

# alias for vscode
alias code="${COMMERCIAL_BASE_PATH}vscode/bin/code"
# alias for sublime
alias sublime="${COMMERCIAL_BASE_PATH}sublime_text/sublime_text"
# alias for telegram
alias telegram="${COMMERCIAL_BASE_PATH}Telegram/Telegram"
# alias for eclipse
alias eclipse="${COMMERCIAL_BASE_PATH}eclipse/eclipse"

# creating an alias for the OPENSOURCE PORTABLE APPLICATIONS
OPENSOURCE_BASE_PATH="/home/bbsb/data/programs/nix_execs/opensource/"

# alias for ergoproxy
alias ergo="${OPENSOURCE_BASE_PATH}ergoproxy/ergo"
# alias for oh-my-posh
alias oh-my-posh="${OPENSOURCE_BASE_PATH}oh-my-posh/oh-my-posh"
# alias for youtube-dl
alias youtubedl="${OPENSOURCE_BASE_PATH}youtube-dl/youtube-dl"
# alias for screenkey
alias screenkey="${OPENSOURCE_BASE_PATH}screenkey/screenkey"

# creating an alias for the CUSTOM APPLICATIONS
CUSTOM_BASE_PATH="/home/bbsb/data/programs/nix_execs/custom/"

# alias for mkproject
alias mkproject="${CUSTOM_BASE_PATH}mkproject/mkproject"
# alias for notify
alias notify="${CUSTOM_BASE_PATH}notifier/notify"
