#!/usr/bin/env bash

main(){

  declare -g _msgstring

  _dir=$1
  ((__o[verbose])) && ERM "target dir: $_dir"
  _dir=${_dir,,}

  eval "$(i3viswiz -p ${__o[json]:+--json "${__o[json]}"} | head -1)"
  # unset unneeded variabels from viswiz
  unset trgcon trgx trgy wall trgpar sx sy sw sh groupid

  # by creating the wiz string, shellcheck will
  # not complain about un-assigned variables 
  wiz+="layout:${grouplayout:=} last:${lastingroup:=} "
  wiz+="first:${firstingroup:=} "
  wiz+="pos:${grouppos:=} size:${groupsize:=0} "

  ((__o[verbose])) && ERM "w $wiz"

  ((groupsize < 2)) \
    && ERX only container in group

  case "${_dir:0:1}" in

    r|d|n ) 
      next=1 prev=0
      [[ "$grouplayout" =~ tabbed|splith ]] \
        && ldir=right || ldir=down
    ;;

    l|u|p )
      prev=1 next=0
      [[ "$grouplayout" =~ tabbed|splith ]] \
        && ldir=left || ldir=up
    ;;

    *     ) ERX "$1 is not a valid direction" ;;
  esac

  # focus/move normally
  if (( (grouppos  > 1 && grouppos < groupsize)       
   || ( (grouppos == 1 && next)
   ||   (grouppos == groupsize && prev) ) )); then
   
   ((__o[move])) && cmd=move || cmd=focus
   messy "$cmd  $ldir"
  
  # warp focus/move to end of group
  elif ((grouppos == 1)); then
    if ((__o[move])); then
      messy "[con_id=$lastingroup] mark --add --toggle fliptmp"
      messy "move to mark fliptmp"
      messy "[con_id=$lastingroup] mark --add --toggle fliptmp"
    else
      messy "[con_id=$lastingroup] focus"
    fi

  # warp focus/move to start of group, (move+swap)
  else
    if ((__o[move])); then
      messy "[con_id=$firstingroup] mark --add --toggle fliptmp"
      messy "move to mark fliptmp, swap container with mark fliptmp"
      messy "[con_id=$firstingroup] mark --add --toggle fliptmp"
    else
      messy "[con_id=$firstingroup] focus"
    fi
  fi

  ((__o[verbose])) || qflag='-q'
  [[ -n $_msgstring ]] && i3-msg "${qflag:-}" "$_msgstring"
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
