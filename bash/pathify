# pathify - a small utility for messing with $PATH

# `pathify` allows addition (-a $PATTERN) and removal (-r $PATTERN) of
# paths.  Paths can also be promoted (activated earlier) and demoted
# (activated later) via pattern matches.  Deduplication of pathing
# happens automatically.
#
# EXAMPLES
#
# Just dedupe $PATH:
#
#   $ pathify
#
# Dedupe, add my personal scripts, and demote anything for RVM:
#
#   $ pathify -a $HOME/bin -d .rvm
#
# Also, remove anything from /opt/vendor or /usr/local
#
#   $ pathify -a $HOME/bin -d .rvm -r /opt/vendor /usr/local
#
pathify() {
	local mode=add
	local path=$PATH
	declare -a head=() tail=()

	while (( $# )); do
		arg=$1 ; shift
		case ${arg} in
		(-a|--add)     mode=add     ;;
		(-r|--remove)  mode=rm      ;;
		(-d|--demote)  mode=demote  ;;
		(-p|--promote) mode=promote ;;
		(-*)
			echo >&2 "Unrecognized option: ${arg}"
			return 1
			;;
		(*)
			case ${mode} in
			(add)
				path="${path}:${arg}"
				;;
			(rm)
				head=()
				while IFS=: read -ra l; do
					for p in "${l[@]}"; do
						[[ "${p}" =~ "${arg}" ]] || head+=($p)
					done
				done <<< "$path"
				path=$(IFS=: ; echo "${head[*]}")
				;;
			(demote|promote)
				head=() ; tail=()
				while IFS=: read -ra l; do
					for p in "${l[@]}"; do
						if [[ "${p}" =~ "${arg}" ]]; then
							head+=($p)
						else
							tail+=($p)
						fi
					done
				done <<< "$path"
				if [[ "${mode}" == "promote" ]]; then
					path=$(IFS=: ; echo "${head[*]}:${tail[*]}")
				else
					path=$(IFS=: ; echo "${tail[*]}:${head[*]}")
				fi
				;;
			(*)
				echo >&2 "Unrecognized mode: ${mode}"
				return 1
				;;
			esac
			;;
		esac
	done

	# dedupe
	head=()
	while IFS=: read -ra l; do
		for x in "${l[@]}"; do
			found=
			for y in "${head[@]}"; do
				if [[ ${x} == ${y} ]]; then
					found=1
					break
				fi
			done
			if [[ -z ${found} ]]; then
				head+=($x)
			fi
		done
	done <<< "$path"
	export PATH=$(IFS=: ; echo "${head[*]}")
}

# vim:ft=bash
