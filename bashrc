# Persistent history stuff borrowed from Eli Benderski
# (http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash)

log_bash_persistent_history()
{
  local date_part=`history 1 | awk '{ print $1 }'`
  local command_part=`history 1 | awk '{ $1=""; print $0 }'`
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]; then
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

export PROMPT_COMMAND="run_on_prompt_command"

goodgrep() {
	grep --exclude=tags --exclude=cscope\* --exclude-dir .svn --exclude-dir .git "$@"
}

grephere() {
	goodgrep -R "$@" .
}

vimall() {
	vim $(find -name "$1")
}

cdmd() {
	if mkdir -p "$1"; then
		cd "$1"
	fi
}

yell() {
  local msg="Bash (pid $$)"
  if test -n "$1"; then
    msg="${msg} says: $1"
  fi
  case $(uname -o) in
  Cygwin)
    rundll32 user32.dll,MessageBeep
    msg \* "$msg"
    ;;
  *)
    echo >&2 "Don't know how to notify on $(uname -o)"
    ;;
  esac
}

# "fn $D $P ..." -> "find $D -name $P ..."
fn() {
  if test $# -lt 2; then
    echo >&2 "Usage: fn DIR PATTERN"
    return 1
  fi

  case "$2" in
  -*)
    find "$@"
    ;;
  *)
    local D="$1"
    shift
    find "$D" -name "$@"
    ;;
  esac
}

export VISUAL='vim -f'

alias m='nice make' mi='make install' mp='nice make -j10' mpi='nice make -j10 install' mck='nice make -k check' mpck='nice make -k -j10 check'
alias mkdircd=cdmd
alias v=vim vd=vimdiff v-='vim -' sv='sudo vim' va='vimall' vo='vim -o' vO='vim -O'
alias f=find
alias g=goodgrep gr='goodgrep -r' gh=grephere
alias l='ls -CF' ll='ls -lh' la='ls -A'
alias fgfg=fg fg1='fg 1' fg2='fg 2' fg3='fg 3' fg4='fg 4'
alias bg1='bg 1' bg2='bg 2' bg3='bg 3' bg4='bg 4'
alias ww=which

# TODO: forward Git autocompletions
alias gtco='git checkout'
alias gtcob='git checkout -b'
alias gtc='git commit'
alias gtca='git commit --amend'
alias gtst='git status'
alias gtsh='git show'
alias gtb='git branch'
alias gtba='git branch -a'
alias gtl='git log'
alias gtlg='git log --graph'
alias gta='git add'
alias gtrm='git rm'
alias gtd='git diff'
alias gtdc='git diff --cached'
alias gtr='git reset'
alias gtrh='git reset --hard'
alias gtrb='git rebase'
alias gtcp='git cherry-pick'
alias gtpl='git pull'
alias gtan='git annotate'
alias gtcl='git clone'

alias c=gcc c+=g++

export PATH=$HOME/bin${PATH:+:$PATH}
