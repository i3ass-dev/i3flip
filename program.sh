#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
i3flip - version: 0.062
updated: 2020-07-30 by budRich
EOB
}



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

___printhelp(){
  
cat << 'EOB' >&2
i3flip - Tabswitching done right


SYNOPSIS
--------
i3flip [--move|-m] DIRECTION [--json JSON] [--verbose] [--dryrun]
i3flip --help|-h
i3flip --version|-v

OPTIONS
-------

--move|-m DIRECTION  
Move the current tab instead of changing focus.

--json JSON  

--verbose  

--dryrun  

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.

EOB
}


set -E
trap '[ "$?" -ne 98 ] || exit 98' ERR

ERX() { >&2 echo  "[ERROR] $*" ; exit 98 ;}
ERR() { >&2 echo  "[WARNING] $*"  ;}
ERM() { >&2 echo  "$*"  ;}
ERH(){
  ___printhelp >&2
  [[ -n "$*" ]] && printf '\n%s\n' "$*" >&2
  exit 98
}

messy() {

  # arguments are valid i3-msg arguments
  # separate resize commands and execute
  # all commands at once in cleanup()
  (( __o[verbose] )) && ERM "m $*"
  (( __o[dryrun]  )) || _msgstring+="$*;"
}


declare -A __o
options="$(
  getopt --name "[ERROR]:i3flip" \
    --options "m:hv" \
    --longoptions "move:,json:,verbose,dryrun,help,version," \
    -- "$@" || exit 98
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --move       | -m ) __o[move]="${2:-}" ; shift ;;
    --json       ) __o[json]="${2:-}" ; shift ;;
    --verbose    ) __o[verbose]=1 ;; 
    --dryrun     ) __o[dryrun]=1 ;; 
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 


main "${@}"


