# Completions for `oc` (zoxide jump + opencode): suggest known zoxide folders.
# Having this file also stops fish from probing `oc completion fish`, which
# would otherwise run the oc function itself while you type.
complete -c oc -f -a "(zoxide query --list 2>/dev/null | path basename)"
