# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export VISUAL=nvim
export EDITOR="$VISUAL"
export BROWSER="google-chrome-stable"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SAVEHIST=9223372036854775807
export HISTSIZE=9223372036854775807
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export SDL_AUDIODRIVER="pulse"
export FZF_ALT_C_COMMAND='fd -t d --hidden'
export FZF_ALT_C_OPTS='--preview '\''tree -C {} | head -200'\'
export FZF_CTRL_T_COMMAND='fd --hidden'
export FZF_CTRL_T_OPTS='--preview '\''(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'\'

[ -d /usr/local/bin/custom ] && PATH="$PATH:/usr/local/bin/custom"
[ -d /usr/local/bin/custom/custom ] && PATH="$PATH:/usr/local/bin/custom/custom"

if [[ -z "$DISPLAY" ]]; then
  if [[ "$XDG_VTNR" -eq 1 ]]; then
    exec startx
  elif [[ "$XDG_VTNR" -eq 2 ]]; then
    exec sway --my-next-gpu-wont-be-nvidia
  fi
fi

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z-_}={A-Za-z_-}'

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source /usr/share/zsh/share/antigen.zsh
plugins=(git git-auto-fetch gitfast common-aliases docker-compose docker fancy-ctrl-z fd fzf gpg-agent helm httpie kubectl mvn gradle gradle-completion ripgrep sudo per-directory-history)

antigen use oh-my-zsh
for plugin in $plugins; do
  antigen bundle $plugin
done
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen theme romkatv/powerlevel10k
antigen apply

#for plugin in /usr/share/zsh/plugins/*/*.plugin.zsh; do
#  source "$plugin"
#done

autoload -U compinit && compinit -d $HOME/.cache/zsh/zcompdump-$ZSH_VERSION

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.config/p10k.zsh ]] && source ~/.config/p10k.zsh
[[ -f /opt/azure-cli/az.completion ]] && source /opt/azure-cli/az.completion
[[ -f /usr/share/LS_COLORS/dircolors.sh ]] && source /usr/share/LS_COLORS/dircolors.sh

setopt INC_APPEND_HISTORY
unsetopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
unsetopt share_history

function command_not_found_handler() {
  echo "Command '$1' not found, but could be installed via the following packages:"
  echo "Packages containing '$1' in name"
  /bin/yay -Sl | rg -- $1
  echo "Packages containg files with '$1' in their name"
  /bin/yay -Fyq -- $1
}

function e.() {
  xdg-open . > /dev/null
}

function e() {
  xdg-open "$*" > /dev/null
}

function ssh() {
  if $(grep "$1" ~/.ssh/checked_hosts -q )
  then
    name="$1"
    shift
    scp -q ~/.bashrc ${name}:/tmp/cwr.bashrc > /dev/null

    if [[ "${#@}" > 0 ]]
    then
      /usr/bin/ssh -q $name "$@"
    else
      /usr/bin/ssh $name -t "sh -c 'if which bash &> /dev/null; then bash --rcfile /tmp/cwr.bashrc -i; else if which ash &> /dev/null; then ash; else sh; fi; fi'"
    fi
    return $?
  else
    ssh-copy-id $1
    ret=$?
    if [ $ret -eq 0 ]
    then
      echo "$1" >> ~/.ssh/checked_hosts
      ssh "$@"
      return $?
    fi
    return $ret
  fi
}

for intellijTool in /usr/local/bin/custom/custom/*; do
  local func=$(cat - <<EOF
  function $(basename $intellijTool)() {
    i3-msg "exec $intellijTool \$(realpath \${1:-.})"
  }
EOF
)
  eval "$func"
  unset func
done
unset intellijTool

for jdk in $(archlinux-java status | tail -n +2 | awk '{print $1}' | cut -c 6- | rev | cut -c 9- | rev); do
  eval "alias java$jdk=/usr/lib/jvm/java-$jdk-openjdk/bin/java"
done

function diff() {
  /bin/diff -u "${@}" | diff-so-fancy | /bin/less --tabs=1,5 -RF
}

function swap() {
  tmpfile=$(mktemp -u $(dirname "$1")/XXXXXX)
  mv "$1" "$tmpfile" -f && mv "$2" "$1" &&  mv "$tmpfile" "$2"
}

function bak() {
  cp -r "${1%/}" "${1%/}~"
}

function bsrv() {
    index="$1"
    shift
    ssh root@buildsrv${index}.4allportal.net $*
}

function 4ap() {
    name="$1"
    shift
    ssh root@${name}.4allportal.net $*
}

function appVs() {
  ssh root@repository.4allportal.net ls /services/repository/apps/$1 -v
}

function appV() {
  echo "$1:$(ssh root@repository.4allportal.net ls /services/repository/apps/$1 -v | tail -1)"
}

function getRepoVersion() {
    4ap repository find /services/repository/apps/4allportal-$1 -mindepth 1 -maxdepth 1 | sed -r 's#^.*/([^/]+)$#\1#g' | sort
}

function ss() {
  local result
  result="$(wiki-search "$@" | fzf | awk '{print $NF}')"
  if [ "$?" -eq "0" ]; then
    wiki-search $result
  fi
}

function google() {
  local IFS=+
  xdg-open "http://google.com/search?q=${*}"
}

function grim() {
  local choice
  choice="$(rg $* | fzf | cut -d ':' -f 1)"
  [ "$?" = 0 ] && vim "$choice"
}

