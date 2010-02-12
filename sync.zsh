#!/bin/zsh

D="apple.com"
# target hosts to receive the sync

if [[ $# -gt 0 ]] ; then
    TARGETS=($@)
else
    TARGETS=(launchpad001 launchpad002 qa1-launchpad02 qa2-launchpad02 int1-launchpad02 int2-launchpad02 qa3-launchpad02 is02 iswiki iswiki:/dmadmin/async/users/eric/dotfiles)
#    TARGETS=(iswiki iswiki:/dmadmin/async/users/eric/dotfiles)
	 
fi

echo -n "sync to localhost..."
rsync -rlp --stats --exclude=sync.zsh . ~  && echo "OK"

for T in $TARGETS ; do
        if [[ -n $(echo $T | grep ":") ]] ; then
            HOSTSPEC=`echo $T | sed 's/:.*$//'`
            PATHSPEC=`echo $T | sed 's/^.*://'`
        else
            HOSTSPEC=$T
            PATHSPEC=""
        fi
	echo -n "sync to ${HOSTSPEC}:${PATHSPEC}"
        
	if ssh -q -o"ConnectTimeout 5" $HOSTSPEC hostname > /dev/null 2>&1  ; then
		rsync -rlp --stats --exclude=sync.zsh -e 'ssh -q' . ${HOSTSPEC}:${PATHSPEC}  && echo "OK"
	else
		echo "Failed"
	fi
done

