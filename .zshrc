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
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_COMMAND='fd --hidden'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export GRADLE_OPTS=-Xmx1G
export GRADLE_COMPLETION_UNQUALIFIED_TASKS="true"
export GRADLE_USER_HOME=/tmp/gradle

[ -d /usr/local/bin/custom ] && PATH="$PATH:/usr/local/bin/custom"
[ -d /usr/local/bin/custom/custom ] && PATH="$PATH:/usr/local/bin/custom/custom"

if [[ -z "$DISPLAY" ]]; then
  if [[ "$XDG_VTNR" -eq 1 ]]; then
   startx
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
HYPHEN_INSENSITIVE="true"

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
COMPLETION_WAITING_DOTS="true"

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

zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
ZSH_CUSTOM=/usr/share/zsh
ZSH_THEME="../../zsh-theme-powerlevel10k/powerlevel10k"

plugins=(
  git
  git-auto-fetch
  gitfast
  common-aliases
  docker-compose
  docker
  fancy-ctrl-z
  fd
  fzf
  gpg-agent
  helm
  httpie
  kubectl
  mvn
  gradle
  ripgrep
  sudo
  per-directory-history
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

source /usr/share/zsh/site-functions/_gradle &> /dev/null
source /usr/share/zsh/plugins/gradle-zsh-completion/gradle-completion.plugin.zsh
source /usr/share/git/completion/git-completion.zsh &> /dev/null

autoload -U compinit && compinit -d $HOME/.cache/zsh/zcompdump-$ZSH_VERSION

compdef _gradle gradle-or-gradlew

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.config/p10k.zsh ]] && source ~/.config/p10k.zsh
[[ -f /opt/azure-cli/az.completion ]] && source /opt/azure-cli/az.completion
[[ -f /usr/share/LS_COLORS/dircolors.sh ]] && source /usr/share/LS_COLORS/dircolors.sh

setopt INC_APPEND_HISTORY
unsetopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
unsetopt share_history

function command_not_found_handler() {
  echo "Command '$1' not found, but could be installed via the following package(s):"
  yay -S --provides -- $1
  [ $? -eq 0 ] && return
  echo "Packages containing '$1' in name"
  yay -Slq | rg -- $1
  echo "Packages containg files with '$1' in their name"
  yay -Fyq -- $1
}

function _nop() {}

function e.() {
  xdg-open . > /dev/null
}
compdef _nop e.

function e() {
  xdg-open "$*" > /dev/null
}

