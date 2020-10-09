# Borrowed from Eli Benderski
# (http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash)
log_bash_persistent_history()
{
  local date_part=`history 1 | awk '{ print $1 }'`
  local command_part=`history 1 | awk '{ $1=""; print $0 }'`
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]; then
    command_part="$PWD: $command_part"
    echo $date_part "|" "$command_part" >> ~/.persistent_history
    export PERSISTENT_HISTORY_LAST="$command_part"
  fi
}

# Stuff to do on PROMPT_COMMAND
run_on_prompt_command()
{
  log_bash_persistent_history
}

persistent_history()
{
  if [ -z "$1" ]; then
    cat $HOME/.persistent_history
  else
    local N
    N=-10
    case "$1" in
    -[0-9]*)
      N="$1"
      shift
      ;;
    esac
    grep "$@" < $HOME/.persistent_history | tail $N
  fi
}

PROMPT_COMMAND=run_on_prompt_command

# Ignore common trash
goodgrep() {
  grep --exclude=tags --exclude=cscope\* --exclude-dir .svn --exclude-dir .git "$@"
}

grephere() {
  goodgrep -R "$@" .
}

vimfind() {
  local p="$1"
  shift
  vim $(find "$@" -name "$p")
}

vimgrep() {
  vim $(grep -r -l -i "$1" ${2:-.} | grep -v '\<tags\>\|\.git') +':set ic hls' +1 +/"$1"
}

vimconflicts() {
  vim $(git diff --name-only --diff-filter=U)
}

cdmd() {
  if mkdir -p "$1"; then
    cd "$1"
  fi
}

# Signal loudly about completion
yell() {
  local msg="$SHELL (pid $$)"
  if test -n "$1"; then
    msg="${msg}: $1"
  fi
  case $(uname -o) in
  Cygwin)
    rundll32 user32.dll,MessageBeep
    cmd /c "msg $USER \"$msg\""
    ;;
  *)
    echo >&2 "Don't know how to notify on $(uname -o)"
    ;;
  esac
}

# Based on autojump
jc() {
  local d=$(find -name "$1")
  case $(echo "$d" | wc -l) in
  1)
    cd $d
    ;;
  0)
    echo >&2 "Subdirectory '$1' not found"
    return 1
    ;;
  *)
    echo "More than one '$1' subdirectory found:" >&2
    (echo "$d" | sed 's/^/  /') >&2
    return 1
    ;;
  esac
}

# "fn [$D] $P" -> "find [$D] -name $P"
fn() {
  local D
  case $# in
  1)
    D=.
    ;;
  2)
    D="$1"
    shift
    ;;
  *)
    echo >&2 "Usage: fn DIR PATTERN"
    return 1
    ;;
  esac

  find "$D" -name "$1"
}

# Opens new tab in Xterm
newtab() {
  local STARTUP=$(mktemp)
  echo "rm -f $STARTUP" >> $STARTUP
  shopt -p >> $STARTUP
  set | grep -v '^\(\(BASH\|SHELL\)OPTS\|BASH_VERSINFO\|\(EU\|PP\|U\)ID\)' >> $STARTUP
  alias >> $STARTUP
  echo "cd $PWD" >> $STARTUP
  case $(uname -o) in
  Cygwin)
    cygstart mintty bash --init-file $STARTUP
    ;;
  *)
    echo >&2 "Don't know how to open new tab on this platform"
    return 1
    ;;
  esac
}

watch-network() {
  local DT_MIN=3
  local DT_MAX=60
  local SITE=yandex.ru

  DT=$DT_MIN
  while true; do
    if ! ping -n 1 yandex.ru; then
      sleep 1
      if ping -n 1 yandex.ru; then
        echo 'Ignoring short connection loss...'
      else
        echo 'Connection lost'
        DT=0
      fi
    elif test $DT -eq 0; then
      DT=$DT_MIN
    elif test $DT -lt $DT_MAX; then
      DT=$((DT * 2))
    elif test $DT -gt $DT_MAX; then
      DT=$DT_MAX
    fi
    echo "Sleeping for $DT seconds..."
    sleep $DT
  done
}

alias m='nice make' mi='nice make install' mck='nice make -k check'
if test -d /proc; then
  alias mp="nice make -j$(grep -c '^processor' /proc/cpuinfo)"
  alias mpi="nice make -j$(grep -c '^processor' /proc/cpuinfo) install"
  alias mpck="nice make -k -j$(grep -c '^processor' /proc/cpuinfo) check"
