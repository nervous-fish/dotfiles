function fish_greeting
    fastfetch
end

set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

if test -f ~/.fish_profile
  source ~/.fish_profile
end

fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools

function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end
direnv hook fish | source

# zoxide: `z <name>` jumps to a frequently used folder.
if type -q zoxide
    zoxide init fish | source
end
