#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
i3flip - version: 0.062
updated: 2020-07-30 by budRich
EOB
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


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

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




