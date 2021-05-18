#!/bin/bash

main(){

  [[ -f /tmp/i3flip_lock ]] && exit
  touch /tmp/i3flip_lock
  trap 'rm /tmp/i3flip_lock' EXIT HUP INT

  declare -g _msgstring
  declare -i next prev

  _dir=$1
  ((__o[verbose])) && ERM $'\n'"target direction: $_dir"
  _dir=${_dir,,}

  read -r layout last first pos size < <(
    i3viswiz --parent ${__o[json]:+--json "${__o[json]}"} \
             --debug grouplayout,lastingroup,firstingroup,grouppos,groupsize \
             --debug-format "%v "
    )            
  
  ((__o[verbose])) && ERM "w" "layout:$layout" "last:$last" \
                              "first:$first" "pos:$pos" "size:$size"

  ((size < 2)) && ERX only container in group

  case "${_dir:0:1}" in

    r|d|n ) 
      next=1 prev=0
      [[ $layout =~ tabbed|splith ]] \
        && ldir=right || ldir=down
    ;;

    l|u|p )
      prev=1 next=0
      [[ $layout =~ tabbed|splith ]] \
        && ldir=left || ldir=up
    ;;

    *     ) ERX "$1 is not a valid direction" ;;
  esac

  # focus/move normally
  if (( (pos  > 1 && pos < size)       
   || ( (pos == 1 && next)
   ||   (pos == size && prev) ) )); then
   
   ((__o[move])) && cmd=move || cmd=focus
   messy "$cmd  $ldir"
  
  # warp focus/move to end of group
  elif ((pos == 1)); then
    if ((__o[move])); then
      messy "[con_id=$last] mark --add --toggle fliptmp"
      messy "move to mark fliptmp"
      messy "[con_id=$last] mark --add --toggle fliptmp"
    else
      messy "[con_id=$last] focus"
    fi

  # warp focus/move to start of group, (move+swap)
  else
    if ((__o[move])); then
      messy "[con_id=$first] mark --add --toggle fliptmp"
      messy "move to mark fliptmp, swap container with mark fliptmp"
      messy "[con_id=$first] mark --add --toggle fliptmp"
    else
      messy "[con_id=$first] focus"
    fi
  fi

  ((__o[verbose])) || qflag='-q'
  [[ -n $_msgstring ]] && i3-msg "${qflag:-}" "$_msgstring"
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
