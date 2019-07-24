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
	vim $(find ${2:-.} -name "$1")
}

vimgrep() {
	vim $(grep -r -l -i "$1" ${2:-.}) +':set ic hls' +1 +/"$1"
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

# "fromto M N" - print lines in [M, N] (inclusive) interval
# "fromto M +N" - print N lines following M (inclusive)
fromto() {
  local span
  case "$2" in
  +*)
    span=$(echo "$2" | sed 's/^.//')
    ;;
  *)
    if test "$2" -ge "$1"; then
      span=$(($2 - $1 + 1))
    else
      span=0
    fi
    ;;
  esac
  tail -n +"$1" | head -n $span
}

# Nested kill
killl() {
  local status sig pid

  if test $# -ne 1 -a $# -ne 2; then
    echo >&2 "Usage: killl [-SIG] PID"
    return 1
  elif test $# = 2; then
    sig=$1
    pid=$2
  else
    pid=$1
    sig=-TERM
  fi

  status=0

  # Stop parent so that it does not respawn children
  kill -SIGSTOP $pid || status=1

  for kid in $(ps -o pid --no-headers --ppid $pid); do
    killl $sig $kid || status=1
  done

  # Need to continue stopped process so that system can kill it
  kill $sig $pid && kill -SIGCONT $pid || status=1

  return $status
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

export VISUAL='vim -f'

alias m='nice make' mi='nice make install' mck='nice make -k check' mp="nice make -j$(grep -c '^processor' /proc/cpuinfo)" mpi="nice make -j$(grep -c '^processor' /proc/cpuinfo) install" mpck="nice make -k -j$(grep -c '^processor' /proc/cpuinfo) check"
alias md='mkdir -p'
alias v=vim vd='vimdiff +":set hls" -c "set wrap" -c "wincmd w" -c "set wrap"' v-='vim -' sv='sudo vim' va='vimall' vo='vim -o' vO='vim -O'
alias f=find
alias g=goodgrep gr='goodgrep -r' gh=grephere
alias l='ls -CF' ll='ls -lh' la='ls -A' l1='ls -1'
alias fgfg=fg fg1='fg 1' fg2='fg 2' fg3='fg 3' fg4='fg 4'
alias bg1='bg 1' bg2='bg 2' bg3='bg 3' bg4='bg 4'
alias ww=which
alias cd..='cd ..' ..='cd ..' ...='cd ../..' ....='cd ../../..' .....='cd ../../../..'

if test "$(uname -o)" = Cygwin; then
  alias o=cygstart

  pwdw() {
    cygpath -w $PWD
  }
  whichw() {
    cygpath -w $(which "$1")
  }
  pwdwclip() {
    pwdw | tr -d '\r\n' | clip
  }

  # TODO: add Linux analog
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

gtpo() {
  local B=$(git branch | awk '/^\*/{print $2}')
  git push "$@" origin "$B"
}

alias c=gcc c+=g++

# Wrappers for https://www.ostechnix.com/use-google-translate-commandline-linux/
alias trans-ru='trans -s Russian -t English' trans-en='trans -s English -t Russian'

export PATH=$HOME/bin${PATH:+:$PATH}

shopt -s autocd
shopt -s dirspell
shopt -s cdspell