function ssh() {
  if ! ping -c 1 "${1/*@/}" &> /dev/null; then
    /bin/ssh "$@"
    return $?
  elif $(grep "$1" ~/.ssh/checked_hosts -q )
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
function _bsrv() {
  _arguments "1: :(1 2 4)"
}
compdef _bsrv bsrv

function 4ap() {
    name="$1"
    shift
    ssh root@${name}.4allportal.net $*
}
function _4ap() {
  _arguments "1: :($(cat $HOME/.ssh/known_hosts | awk '{print $1}' | tr ',' '\n' | rg '.4allportal\.net' | sed -r 's#.4allportal.net##g' | sort | uniq | xargs echo -n))"
}
compdef _4ap 4ap

function fap() {
  mkdir -p /tmp/data
  docker pull registry.4allportal.net/4allportal:$1
  docker run --rm -it -e DATABASE_HOST=localhost -v /tmp/data:/4allportal/data --net host \
    --tmpfs=/4allportal/{_runtime,assets} ${@:2} \
    registry.4allportal.net/4allportal:$1
}

function appVs() {
  ssh root@repository.4allportal.net ls /services/repository/apps/$1 -v | sort -V | sed "s#^#$1:#g"
}
function _appVs() {
  _arguments "1: :($(ssh root@repository.4allportal.net ls /services/repository/apps/ | sort | uniq | xargs echo -n))"
}
compdef _appVs appVs

function appV() {
  echo "$1:$(ssh root@repository.4allportal.net ls /services/repository/apps/$1 -v | sort -V | tail -1)"
}
compdef _appVs appV

function helmUpdates() {
  kubectl get helmreleases -A -o json | jq -r '.items[] | select(.spec.chart.version != null) | "\(.metadata.namespace) \(.metadata.name) \(.spec.chart.repository) \(.spec.chart.name) \(.spec.chart.version)"' | while read ns name repo chart version; do
    cat <<EOF > /tmp/repo.yaml
apiVersion: ""
generated: "0001-01-01T00:00:00Z"
repositories:
  - name: repo
    url: "$repo"
EOF

    helm --repository-config /tmp/repo.yaml repo update &> /dev/null
    latestVersion=$(helm --repository-config /tmp/repo.yaml --output json search repo $chart | jq -r ".[] | select(.name == \"repo/$chart\") | .version")
    if [ "$version" != "$latestVersion" ]; then
      echo update $ns/$name to version $latestVersion
    fi
  done
  rm -f /tmp/repo.yaml
}

function google() {
  local IFS=+
  xdg-open "http://google.com/search?q=${*}"
}

function hr() {
  local HR="$1"
  local ns
  local rn
  [ -f "$HR" -a -r "$HR" ] || return
  ns=$( (yq -e .spec.targetNamespace $HR || yq -e .metadata.namespace $HR) | rg -v null)
  rn=$( (yq -e .spec.releaseName $HR || yq -e .metadata.name $HR) | rg -v null)
  helm template --namespace $ns --repo $(yq -e .spec.chart.repository $HR) $rn $(yq -e .spec.chart.name $HR) --version $(yq -e .spec.chart.version $HR) --values <(yq -e -y .spec.values $HR)
}
function _hr() {
  local -a yaml_files
  yaml_files=( **/*.{yaml,yml}  )
  _arguments '1: :_files -g \*.\(yaml\|yml\)'
}
compdef _hr hr

function hrDiff() {
  local HR="$1"
  local ns
  local rn
  [ -f "$HR" -a -r "$HR" ] || return
  ns=$( (yq -e .spec.targetNamespace $HR || yq -e .metadata.namespace $HR) | rg -v null)
  rn=$( (yq -e .spec.releaseName $HR || yq -e .metadata.name $HR) | rg -v null)
    cat <<EOF > /tmp/repo.yaml
apiVersion: ""
generated: "0001-01-01T00:00:00Z"
repositories:
  - name: tmp
    url: "$(yq -r -e .spec.chart.repository $HR)"
EOF
  helm --repository-config /tmp/repo.yaml repo update
  helm --repository-config /tmp/repo.yaml diff upgrade --namespace $ns $rn tmp/$(yq -e .spec.chart.name $HR) --version $(yq -e .spec.chart.version $HR) --values <(yq -y .spec.values $HR)

  # helm diff upgrade --namespace $ns --repo $(yq -e .spec.chart.repository $HR) $rn $(yq -e .spec.chart.name $HR) --version $(yq -e .spec.chart.version $HR) --values <(yq -y .spec.values $HR)
}
compdef _hr hrDiff

function pkgSync() {
  local OLDPWD=$PWD
  cd $HOME
  git pull

  local package
  local packages
  eval $(sed -n '/#startPackages/,/#endPackages/p;/#endPackages/q' $HOME/install-arch-base.sh | rg -v '#')

  local targetPackages
  targetPackages=$(echo $packages | tr ' ' '\n')
  local originalPackages=$targetPackages

  local newPackages
  newPackages=$(yay -Qqe | rg -xv $(echo $targetPackages | tr '\n' '|' | sed 's#|$##g'))

  if [ ! -z $newPackages ]; then
    echo "$(wc -l <<<$newPackages) new Packages"
    while read -r package; do
      yay -Qi $package
      read -k 1 "choice?[A]dd, [r]emove, [d]epends or [s]kip $package? "
      echo
      case $choice in;
        [Aa])
          targetPackages="$targetPackages\\n$package"
          ;;
        [Rr])
          echo "=========="
          echo
          yay -R --noconfirm $package
          ;;
        [Dd])
          echo "=========="
          echo
          yay -D --asdeps $package
          ;;
        *)
          :
          ;;
      esac
      echo
      echo "=========="
      echo
    done <<<"$newPackages"
  else
    echo "No new Packages"
  fi

  local missingPackages
  missingPackages=$(echo $targetPackages | rg -xv $(yay -Qqe | tr '\n' '|' | sed 's#|$##g'))

  if [ ! -z $missingPackages ]; then
    echo "$(wc -l <<<$missingPackages) missing Packages"
    while read -r package; do
      yay -Si $package
      yay -Qi $package
      read -k 1 "choice?[I]nstall, [r]emove, [e]xplicit or [s]kip $package? "
      echo
      case $choice in;
        [Ii])
          echo "=========="
          echo
          yay -S --noconfirm $package
          ;;
        [Rr])
          targetPackages=$(echo $targetPackages | rg -xv "$package")
          ;;
        [Ee])
          echo "=========="
          echo
          yay -D --asexplicit $package
          ;;
        *)
          :
          ;;
      esac
      echo
      echo "=========="
      echo
    done <<<"$missingPackages"
  else
    echo "No missing Packages"
  fi

  local orphanedPackages
  orphanedPackages=$(pacman -Qqtd)

  if [ ! -z $orphanedPackages ]; then
    while [ ! -z $orphanedPackages ]; do
      echo "$(wc -l <<<$orphanedPackages) orphaned Packages"
      while read -r package; do
        yay -Qi $package
        read -k 1 "choice?[A]dd, [r]emove or [s]kip $package? "
        echo
        case $choice in;
          [Aa])
            targetPackages="$targetPackages\\n$package"
            ;;
          [Rr])
            echo "=========="
            echo
            yay -R --noconfirm $package
            ;;
          *)
            :
            ;;
        esac
        echo
        echo "=========="
        echo
      done <<<"$orphanedPackages"
      orphanedPackages=$(pacman -Qqtd)
    done
  else
    echo "No orphaned Packages"
  fi

  local unusedPackages
  unusedPackages=$(LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Required By/{req=$4} /^Optional For/{opt=$0} /^Install Reason/{res=$4$5} /^$/{if (req == "None" && res != "Explicitlyinstalled"){print name}}')

  if [ ! -z $unusedPackages ]; then
    echo "$(wc -l <<<$unusedPackages) unused Packages"
    if read -q "?Remove unused packages? "; then
      while [ ! -z $unusedPackages ]; do
        echo "$(wc -l <<<$unusedPackages) unused Packages"
        yay -R --noconfirm $(tr '\n' ' ' <<<$unusedPackages)
        echo
        unusedPackages=$(LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Required By/{req=$4} /^Optional For/{opt=$0} /^Install Reason/{res=$4$5} /^$/{if (req == "None" && res != "Explicitlyinstalled"){print name}}')
      done
    fi
  else
    echo "No unused Packages"
  fi

  newPackages=$( (
    echo '  #startPackages'
    echo '  packages=('
    echo $targetPackages | sort | uniq | sed 's#^#    #g'
    echo '  )'
    echo '  #endPackages'
  ) | sed -r 's#$#\\n#g' | tr -d '\n' | sed -r 's#\\n$##g')

  diff <(echo $originalPackages) <(echo $targetPackages)
  if ! /bin/diff <(echo $originalPackages) <(echo $targetPackages) &> /dev/null; then
    if read -q "?Commit? "; then
      sed -i -e "/#endPackages/a \\${newPackages}" -e '/#startPackages/,/#endPackages/d' -e 's#NewPackages#Packages#g' $HOME/install-arch-base.sh
      git commit -m pkgSync install-arch-base.sh
      git push
    fi
  else
    echo "No changes to be made"
  fi
  cd $OLDPWD
}
compdef _nop pkgSync

function clip() {
  xclip -selection clipboard
}
compdef _nop clip

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
nAlias :r exec zsh
reAlias env "-0 | sort -z | tr '\0' '\n'"
reAlias rm -i
reAlias cp -i
reAlias mv -i
reAlias ls -phAvbl --color=always --time-style=long-iso
reAlias nvim -b
if [[ "$(id -u)" != 0 ]] && command -v sudo &> /dev/null; then
  for cmd in systemctl pacman ip; do
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
nAlias docker-run docker run --rm -i -t
nAlias htop gotop
reAlias gotop -r 250ms
reAlias feh --scale-down --auto-zoom --auto-rotate
nAlias grep rg
nAlias o xdg-open
nAlias makepkg docker-run --network host -v '$PWD:/pkg whynothugo/makepkg' makepkg
reAlias watch ' '
nAlias scu /bin/systemctl --user
nAlias sc systemctl
alias urldecode='sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b"'
alias urlencode='jq -s -R -r @uri'

alias kubectl="PATH=\"$PATH:$HOME/.krew/bin\" kubectl"
alias k9s="PATH=\"$PATH:$HOME/.krew/bin\" k9s"
function _k9s() {
  _arguments "--context[The name of the kubeconfig context to use]: :($(kubectl config get-contexts -o name | xargs echo -n))"
}
compdef _k9s k9s

nAlias krc kubectl config current-context
nAlias klc kubectl 'config get-contexts -o name | sed "s/^/  /;\|^  $(krc)$|s/ /*/"'
nAlias kcc kubectl 'config use-context "$(klc | fzf -e | sed "s/^..//")"'
nAlias krn kubectl 'config get-contexts --no-headers "$(krc)" | awk "{print \$5}" | sed "s/^$/default/"'
nAlias kln kubectl 'get -o name ns | sed "s|^.*/|  |;\|^  $(krn)$|s/ /*/"'
nAlias kcn kubectl 'config set-context --current --namespace "$(kln | fzf -e | sed "s/^..//")"'