function fim() {
  local choice
  choice="$(fd $* | fzf)"
  [ "$?" = 0 ] && vim "$choice"
}

function hr() {
  local HR="$1"
  local ns
  local rn
  [ -f "$HR" -a -r "$HR" ] || return
  ns=$(yq -e .spec.targetNamespace $HR || yq -e .metadata.namespace $HR)
  rn=$(yq -e .spec.releaseName $HR || yq -e .metadata.name $HR)
  helm template --namespace $ns --repo $(yq -e .spec.chart.repository $HR) $rn $(yq -e .spec.chart.name $HR) --version $(yq -e .spec.chart.version $HR) --values <(yq -e -y .spec.values $HR)
}

function hrDiff() {
  local HR="$1"
  [ -f "$HR" -a -r "$HR" ] || return
  hr "$HR" | kubectl -n $(yq .spec.targetNamespace $HR) diff -f - | diff-so-fancy | /bin/less --tabs=1,5 -RFS
}

function pkgSync() {
  local packages
  eval $(sed -n '/#startPackages/,/#endPackages/p;/#endPackages/q' $HOME/projects/linux-config/install-arch-base.sh | rg -v '#')
  for package in $(yay -Qet | cut -f 1 -d ' ' | rg -v $(echo $packages | tr ' ' '|') | rg $(yay -Qqt | tr '\n' '|' | sed -r 's#\|$##g') | tr '\n' ' '); do
    yay -Qi $package
    if read -q "?remove $package? "; then
      yay -R --noconfirm $package
    else
      packages="$packages $package"
    fi
    echo
  done
  newPackages=$((
    echo '  #startPackages'
    echo '  packages=('
    (
      next=
      cur=
      for package in $(echo $packages | tr ' ' '\n' | sort); do
        next=$(( $(echo $cur | wc -c) + $(echo $package | wc -c) ))
        if [ $next -gt 110 ]; then
          echo $cur
          cur="$package "
          next=0
        else
          cur="$cur$package "
        fi
      done
      echo $cur
    ) | sed 's#^#    #g'
    echo '  )'
    echo '  #endPackages'
  ) | sed -r 's#$#\\n#g' | tr -d '\n')
  sed -i -e "/#endPackages/a \\${newPackages}" -e '/#startPackages/,/#endPackages/d' -e 's#NewPackages#Packages#g' projects/linux-config/install-arch-base.sh
}

function clip() {
  xclip -selection clipboard
}

#function release4App() {
#  local version="$1"
#  local newVersion="$2"
#
#  for package in package.json cmweb-*/package.json; do
#    cat $package | jq ".version = \"$version\"" | sponge $package
#  done
#
#  mvn versions:set -DgenerateBackupPoms=false -DnewVersion=$version
#
#  git commit . -m 'Version Bump'
#  git tag $version $(git rev-parse HEAD)
#
#  git reset --hard HEAD~1
#
#
#  for package in package.json cmweb-*/package.json; do
#    cat $package | jq ".version = \"$newVersion\"" | sponge $package
#  done
#
#}

function reAlias() {
  nAlias $1 $1 ${@:2}
}

function nAlias() {
  if command -v $2 &> /dev/null; then
    local param="${@:2}"
    alias "$1=${param}"
#    if [ -r /etc/bash_completion ] ||
#       [ -r /etc/profile.d/bash_completion.sh ] ||
#       [ -r /usr/share/bash-completion/bash_completion ]; then
#      complete -F _complete_alias $1
#    fi
  fi
}

unalias fd
nAlias :q exit
nAlias :e nvim
nAlias :r source $HOME/.zshrc
reAlias env ' | sort'
reAlias rm -i
reAlias cp -i
reAlias mv -i
reAlias ls -phAvbl --color=always --time-style=long-iso
reAlias nvim -b
if [[ "$(id -u)" != 0 ]] && command -v sudo &> /dev/null; then
  for cmd in systemctl pacman ignite ip; do
    nAlias $cmd sudo $cmd
  done
fi
nAlias top htop
nAlias vim nvim
nAlias vi vim
nAlias cat bat -p
nAlias less slit
nAlias ps procs
reAlias fzf --ansi
reAlias prettyping --nolegend
nAlias ping prettyping
nAlias du ncdu
reAlias rg -S
reAlias jq -r
reAlias yq -r
nAlias k kubectl
command -v powerpill &> /dev/null && reAlias yay --pacman=powerpill
nAlias docker-run docker run --rm -it
nAlias htop gotop
reAlias gotop -r 4
reAlias feh --scale-down --auto-zoom --auto-rotate
nAlias grep rg
nAlias o xdg-open
nAlias makepkg docker-run --network host -v '$PWD:/pkg whynothugo/makepkg' makepkg

alias kubectl="PATH=\"$PATH:$HOME/.krew/bin\" kubectl"

nAlias krc kubectl config current-context
nAlias klc kubectl 'config get-contexts -o name | sed "s/^/  /;\|^  $(krc)$|s/ /*/"'
nAlias kcc kubectl 'config use-context "$(klc | fzf -e | sed "s/^..//")"'
nAlias krn kubectl 'config get-contexts --no-headers "$(krc)" | awk "{print \$5}" | sed "s/^$/default/"'
nAlias kln kubectl 'get -o name ns | sed "s|^.*/|  |;\|$(krn)|s/ /*/"'
nAlias kcn kubectl 'config set-context --current --namespace "$(kln | fzf -e | sed "s/^..//")"'


autoload -U +X bashcompinit && bashcompinit
