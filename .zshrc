source /Users/onordstrom/workspace/optimizely/.source_this.sh
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="amuse"


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git osx brew golang docker aws)

source $ZSH/oh-my-zsh.sh

### Prompt
setopt PROMPT_SUBST
function getKeyStatus {
[ "$(ssh-add -l)" = "The agent has no identities." ] || echo %{$fg[blue]%}\(KEYS\)%{$reset_color%}
}
PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}%{$fg[green]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}[in]%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}[$(git_prompt_info)]⌚ %{$fg_bold[red]%}%*%{$reset_color%}$(getKeyStatus)
$ '
#%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
#RPROMPT='%{$fg_bold[red]%}$(rbenv_version)%{$reset_color%}'
#RPROMPT='[ \"\$(ssh-add -l)\" = \"The agent has no identities.\" ] || %{$fg[yellow]%}KEYS%{$reset_color%}'
#RPROMPT='$(getKeyStatus)'
### End Prompt

### Fix History
if [ -f ~/.zsh_history ]; then
  rm ~/.zsh_history; ln -s /dev/null ~/.zsh_history
fi
### End History

### Fix PATH
_IFS="$IFS"; IFS=:
_PATH="$PATH"; PATH=
NP=
[ -e /usr/local/bin/go ] && export GOBIN="$(/usr/local/bin/go env GOROOT)/bin"
for path in $HOME/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin \
    $HOME/workspace/optimizely/out/node-0.10.40/out/bin \
    /usr/local/bin /usr/bin /bin /usr/sbin /sbin \
    /usr/local/texlive/2015/bin/x86_64-darwin \
    $HOME/Library/Android/sdk/platform-tools $HOME/tools/arcanist/bin \
    /usr/local/opt/go/bin $HOME/go/bin $GOBIN /opt/X11/bin $_PATH; do
    [ -d $path ] && NP="$NP:$path"
done
PATH=$NP; unset _NP
export PATH; unset _PATH
IFS=$_IFS; unset _IFS

export GOPATH=$HOME/go
### End PATH

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# allow corefiles (in /core on OS X)
limit -s coredumpsize unlimited

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias destruct='ssh-add -D'
alias verify='ssh-add ~/.ssh/id_rsa'
alias vi='/usr/local/bin/vim'
alias vi='/usr/local/bin/vim'

ulimit -c 0 # Remove this if you like core files :)
set -o vi

# copies p4 passwd to clipboard
p4pass() {
    env | grep -i p4pass | awk -F= '{ print $2  }' | pbcopy
    echo "perforce password copied to pasteboard"
}

docker-ip() {
    docker-machine ip 2> /dev/null
}

envdocker() {
    eval $(docker-machine env default)
}

datawarehouse() {
    psql -h prd.dw.optimizely.com -d dw -U onordstrom
}

function getrands()
{
    for i in {1..5};do od -vAn -N4 -tu4 < /dev/urandom; done
}

showpem() {
    openssl x509 -inform PEM -noout -text -in $1
}

# swap 2 filenames
function swap()
{
  local TMPFILE=tmp.$$
  mv $1 $TMPFILE
  mv $2 $1
  mv $TMPFILE $2
}

function ii()   # get current host related info
{
  #echo -e "\nYou are logged on ${RED}$HOST"
  echo -e "\nYou are logged on \033[1;32m$HOST\033[0m"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Memory stats :$NC " ; free
  #my_ip 2>&- ;
  echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
  echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
  echo
}

function repeat()       # repeat n times command
{
  local i max
  max=$1; shift;
  for ((i=1; i <= max ; i++)); do  # --> C-like syntax
    eval "$@";
  done
}

# sync silver and scrape directories
# TODO switch to zsh
synccomp()
{
  H=$HOME
  FILES="$H/.bashrc $H/.vim $H/.vimrc $H/.inputrc"
  if [ `hostname` = "silver" ]; then
    rsync -av --delete --force -e "ssh -o ClearAllForwardings=yes" $FILES scrape:.
  else
    echo "unknown host"
  fi
}

# TODO fix for OS X and Linux (interface names)
ipaddr()
{
  if [ ! $# = 1 ]; then
    INTERFACE="en0"
  else
    INTERFACE="$1"
  fi
  ifconfig $INTERFACE | grep 'inet ' | awk '{print $2}'
}

export NVM_DIR="/Users/onordstrom/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Optimizely env sourced from ~/.bash_profile
source $HOME/workspace/optimizely/.source_this.sh
# The next line updates PATH for the Google Cloud SDK.
source $HOME/.google-cloud-sdk/path.zsh.inc
# The next line enables shell command completion for gcloud.
source $HOME/.google-cloud-sdk/completion.zsh.inc
# Source arc bash completions
source $HOME/tools/arcanist/resources/shell/bash-completion
