function _tide_sub_test
    argparse 'h/help' 'v/verbose' 'a/all' 'i/install' 'c-CI' -- $argv

    if set -q _flag_help
        _tide_test_help
        return 0
    else if set -q _flag_install
        # Install fisher and spout for testing
        curl git.io/fisher --create-dirs -sLo $__fish_config_dir/functions/fisher.fish
        fisher add IlanCosman/spout IlanCosman/clownfish
        return 0
    end

    if not functions --query spout mock
        set -l b (set_color -o; or echo)
        set -l n (set_color normal; or echo)
        printf '%s\n' $b'spout'$n' and'$b' clownfish'$n' must be installed to to run Tide\'s test suite. You can install them with'$b' tide test -i'$n
        return 1
    end

    set -lx TERM xterm # Necessary for testing purposes, ensures color codes are printed

    set -l testsDir "$_tide_dir/tests"

    set -l pending '/tmp/tide_test'
    set -l failed '/tmp/tide_test_failed'
    set -l passed '/tmp/tide_test_passed'

    set -l returnStatement 0

    if set -q _flag_all
        set argv (basename -s '.fish' $testsDir/*.fish)
    end

    if set -q _flag_CI
        set -a argv 'CI/'(basename -s '.fish' $testsDir/CI/*.fish)
    end

    if test (count $argv) -lt 1
        _tide_test_help
        return 1
    end

    sudo --validate # Cache sudo credentials

    for test in $argv
        if spout "$testsDir/$test.fish" >$pending
            if set -q _flag_verbose
                cat $pending >>$passed
            else
                printf '%s\n' "(✔) $test" >>$passed
            end
        else
            cat $pending >>$failed
        end
    end

    if test -e $passed
        printf '%s\n' '--------PASSED--------'
        cat $passed
        rm $passed
    end
    if test -e $failed
        printf '%s\n' '--------FAILED--------'
        cat $failed
        rm $failed

        return 1
    end
end

function _tide_test_help
    set -l b (set_color -o; or echo)
    set -l n (set_color normal; or echo)
    set -l bl (set_color $_tide_color_light_blue; or echo)

    set -l optionList \
        '-v or --verbose' \
        '-a or --all' \
        '-h or --help' \
        '-i or --install' \
        '--CI'
    set -l descriptionList \
        'display test output even if passed' \
        'run all available tests' \
        'print this help message' \
        'install fisher and spout test dependencies' \
        'run tests designed for CI'

    printf '%s\n' 'Usage: '$bl'tide test '$n'[options] '$b'[TESTS...]'$n
    printf '%s\n'
    printf '%s\n' 'Options:'
    for option in $optionList
        printf '%s' $option
        printf '%b' '\r'
        _tide_cursor_right 19
        set -l descriptionIndex (contains --index -- $option $optionList)
        printf '%s\n' $descriptionList[$descriptionIndex]
    end
end