# oc [name] — jump to a folder with zoxide (if a name is given), then start opencode there.
function oc --description 'zoxide jump + opencode'
    if test (count $argv) -gt 0
        z $argv; or return
    end
    opencode
end
