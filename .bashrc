#!/bin/bash
# Ola's startup scripts (~/.bashrc)
# Last Modified: Fri Nov 16 01:58:59 EST 2001
#
# Give credit where it is due: many advanced features in this I have
# taken from jehsoms bashrc, this .bashrc should be accompanied by a
# .bash_profile containing one line
# [ -f "$HOME/.bashrc" ] && . $HOME/.bashrc
# 

usernames="ola"
# Figure out what our username is on this system
case " $usernames " in
    *" $USER "*)
        username=$USER
        ;;
    *)
        for i in $all_usernames; do
            eval [ -r ~$i/.bashrc ] && { username=$i; break; }
        done
        ;;
esac

unset PROMPT_COMMAND  # We have no prompt command; Useless and slow.
ulimit -c 0 # Remove this if you like core files :)
set -o vi
unalias -a #turn off all other aliases
#alias x='startx -- +xinerama'
alias x='startx'
#alias ls='ls --color'
alias la='ls -a'
alias ll='ls -l'
alias verify='ssh-add ~/.ssh/id_dsa'
alias destruct='ssh-add -D'
alias ant='cvs up >& /dev/null; /usr/bin/ant'
#alias resource='killall -USR1 bash'

# todo support
export TODO=~/Dropbox/todo
function todo() { if [ $# == "0" ]; then cat $TODO; else echo "• $@" >> $TODO; fi }
function todone() { sed -i -e "/$*/d" $TODO; }

# make all users bashes reread ~/.bash_profile
resource()
{
  for i in $(ps -ef  | grep bash | grep "^ola" | awk '{print $2}');
  do
    kill -USR1 $i
  done
}

# See what OS we're using... standard commands in one may not work in another.
case $(uname -s) in
    Linux) os=linux ;;
    *[bB][Ss][Dd]) os=bsd ;;
    *) os=unix ;;
esac

# ls colors
if [ "$os" = "linux" ]; then
  export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:*.tar=01;31:*.tgz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.rpm=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.pdf=01;35:*.h=00;31:*.cpp=00;36:*.c=00;36:ex=01;32"
  alias ls='ls --color'
  else
    export CLICOLOR=1 TERM=xterm-color
    alias ls='ls -F'
fi

# This addpath adds a path only if it's not already in $PATH and it's a dir.
function myaddpath () {
    case :$PATH: in *:$1:*) ;; *) [ -d $1 ] && PATH="$PATH${PATH:+:}$1" ;; esac
}

# Set path properly. Insert all paths you'd ever want to have in your $PATH.
_IFS="$IFS"; IFS=:
_PATH="$PATH"; PATH=
for path in $HOME/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin \
    /sbin /usr/X11R6/bin usr/share/texmf/bin /skiff/local/bin \
    /usr/lib/jdk1.3.1/bin $HOME/go/bin \
    $_PATH; do
    myaddpath $path
done
export PATH; unset _PATH
IFS=$_IFS; unset _IFS

eval [ -f "$HOME/goroot/golang-crosscompile/crosscompile.bash" ] && eval source "$HOME/goroot/golang-crosscompile/crosscompile.bash"

export GOBIN=$HOME/bin
export GOROOT=$HOME/goroot/go
export GOPATH=$HOME/go

case $HOSTNAME in
    *silver*)
        HOST="silver"
        ;;
    *scrape*)
        HOST="scrape" 
        ;;
esac

export HOST=${HOST:-${HOSTNAME%%.*}}

# This ensures that when using su, we will still run our own bashrc
[ "$os" = "linux" ] && alias su="su -c 'bash -rcfile ~$username/.bashrc'"

# put this ~/.inputrc
# set bell-style none
eval [ -f \~$username/.inputrc ] && eval export INPUTRC=\~$username/.inputrc

C_WHTE="\[\033[0;37m\]" C_RED="\[\033[0;31m\]"
C_GREN="\[\033[0;32m\]" C_BRWN="\[\033[0;33m\]"
C_BLUE="\[\033[0;34m\]" C_PINK="\[\033[0;35m\]"
C_NEON="\[\033[0;36m\]" C_WHTE="\[\033[0;37m\]"

