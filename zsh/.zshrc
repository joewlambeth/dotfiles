export CLICOLOR=1

precmd() {
	EXIT_STATUS=$?

    EXIT_STATUS_COLOR="75"
    BRANCH_COLOR="154"

	GIT_BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null)
	NUM_JOBS=$(jobs | wc -l)

	[[ -z $GIT_BRANCH ]] || GIT_BRANCH=" %F{$BRANCH_COLOR}($GIT_BRANCH)%f"
    [[ $EXIT_STATUS -eq 0 ]] || EXIT_STATUS_COLOR="208"
    [[ $NUM_JOBS -gt 0 ]] && RPS1="%F{$BRANCH_COLOR}[$NUM_JOBS jobs]%f"

    PS_TIME=" %F{yellow}%U[%D{%r}]%u%f"
	PS_EXIT=" %F{$EXIT_STATUS_COLOR}[%?]%f "
	PS_PATH="%F{green}%~%f$GIT_BRANCH"
	export PS1="$PS_TIME$PS_EXIT$PS_HOST$PS_PATH %F{245}>%f"
}
