function _tide_detect_os
    switch (uname | string lower)
        case darwin
            set -g _tide_os_icon 
        case freebsd openbsd dragonfly
            set -g _tide_os_icon 
        case linux
            if _tide_detect_os_linux_cases /etc/os-release ID
            else if _tide_detect_os_linux_cases /etc/os-release ID_LIKE
            else if _tide_detect_os_linux_cases /etc/lsb-release DISTRIB_ID
            else
                set -g _tide_os_icon 
            end
        case '*'
            set -g _tide_os_icon '?'
    end
end

function _tide_detect_os_linux_cases -a file key
    set -l splitOsRelease (cat $file | string split '=')
    set -l value $splitOsRelease[(math (contains --index $key $splitOsRelease)+1)]
    set -l name (string trim --chars='"' $value | string lower)

    switch $name
        case alpine
            set -g _tide_os_icon 
        case arch
            set -g _tide_os_icon 
        case centos
            set -g _tide_os_icon 
        case debian
            set -g _tide_os_icon 
        case elementary
            set -g _tide_os_icon 
        case fedora
            set -g _tide_os_icon 
        case gentoo
            set -g _tide_os_icon 
        case linuxmint
            set -g _tide_os_icon 
        case manjaro
            set -g _tide_os_icon 
        case nixos
            set -g _tide_os_icon 
        case opensuse tumbleweed
            set -g _tide_os_icon 
        case raspbian
            set -g _tide_os_icon 
        case ubuntu
            set -g _tide_os_icon 
        case '*'
            return 1
    end
    return 0 # If we didn't run into the catch case '*' return succesfull
end