# FIXME: go thru and correct the colors later
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
CYAN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
BROWN="\[\033[0;33m\]"
LIGHT_GRAY="\[\033[0;37m\]"
DARK_GRAY="\[\033[1;30m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_CYAN="\[\033[1;36m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
NC="\[\033[0m\]"

#PS1="$COLOR3\u$C_GREN@$C_PINK\h$C_BLUE|\$(date +%T)|$C_PINK\w$C_BLUE|$C_WHTE\n\$ "
# no puts "KEYS" if keys are active
#PS1="$COLOR3\u$C_GREN@$C_PINK\h\$( if \$(ssh-add -l 2>/dev/null | grep "^[:alnum:]*" > /dev/null; then echo \"$C_NEON(KEYS)\") fi $C_BLUE|\$(date +%T)|$C_PINK\w$C_BLUE|$C_WHTE\n\$ "
#PS1="$COLOR3\u$C_GREN@$C_PINK\h\$( "`ssh-add -l | grep 'The agent has no id' >& /dev/null`" -gt 0 ] && echo '-KEYS-';)$C_BLUE|\$(date +%T)|$C_PINK\w$C_BLUE|$C_WHTE\n\$ "

if [ $HOSTNAME = "silver" ];
then
	PS1="$COLOR3\u$C_GREN@$C_PINK\h\$([ \"\$(ssh-add -l)\" = \"The agent has no identities.\" ] || echo \"$C_NEON(KEYS)\")$C_BLUE|\$(date +%T)|$C_PINK\w$C_BLUE|$C_WHTE\n\$ "
else
	PS1="$COLOR3\u$C_GREN@$C_PINK\h$C_BLUE|\$(date +%T)|$C_PINK\w$C_BLUE|$C_WHTE\n\$ "
fi

if [ $HOSTNAME = "bb" ];
then 
    export P4USER=olan
    export P4PASSWD=05f35b6bad
    export P4CONFIG=p4config.txt
fi

export PS1
export PS2='> '
export ignoreeof=0
export checkwinsize=1 # update LINES and COLUMNS
export cmdhist=1      # multiple repeated cmds go in one
export dotglob=1      # expand . files in expansions please
export cdspell=1      # fix cd <dir> spell errors
export histappend=0   # don't write the history file
export EDITOR='vim'
export REPLYTO='ola.nordstrom@gmail.com'
export COLORFGBG="lightgray;black" # needed for the slang library, hench mutt "default" color
export CALENDAR_DIR="~/.calendar"

# umask settings
# umask 002      makes files -rw-rw-r-- and directories -rwxrwxr-x
# umask 022      makes files -rw-r--r-- and directories -rwxr-xr-x
# umask 006      makes files -rw-rw---- and directories -rwxrwx---
# umask 066      makes files -rw------- and directories -rwx------
umask 066

# Ola linux eterm
[ "$TERM" = xterm ] && export PROMPT_COMMAND='echo -ne "\033]0;Terminology .:. ${PWD}\007"'

#Mac term is xterm-color
[ "$TERM" = xterm-color ] && export PROMPT_COMMAND='echo -ne "\033]0;${USER} .:. ${PWD}\007"'

if [ -f ~/.bash_history ]; then
  rm ~/.bash_history; ln -s /dev/null ~/.bash_history
fi

# When the shell is sent SIGUSR1, it re-sources .bashrc
eval trap "\"SIGUSR1=1; . ~$username/.bash_profile; kill -2 $$\"" USR1

function xtitle ()
{
  case $TERM in
    *term | rxvt)
    echo -n -e "\033]0;$*\007" ;;
    *)  ;;
  esac
}

# aliases...
alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'
alias ncftp="xtitle ncFTP ; ncftp"

function man()
{
    xtitle "man $@"
    /usr/bin/man $@
}

