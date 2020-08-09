messy() {
  # arguments are valid i3-msg arguments
  (( __o[verbose] )) && ERM "m $*"
  (( __o[dryrun]  )) || _msgstring+="$*;"
}
