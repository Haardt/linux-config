#!/bin/bash

set -x -o pipefail

tmp=/tmp/i3status

mkdir -p ${tmp}

source <(
  cat ~/.config/i3status/config | grep color_ | while read line
  do
    key=$(echo ${line} | sed -r 's#^([^ ]+) = .+$#\1#g')
    value=$(echo ${line} | sed -r 's#^.+"([^ ]+)"$#\1#g')
    echo "export $key=$value"
  done
)

declare -A lastExecute
declare -A notifications

(
  i3status | (
    read line && echo "${line/\}/,\"click_events\":true\}}" && read line && echo "$line" && read line && echo "$line" &&
    while read line
    do
      line="${line#[}"
      line="${line#,[}"
      i3Out=",["

      for s in $HOME/.config/i3status/custom.d/*/*.sh
      do
        if ! (echo ${s} | grep "_click" &>/dev/null)
        then
          name=$(basename -- "$s" .sh | sed -r 's#_[0-9]+$##g')
          interval=$(echo $(basename -- "$s" .sh) | sed -rn 's#^.+_([0-9]+)$#\1#gp')
          currTmp=${tmp}/${name}
          mkdir -p ${currTmp}
          last=${lastExecute[$name]:-0}

          if [[ $(($(date +%s) - $last)) -ge ${interval:-0} ]]
          then
            (
              mkdir ${currTmp}/lock &>/dev/null || exit

              start=$(date +%s%N)
              out=$(tmp=${currTmp} ${s} 2>${currTmp}/stderr.tmp)
              exitCode=$?
              end=$(date +%s%N)

              if [[ "$exitCode" = "0" ]]
              then
                echo "$out" >${currTmp}/out
                time=$((($end - $start) / 1000000))
                ln -sf ${time} ${currTmp}/time
                mv ${currTmp}/stderr.tmp ${currTmp}/stderr
              fi

              rmdir ${currTmp}/lock &>/dev/null
            ) &

            lastExecute[$name]=$(date +%s)
          fi

          [[ -f ${currTmp}/out ]] || continue

          out=$(cat ${currTmp}/out)
          [[ -z "$out" ]] && continue

          text="$(echo "$out" | sed '1q;d')"
          color="$(echo "$out" | sed '2q;d')"
          notification="$(echo "$out" | sed '3q;d')"
          notificationOptions="$(echo "$out" | sed '4q;d')"

          if [[ ! ${notification} = "${notifications[$name]}" ]]
          then
            [[ ! -z ${notification} ]] && notify-send "i3status: $name" ${notificationOptions} "${notification}"
            notifications[$name]=${notification}
          fi

          i3Out="${i3Out}{\"name\":\"$name\",\"full_text\":\"$text\",\"color\":\"$color\"},"
        fi
      done

      i3Out="${i3Out}${line}"

      echo "$i3Out" | sed -r 's#\[,#\[#g; s#,,#,#g; s#},\[#},#g; s#\[,#\[#g; s#\[\[#\[#g; s#,,#,#g'
    done
  )
) &

while read line; do
  name=$(echo ${line} | sed -r 's#^,##g' | jq -r .name)
  button=$(echo ${line} | sed -r 's#^,##g' | jq -r .button)

  clickScript="$HOME/.config/i3status/custom.d/${name}_click_${button}.sh"
  if [[ -x ${clickScript} ]]
then
      ${clickScript} &
  else
    echo ${line} >&2
  fi
done

wait
