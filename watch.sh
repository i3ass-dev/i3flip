#!/bin/bash

_source=$(readlink -f "${BASH_SOURCE[0]}")
_dir=${_source%/*}

loops=20
cmd1a+=("$_dir/program.sh" --move next)
cmd1b+=(--json "$(< "$_dir/tests/tree.json")" --dryrun)
while read -r ; do
  clear
  bashbud --bump "$_dir"
  shellcheck "$_dir/program.sh" && {

    "${cmd1a[@]}" "${cmd1b[@]}" --verbose
    "${cmd1a[@]}" "${cmd1b[@]}" --verbose  2> "$_dir/tests/results"
    
    diff "$_dir/tests/results" "$_dir/tests/ref1"

    echo $'\n'"loop ${cmd1a[*]} ; x$loops:"
    time(
      while ((++i<loops));do 
        "${cmd1a[@]}" "${cmd1b[@]}"
      done > /dev/null 2>&1
    )

    echo -n $'\n'"LOC: "
    cat "$_dir/main.sh" "$_dir/lib/"* | grep -E '^\s*[^#].+$' | wc -l
  }
done < <(
  inotifywait --event close_write          \
              --recursive --monitor        \
              --exclude 'awklib[.]sh$'     \
              "$_dir"/lib/*.sh             \
              "$_dir/main.sh"              \
              "$_dir/watch.sh"             \
              "$_dir/manifest.md"
)
