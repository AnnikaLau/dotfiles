# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#

# Don't do anything when not running interactively (scp does not work with echo)
[[ $- == *i* ]] || return

test -s ~/.alias && . ~/.alias || true

# determine hostname for later use in all dotfiles
if [[ "${HOSTNAME}" == tsa* ]]; then
    BASHRC_HOST='tsa'
elif [[ "${HOSTNAME}" == daint* ]]; then 
    BASHRC_HOST='daint'
elif [[ "${HOSTNAME}" == balfrin* ]]; then
    BASHRC_HOST='balfrin'
elif [[ "${HOSTNAME}" == todi* ]]; then
    BASHRC_HOST='todi'
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

# Custom modules/paths/envs for each machine

# local
if [[ -z $HOSTNAME ]]; then
    setopt auto_cd

# daint
elif [[ "${BASHRC_HOST}" == "daint" ]]; then
    . /etc/bash_completion.d/git.sh
    export PATH=$PATH:/users/alauber/script_utils
    test -s ~/.profile && . ~/.profile || true
    # >>> conda initialize >>>
    __conda_setup="$('/users/alauber/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/users/alauber/mambaforge/etc/profile.d/conda.sh" ]; then
            . "/users/alauber/mambaforge/etc/profile.d/conda.sh"
        else
            export PATH="/users/alauber/mambaforge/bin:$PATH"
        fi
    fi
    unset __conda_setup

    if [ -f "/users/alauber/mambaforge/etc/profile.d/mamba.sh" ]; then
        . "/users/alauber/mambaforge/etc/profile.d/mamba.sh"
    fi
    # <<< conda initialize <<<
    export PROJECT=/project/g110/alauber
    export CONDA_ENVS_PATH=/project/g110/alauber/envs

# balfrin
elif [[ "${BASHRC_HOST}" == "balfrin" ]]; then
    . /etc/bash_completion.d/git.sh
    export PATH=$PATH:/users/alauber/script_utils
    export MODULEPATH=/mch-environment/v6/modules:${MODULEPATH}
    test -s ~/.profile && . ~/.profile || true

# santis
elif [[ "${BASHRC_HOST}" == "santis" ]]; then
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

# ICON
alias si='spack install'
alias lsL='ls -ltr LOG*' 
alias mr='if [[ -z "$EXP" ]]; then echo "EXP not set"; else ./make_runscripts ${EXP} && cd run; fi'
alias gi='g -R --exclude-dir=nvhpc_cpu --exclude-dir=nvhpc_gpu --exclude-dir=nvhpc_cpu_mixed --exclude-dir=nvhpc_gpu_mixed --exclude-dir=spack-c2sm --exclude-dir=externals'
alias ce='if [[ -z "$EXP" ]]; then echo "EXP not set"; else cp run/exp.$EXP nvhpc_cpu/run/. && cp run/exp.$EXP nvhpc_gpu/run/. && cp run/exp.$EXP nvhpc_cpu_mixed/run/. && cp run/exp.$EXP nvhpc_gpu_mixed/run/.; fi'
alias ch='cp run/tolerance/hashes/* nvhpc_cpu/run/tolerance/hashes/. && cp run/tolerance/hashes/* nvhpc_gpu/run/tolerance/hashes/. && cp run/tolerance/hashes/* nvhpc_cpu_mixed/run/tolerance/hashes/. && cp run/tolerance/hashes/* nvhpc_gpu_mixed/run/tolerance/hashes/.'
alias re='if [[ "$(basename "$(pwd)")" == "run" ]]; then rm -rf ../experiments; else rm -rf experiments; fi'
alias st='cd spack-c2sm && echo "spack-c2sm -> $(git describe --tags)" && cd .. && bash -c '\''for file in config/cscs/SPACK_TAG_*; do echo "$file -> $(cat "$file")"; done'\'''

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