fi
alias md='mkdir -p'
alias v=vim vd='vimdiff +":set hls" -c "set wrap" -c "wincmd w" -c "set wrap"' v-='vim -' sv='sudo vim' va='vimall' vo='vim -o' vO='vim -O' vf='vimfind' vg='vimgrep'
alias f=find
alias g=goodgrep gr='goodgrep -r' gh=grephere
alias l='ls -CF' ll='ls -lh' la='ls -A' l1='ls -1'
alias fgfg=fg fg1='fg 1' fg2='fg 2' fg3='fg 3' fg4='fg 4'
alias bg1='bg 1' bg2='bg 2' bg3='bg 3' bg4='bg 4'
alias ww=which
alias cd..='cd ..' ..='cd ..' ...='cd ../..' ....='cd ../../..' .....='cd ../../../..'

if test "$(uname -o)" = Cygwin; then
  alias o=cygstart

  pwdclip() {
    pwd | tr -d '\r\n' | clip
  }

  # Copy Bash/readline yanked buffer to Windows clipboard
  rl2clip() {
    local S
    S=$(mktemp --suffix=.vbs)
    trap "rm -f $S" EXIT
    echo "set shell = CreateObject(\"WScript.Shell\"): shell.SendKeys \"echo ^y | tr -d '\r\n' | clip{ENTER}\"" > $S
    cscript //B $(cygpath -w $S)
  }

  pwdw() {
    cygpath -w $PWD
  }
  whichw() {
    cygpath -w $(which "$1")
  }
  pwdwclip() {
    pwdw | tr -d '\r\n' | clip
  }

  # Remove Cygwin's stuff from PATH (useful for running bat files in canonical environment)
  cygtrimpath() {
    local OLD_IFS
    local NEWPATH

    OLD_IFS=$IFS
    IFS=:

    NEWPATH=
    for d in $PATH; do
      if echo $d | grep -qv '^/\(usr\|bin\)'; then
        NEWPATH="${NEWPATH:+$NEWPATH:}$d"
      fi
    done

    PATH="$NEWPATH"
  }
else
  alias o=xdg-open

  pwdclip() {
    pwd | tr -d '\r\n' | xclip -selection clipboard
  }
fi

# TODO: forward Git autocompletions
alias gtco='git checkout'
alias gtcob='git checkout -b'
alias gtc='git commit'
alias gtca='git commit --amend'
alias gtst='git status'
alias gtsh='git show'
alias gtb='git branch'
alias gtba='git branch -a'
alias gtbd='git branch -D'
alias gtl='git log'
for N in $(seq 1 20); do alias "gtl$N=git log -n$N"; done
alias gtlg='git log --graph'
alias gta='git add'
alias gtrm='git rm'
alias gtd='git diff'
alias gtdc='git diff --cached'
alias gtr='git reset'
alias gtrh='git reset --hard'
alias gtrb='git rebase'
alias gtrbc='git rebase --continue'
alias gtrba='git rebase --abort'
alias gtrbi='git rebase -i'
alias gtcp='git cherry-pick'
alias gtcpc='git cherry-pick --continue'
alias gtcpa='git cherry-pick --abort'
alias gtpl='git pull'
alias gtan='git annotate'
alias gtcl='git clone'
alias gtsb='git show-branch'
alias gtft='git fetch'
alias gtm='git merge'

# Enable Git completions for aliases
if [ -f "/usr/share/bash-completion/completions/git" ]; then
  . /usr/share/bash-completion/completions/git
  for a in $(alias | sed -n 's/^alias \(gt[^=]*\)=.git .*/\1/p'); do
    c=$(alias $a | sed 's/^[^=]*=.git \([a-z0-9\-]\+\).*/\1/' | tr '-' '_')
    if set | grep -q "^_git_$c *()"; then
      eval "__git_complete $a _git_$c"
    fi
  done
fi

gtp() {
  local B=$(git branch | awk '/^\*/{print $2}')
  git push -u "$@" "$B"
}

gtpo() {
  gtp "$@" origin
}

alias c=gcc c+=g++

# Wrappers for https://www.ostechnix.com/use-google-translate-commandline-linux/
alias trans-ru='trans -s Russian -t English' trans-en='trans -s English -t Russian'

export VISUAL='vim -f'

export PATH=$HOME/bin${PATH:+:$PATH}

shopt -s autocd
shopt -s dirspell
shopt -s cdspell
