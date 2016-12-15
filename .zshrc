# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="dallas"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git osx brew golang docker aws gpg-agent)
plugins=(git osx golang docker aws)

source $ZSH/oh-my-zsh.sh

USE_GPG_AGENT=false

# Yubikey GPG settings
# on OS X with GPGTools, comment out the next line:
# eval $(gpg-agent --daemon)
if [ "$USE_GPG_AGENT" = true ]; then
	GPG_TTY=$(tty)
	export GPG_TTY
	if [ -f "${HOME}/.gpg-agent-info" ]; then
	    . "${HOME}/.gpg-agent-info"
	    export GPG_AGENT_INFO
	    export SSH_AUTH_SOCK
	    export SSH_AGENT_PID
	fi
fi

# Prompt
setopt PROMPT_SUBST
function printKeyStatus {
    if [ "$USE_GPG_AGENT" = true ]; then
        echo %{$fg[yellow]%} \(YubiKey\)%{$reset_color%}
    else
        [ "$(ssh-add -l)" = "The agent has no identities." ] || echo %{$fg[blue]%}\(KEYS\)%{$reset_color%}
    fi
}
PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}%{$fg[green]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}[in]%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}[$(git_prompt_info)]⌚ %{$fg_bold[red]%}%*%{$reset_color%}$(printKeyStatus)
$ '
# End Prompt


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
    $HOME/.rvm/bin \
    /Applications/calibre.app/Contents/console.app/Contents/MacOS \
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

# Local CPAN
PATH="/Users/onordstrom/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/onordstrom/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/onordstrom/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/onordstrom/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/onordstrom/perl5"; export PERL_MM_OPT;

############################################################################
# Optimizely hrd necessary configuration must happen after cleaned up path #
############################################################################

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
############################################################################
# End Optimizely hrd configuration                                         #
############################################################################

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
alias aws='/usr/local/bin/aws' # the AWS in optimizely is old and needs to die

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

clean-docker() {
    docker rm -v $(docker ps -a -q -f status=exited)
    docker rmi $(docker images -f "dangling=true" -q)
}

envdocker() {
    eval $(docker-machine env default)
}

datawarehouse() {
    psql -h prd.dw.optimizely.com -d dw -U onordstrom
}

oladiff() {
    diff --side-by-side $1 $2 | colordiff
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
