#!/usr/bin/env bash

main(){

  declare -g _msgstring

  _dir=${1,,}

  # example output from viswiz:
  # ... groupsize=4 grouppos=4 firstingroup=222 lastingroup=333
  eval "$(i3viswiz -p | head -1)"
  # unset unneeded varialbs from viswiz
  unset trgcon trgx trgy wall trgpar sx sy sw sh

  : "${grouppos:=}"  "${lastingroup:=}"
  : "${groupsize:=}" "${firstingroup:=}"
  : "${groupid:=}"   "${grouplayout:=}"

  ((groupsize == 1)) \
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
   
   ((__o[move]))                  \
     && messy "move $ldir"         \
     || messy "focus $ldir"
  
  # focus/move after lastingroup
  elif ((grouppos == 1)); then
    if ((__o[move])); then
      messy "[con_id=$lastingroup] mark --add --toggle fliptmp"
      messy "move to mark fliptmp"
      messy "[con_id=$lastingroup] mark --add --toggle fliptmp"
    else
      messy "[con_id=$lastingroup] focus"
    fi

  # focus/move before firstingroup, (move+swap)
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
