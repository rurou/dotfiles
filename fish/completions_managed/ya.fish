# ya completions
complete -c ya -f
complete -c ya -n __fish_use_subcommand -a pkg   -d "Package manager"
complete -c ya -n __fish_use_subcommand -a pub   -d "Publish DDS message"
complete -c ya -n __fish_use_subcommand -a emit  -d "Emit DDS event"

complete -c ya -n "__fish_seen_subcommand_from pkg" -a add     -d "Add a package"
complete -c ya -n "__fish_seen_subcommand_from pkg" -a delete  -d "Delete a package"
complete -c ya -n "__fish_seen_subcommand_from pkg" -a upgrade -d "Upgrade packages"
complete -c ya -n "__fish_seen_subcommand_from pkg" -a list    -d "List packages"

