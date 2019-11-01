#!/usr/bin/env zsh

#alias ssh="wrap_ssh.zsh ssh"
#alias scp="wrap_ssh.zsh scp"

typeset -A hosts=(
	"babo"  "oathtool -b 'NSWDRG7XIWXSJFQDL5G2S57U54' -d 6 --totp --time-step-size 30"
	"virt1" "oathtool -b 'WQDDHNXPT7XOVRPG525KUB3T2Q' -d 6 --totp --time-step-size 30"
)

type="${1:-ssh}"
shift

code=""
for host in "$@"; do
	host=${host/:*/}
	host=${host/*@/}
	grep --quiet -i 'Host '${host}'$' $HOME/.ssh/conf.d/* || continue
	[[ "${hosts[$host]}" != "" ]] && {
		code=$(eval "${hosts[$host]}")
		echo "Copied code to clipboard: $code"
		echo "$code" | xclip
		break
	}
done
if [ "$code" != "" ]; then
	sshpass -p$code -P "Verification code:" $type "$@"
	exit $?
fi

$type "$@"
exit $?
