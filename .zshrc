# Path to your oh-my-zsh installation.
export PATH=$PATH:/usr/local/bin
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Look in ~/.oh-my-zsh/themes/
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
plugins=(git osx golang docker aws tmux kubectl)

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

export NNN_BMS='d:~/Documents;D:~/Downloads/'

# Prompt
setopt PROMPT_SUBST
function printDevEnvironment {
  if [[ "$DEV_ENVIRONMENT" != "" ]]; then
    echo %{$fg[red]%}\($DEV_ENVIRONMENT\) %{$reset_color%}
  fi
}
function printKeyStatus {
  if [ "$USE_GPG_AGENT" = true ]; then
    echo %{$fg[yellow]%} \(YubiKey\)%{$reset_color%}
  else
    # only run if ssh-add exists
    if type ssh-add >& /dev/null; then
      [ "$(ssh-add -l)" = "The agent has no identities." ] || echo %{$fg[blue]%}\(KEYS\)%{$reset_color%}
    fi
  fi
}
PROMPT='
$(printDevEnvironment)%{$fg[magenta]%}%n%{$reset_color%}%{$fg[green]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}[in]%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}[$(git_prompt_info)]⌚ %{$fg_bold[red]%}%*%{$reset_color%}$(printKeyStatus)
$ '
# End Prompt


### Fix History
if [ -f ~/.zsh_history ]; then
    rm ~/.zsh_history; ln -s /dev/null ~/.zsh_history
fi
### End History

export PYENV_ROOT="~/.pyenv"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

############################################################################
# Backblaze
############################################################################
#
if [[ -x '/usr/libexec/java_home' ]]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi
export BZ_UNIVERSE="$HOME/code"

# Golang
[ -e /usr/local/bin/go ] && export GOBIN="$(/usr/local/bin/go env GOROOT)/bin"

### Fix PATH
_IFS="$IFS"; IFS=:
_PATH="$PATH"; PATH=
NP=$HOME/bin # initialize NP
for path in /usr/local/opt/openssl/bin /opt/local/bin /usr/bin /bin \
    /usr/local/bin /usr/sbin /usr/local/opt/openssl/bin \
    $BZ_UNIVERSE/bzmono/www/java/scripts $BZ_UNIVERSE/bzmono/bztools/scripts \
    $BZ_UNIVERSE/configMgmt/scripts \
    $HOME/.rvm/bin $HOME/google-cloud-sdk/bin \
    /Applications/calibre.app/Contents/console.app/Contents/MacOS \
    /usr/local/bin /usr/bin /bin /usr/sbin /sbin \
    /usr/local/texlive/2015/bin/x86_64-darwin \
    $HOME/Library/Android/sdk/platform-tools $HOME/tools/arcanist/bin \
    /usr/local/opt/go/bin $HOME/go/bin $GOBIN /opt/X11/bin $_PATH; do
    [ -d $path ] && NP="$NP:$path"
done
PATH=$NP; unset _NP
IFS=$_IFS; unset _IFS
export PATH; unset _PATH
###

if type pyenv >& /dev/null; then # only run if pyenv is present
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

export GOPATH=$HOME/go
export EDITOR='nvim'
export LESS="-F -X $LESS" # tells less not to paginate if less than a page

# allow corefiles (in /core on OS X)
limit -s coredumpsize unlimited

export SSH_KEY_PATH="~/.ssh/dsa_id"

# For a full list of active aliases, run `alias`.
alias destruct='ssh-add -D'
alias verify='ssh-add ~/.ssh/id_rsa ~/.ssh/id_rsa_legacy ~/.ssh/id_ed25519'
if type nvim >& /dev/null; then
  alias vi='nvim'
fi
alias ag='ag --path-to-ignore ~/.ignore'
alias chrome-no-ext='open /Applications/Google\ Chrome.app --args --disable-extensions'
alias fixmouse='osascript ~/bin/osx/setMouseTrackingSpeed.scpt 1 && osascript ~/bin/osx/setMouseTrackingSpeed.scpt 5'
alias cal='gcal --starting-day=1'


# fix ctags on mac
if [[ -x '/usr/local/bin/ctags' ]]
then 
    alias ctags='/usr/local/bin/ctags'
fi

ulimit -c 0 # Remove this if you like core files :)
set -o vi

# fzf via Homebrew
# CTRL-t to launch
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# fzf via local installation
if [ -e ~/.fzf/shell ]; then
  _append_to_path ~/.fzf/bin
  source ~/.fzf/shell/key-bindings.zsh
  source ~/.fzf/shell/completion.zsh
fi

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

############################################################################
# Miscellaneous functions                                                  #
############################################################################

function clean-docker() {
    docker rm -v $(docker ps -a -q -f status=exited)
    docker rmi $(docker images -f "dangling=true" -q)
}

function oladiff() {
    diff --side-by-side $1 $2 | colordiff
}

function getrands()
{
    for i in {1..5};do od -vAn -N4 -tu4 < /dev/urandom; done
}

function randompass()
{
    cat /dev/urandom | env LC_CTYPE=C tr -dc "a-zA-Z0-9-_\$\?" | head -c 16; echo
}

function randomKeyIVSalt() {
    # spits out salt, key and IV from 32 random bytes.
    openssl aes-256-cbc -salt -pbkdf2 -iter 100000 -k $(cat /dev/urandom | head -c 32 | base64) -P -md sha512
}

function showpem() {
    openssl x509 -inform PEM -noout -text -in $1
}

function javatags() {
    find . -type f | ag '.java$' > cscope.files
    uctags -L cscope.files
    rm cscope.files
}

function swap() # swap 2 filenames
{
  local TMPFILE=tmp.$$
  mv $1 $TMPFILE
  mv $2 $1
  mv $TMPFILE $2
}

function ii()   # get current host related info
{
  echo -e "\nYou are logged on ${RED}$HOST"
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

function ipaddrs()
{
  for interface in $(ifconfig | egrep '^[a-z0-9]+\:' | awk -F: '{print $1}'); do
    ifconfig $interface | grep 'inet ' > /dev/null
    if [ "$?" -eq 0 ]; then
      echo -n "$interface --> "
      ifconfig $interface | grep 'inet ' | awk '{print $2}'
    fi
  done
}

############################################################################
# Profile managers
############################################################################

if type rbenv >& /dev/null; then
  eval "$(rbenv init -)" # this is needed for rbenv
fi
if type direnv >& /dev/null; then
  eval "$(direnv hook zsh)" # run direnv so that it'll pickup .envrc files from repos
fi

eval "$(direnv hook zsh)"
