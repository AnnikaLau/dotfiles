# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#

# Don't do anything when not running interactively (scp does not work with echo)
[[ $- == *i* ]] || return

test -s ~/.alias && . ~/.alias || true

# determine hostname for later use in all dotfiles
if [[ "${HOSTNAME}" == balfrin* ]]; then
    BASHRC_HOST='balfrin'
elif [[ "${HOSTNAME}" == santis* ]]; then
    BASHRC_HOST='santis'
elif [[ "${HOSTNAME}" == ni* ]]; then
    BASHRC_HOST='bristen'
elif [[ "${HOSTNAME}" == dom* ]]; then 
    BASHRC_HOST='dom'
elif [[ "${HOSTNAME}" == levante* ]]; then
    BASHRC_HOST='levante'
elif [[ "${HOSTNAME}" == eu* ]]; then 
    BASHRC_HOST='euler'
elif [[ "${HOSTNAME}" == m* ]]; then 
    BASHRC_HOST='mistral'
fi
export BASHRC_HOST

# ls colors
export LS_COLORS='di=1:fi=0:ln=100;93:pi=5:so=5:bd=5:cd=5:or=101:mi=0:ex=1;31'

# Git settings
export GIT_EDITOR="vim"
parse_git_branch() {
git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Does not work on Mac - run on Ubuntu to set up command prompt
if [[ ! -z $HOSTNAME ]]; then
    short_host="${HOSTNAME:0:2}-${HOSTNAME:${#HOSTNAME}-1:${#HOSTNAME}}"
    export PS1="\u@$short_host:\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\]> "
fi

# Custom modules/paths/envs for each machine

# local
if [[ -z $HOSTNAME ]]; then
    setopt auto_cd

# balfrin
elif [[ "${BASHRC_HOST}" == "balfrin" ]]; then
    . /etc/bash_completion.d/git.sh
    export PATH=$PATH:/users/alauber/script_utils
    export MODULEPATH=/mch-environment/v6/modules:${MODULEPATH}
    test -s ~/.profile && . ~/.profile || true

# santis
elif [[ "${BASHRC_HOST}" == "santis" ]]; then
    . /etc/bash_completion.d/git.sh
    export PATH="$PATH:/users/alauber/ngc-cli"
    export PATH="/users/alauber/miniconda3/bin:$PATH"

# dom
elif [[ "${BASHRC_HOST}" == "dom" ]]; then
    test -s ~/.profile && . ~/.profile || true
fi

# General aliases
alias c="scancel"
alias sq='squeue -u alauber'
alias sqw='watch -n 30 squeue -u alauber'
alias aall="scancel -u alauber"
alias ls='ls --color'
alias lsl='ls -ltrh --color'
alias la='ls -A'
alias g='grep -i --color'
alias gr='g -R'
alias tL='tail -f $(stat --printf "%n/%Y\0" * | sort -rz -t"/" -k 2 | head -z -n 1 | cut -d"/" -z -f 1 )'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ml='module load'
alias srcrc='source ~/.bashrc'
alias gt='git status'
alias ga='git add'
alias gco='git commit'
alias gc='git checkout'
alias gd='git diff'
alias gsui='git submodule update --init'
alias ncd='ncdump -h'
alias ncw='ncview'
alias fp='find "$PWD" -name'
alias ipython='python -m IPython'
alias lsC='ctags -R'
alias last='vim "$(stat --printf "%n/%Y\0" * | sort -rz -t"/" -k 2 | head -z -n 1 | cut -d"/" -z -f 1 )" 2>/dev/null'
alias balfrin='unset LC_CTYPE; ssh balfrin'
alias sc='cd $SCRATCH'
alias ut='uenv status'

# ICON
alias si='spack install'
alias lsL='ls -ltr LOG*' 
alias mr='if [[ -z "$EXP" ]]; then echo "EXP not set"; else ./make_runscripts ${EXP} && cd run; fi'
alias mrs='if [[ -z "$EXP" ]]; then echo "EXP not set"; else ./make_runscripts ${EXP}; fi'
alias gi='g -R --exclude-dir=cpu_double --exclude-dir=gpu_double --exclude-dir=cpu_mixed --exclude-dir=gpu_mixed --exclude-dir=spack-c2sm --exclude-dir=externals'
alias ce='if [[ -z "$EXP" ]]; then echo "EXP not set"; else [[ -d cpu_double/run/ ]] && cp run/exp.$EXP cpu_double/run/; [[ -d gpu_double/run/ ]] && cp run/exp.$EXP gpu_double/run/; [[ -d cpu_mixed/run/ ]] && cp run/exp.$EXP cpu_mixed/run/; [[ -d gpu_mixed/run/ ]] && cp run/exp.$EXP gpu_mixed/run/; fi'
alias ch='[[ -d cpu_double/run/tolerance/hashes/ ]] && cp run/tolerance/hashes/* cpu_double/run/tolerance/hashes/; [[ -d gpu_double/run/tolerance/hashes/ ]] && cp run/tolerance/hashes/* gpu_double/run/tolerance/hashes/; [[ -d cpu_mixed/run/tolerance/hashes/ ]] && cp run/tolerance/hashes/* cpu_mixed/run/tolerance/hashes/; [[ -d gpu_mixed/run/tolerance/hashes/ ]] && cp run/tolerance/hashes/* gpu_mixed/run/tolerance/hashes/'
alias re='if [[ -z "$EXP" ]]; then echo "EXP not set"; elif [[ "$(basename "$(pwd)")" == "run" ]]; then rm -rf ../experiments/$EXP; else rm -rf experiments/$EXP; fi'
alias st='cd spack-c2sm && echo "spack-c2sm -> $(git describe --tags)" && cd .. && bash -c '\''for file in config/cscs/SPACK_TAG_*; do echo "$file -> $(cat "$file")"; done'\'''
alias sbe='sbatch --partition debug --time 00:30:00 ./exp.$EXP.run'
alias sben='sbatch --partition normal --time 00:30:00 ./exp.$EXP.run'
alias sbc='sbatch --partition debug --time 00:30:00 ./check.$EXP.run'
alias sbcn='sbatch --partition normal --time 00:30:00 ./check.$EXP.run'

# Machine specific aliases

# local
if [[ -z $HOSTNAME ]]; then
    alias sc="/Users/alauber/Documents/C2SM"
    alias mountEuler='sshfs euler:/cluster/scratch/alauber/ ~/Documents/C2SM/Euler'
    alias umountEuler='umount ~/Documents/C2SM/Euler'
    alias mountDaint='sshfs daint:/scratch/snx3000/alauber/ ~/Documents/C2SM/Daint'
    alias umountDaint='umount ~/Documents/C2SM/Daint'
    alias mountBalfrin='sshfs balfrin:/scratch/mch/alauber/ ~/Documents/C2SM/Balfrin'
    alias umountBalfrin='umount ~/Documents/C2SM/Balfrin'

# levante
elif [[ "${BASHRC_HOST}" == "levante" ]]; then
    alias sq='squeue -u b381727'
    alias sqw='watch -n 30 squeue -u b381727'
    alias aall="scancel -u b381727"
fi
