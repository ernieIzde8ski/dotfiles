#!/bin/zsh


__pyl_reqs='pip list --format=freeze --not-required'
__pyl_filter="sed -r 's/pip\=\=.*\$(\\\n)?//g'"
__pyl_subst="sed -r 's/\b\=\=\b/>=/g'"


alias ls-pip-reqs="$__pyl_reqs | $__pyl_filter | $__pyl_subst"


function test-ls-pip-reqs() {
    ret=0

    if ls-pip-reqs | rg 'pip>=.*'; then
        echo 'error: __pyl_filter is not working properly' 1>&2
        echo '       ls-pip-reqs emits a pip line'
        ret=1
    fi

    if [[ $ret == 0 ]]; then
        echo 'All tests passed!'
    else
        echo
        echo "debug values:"
        echo "  __pyl_reqs=${__pyl_reqs}"
        echo "  __pyl_filter=${__pyl_filter}"
        echo "  __pyl_subst=${__pyl_subst}"
    fi

    return $ret
}
