#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
i3flip - version: 0.093
updated: 2020-07-30 by budRich
EOB
}




___printhelp(){
  
cat << 'EOB' >&2
i3flip - Tabswitching done right


SYNOPSIS
--------
i3flip [--move|-m] [--json JSON] [--verbose] [--dryrun] DIRECTION
i3flip --help|-h
i3flip --version|-v

OPTIONS
-------

--move|-m  
Move the current container instead of changing
focus.


--json JSON  
use JSON instead of output from  i3-msg -t
get_tree


--verbose  
Print more information to stderr.


--dryrun  
Don't execute any i3 commands.

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.

EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

declare -A __o
options="$(
  getopt --name "[ERROR]:i3flip" \
    --options "mhv" \
    --longoptions "move,json:,verbose,dryrun,help,version," \
    -- "$@" || exit 98
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --move       | -m ) __o[move]=1 ;; 
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




