# i3flip - Tabswitching done right 

### usage

```text
i3flip [--move|-m] [--json JSON] [--verbose] [--dryrun] DIRECTION
i3flip --help|-h
i3flip --version|-v
```

`i3flip` switch containers without leaving the parent.
Perfect for tabbed or stacked layout, but works on all
layouts. If direction is `next` and the active container is
the last, the first container will get focused.  

**DIRECTION** can be either *prev* or *next*, which can be
defined with different words:  

**next**|right|down|n|r|d  
**prev**|left|up|p|l|u  


OPTIONS
-------

`--move`|`-m`  
Move the current container instead of changing focus.

`--json` JSON  
use JSON instead of output from  `i3-msg -t get_tree`

`--verbose`  
Print more information to **stderr**.

`--dryrun`  
Don't execute any *i3 commands*.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.

EXAMPLES
--------
`~/.config/i3/config`:  
``` text
...
bindsym Mod4+Tab         exec --no-startup-id i3flip next
bindsym Mod4+Shift+Tab   exec --no-startup-id i3flip prev
```

## updates

### 2020.08.09

We now use the output of **i3viswiz** instead of a custom
AWK script. This made everything more reliable and `--move`
function now works as expected in all types of layouts,
(*not just tabbed and stacked as before*). Also added
`--json`, `--verbose` and `--dryrun` options.