function vi()
{
    local NAME=$(basename $@)
    echo -n -e "\033]0; vi $NAME \007"
    /usr/bin/vi $@
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

ipaddr()
{
  if [ ! $# = 1 ]; then
    INTERFACE="en0"
  else
    INTERFACE="$1"
  fi
  ifconfig $INTERFACE | grep 'inet ' | awk '{print $2}'
}

# extended globbing
shopt -s extglob
set +o nounset    # otherwise some completions will fail
bind 'TAB:complete'    

complete -A hostname   rsh rcp telnet rlogin ftp ping disk
complete -A command    nohup exec eval trace gdb
complete -A command    command type which
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # currently same as builtins
complete -A shopt      shopt
complete -A stopped -P '%' bg 
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir                         
complete -A directory  -o default cd

complete -f chown ln more less cat strip
complete -d mkdir rmdir
complete -u su
complete -W '`/bin/ls /var/log/packages/`' removepkg
complete -f -X '!*.tgz' installpkg
complete -f -X '*.gz' gunzip gzip
complete -f -X '*.Z' compress
complete -f -X '*.bz2' bzip2
complete -f -X '!*.+(gz|tgz|Gz|Z)' gunzip gzcat zcat zmore gzip
complete -f -X '!*.Z' uncompress
complete -f -X '!*.+(diff.patch)' patch
complete -f -X '!*.+(png|gif|jpg|jpeg|GIF|JPG|bmp|tif|tiff)' gqview
complete -f -X '!*.+(divx|DivX|asf|ASF|avi|AVI)' aviplay xine
complete -f -X '!*.mp+(e|)g' xmovie gtv xine
complete -f -X '!*.pdf' acroread 
complete -f -X '!*.html' appletviewer
complete -f -X '!*.java' javac jikes
complete -f -X '!*.+(ps|dvi)' gv ggv
complete -f -X '!*.tex' pdflatex pslatex tex latex
complete -f -X '!*.+(avi|AVI|mpg|MPG|mpeg|mov|MOV)' xanim xine
#complete -W 'add checkout commit diff export history import login rdiff release remove rtag status tag update' cvs

# from abs
_make_targets ()
{
  local mdef makef gcmd cur prev i

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  # if prev argument is -f, return possible filename completions.
  # we could be a little smarter here and return matches against
  # `makefile Makefile *.mk', whatever exists
  case "$prev" in
      -*f)    COMPREPLY=( $(compgen -f $cur ) ); return 0;;
  esac

  # if we want an option, return the possible posix options
  case "$cur" in
      -)      COMPREPLY=(-e -f -i -k -n -p -q -r -S -s -t); return 0;;
  esac

  # make reads `makefile' before `Makefile'
  if [ -f makefile ]; then
      mdef=makefile                                        
  elif [ -f Makefile ]; then                               
      mdef=Makefile                                        
  else                                                     
      mdef=*.mk               # local convention           
  fi                                                       
                                                           
  # before we scan for targets, see if a makefile name was specified
  # with -f                                                
  for (( i=0; i < ${#COMP_WORDS[@]}; i++ )); do            
      if [[ ${COMP_WORDS[i]} == -*f ]]; then               
          eval makef=${COMP_WORDS[i+1]}       # eval for tilde expansion
          break                                            
      fi                                                   
  done                                                     
                                                           
      [ -z "$makef" ] && makef=$mdef                       
                                                           
  # if we have a partial word to complete, restrict completions to
  # matches of that word                                   
  if [ -n "$2" ]; then gcmd='grep "^$2"' ; else gcmd=cat ; fi
                                                           
  # if we don't want to use *.mk, we can take out the cat and use
  # test -f $makef and input redirection                 
  COMPREPLY=( $(cat $makef 2>/dev/null | awk 'BEGIN {FS=":"} /^[^.#   ][^=]*:/ {print $1}' | tr -s ' ' '\012' | sort -u | eval $gcmd ) )
}                                                          
                                                           
complete -F _make_targets -X '+($*|*.[cho])' make gmake pmake
