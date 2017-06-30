# bashrc for Go hacking

#
# Wrap the main go command to support injected sub-commands
#
#  go be work/space        Set up GOPATH and PATH env vars to
#                          use a work/space as the workspace.
#
#  go *                    Hand off to the main go binary
#
go() {
	if [[ $1 == "be" ]]; then
		if [[ -z "$2" ]]; then
			echo "GOPATH=${GOPATH}"
			return 0
		fi

		candidate="$2"
		name="$2"
		export GOENV="${candidate}"
		if [[ ! $candidate =~ "^/" ]]; then
			candidate="${HOME}/code/go/${candidate}"
		fi
		if [[ ! -d ${candidate} ]]; then
			echo >&2 "${candidate}: No such file or directory"
			return 1
		fi

		[[ -n ${GOPATH} ]] && pathify -r ${GOPATH}/bin -a ${candidate}/bin
		export GOPATH=${candidate}
		export PATH=${PATH}:${GOPATH}/bin
		echo "GOPATH=${GOPATH}"
		tmux a -t "${name}" &>/dev/null || cd ${GOPATH}

	elif [[ $1 == "setup" ]]; then
		if [[ -n $2 ]]; then
			echo "Setting up $2"
			mkdir -p ${HOME}/code/go/$2
			go be $2
		fi
		true
		return $?

	elif [[ $1 == "refresh" ]]; then
		if [[ -n $2 ]]; then
			if [[ ! -d ${HOME}/code/go/$2 ]]; then
				echo "$2 not set up yet."
				echo "Try \`go setup $2\`"
				return 1
			fi
			go be $2
		fi
		command go get -u github.com/golang/lint/golint && \
		command go get -u github.com/onsi/ginkgo && \
		command go get -u github.com/onsi/ginkgo/ginkgo && \
		command go get -u github.com/onsi/gomega && \
		command go get -u github.com/mitchellh/gox && \
		true
		return $?
	else
		command go "$@"
		return $?
	fi
}

# Go Programming ######################################
if [[ -z $GOPATH && -d ~/go ]]; then
	export GOPATH=$HOME/go
	export PATH="$PATH:$GOPATH/bin"
fi

# vim:ft=bash
