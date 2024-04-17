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
elif [[ "${HOSTNAME}" == ni* ]]; then
    BASHRC_HOST='vial'
elif [[ "${HOSTNAME}" == dom* ]]; then 
    BASHRC_HOST='dom'
elif [[ "${HOSTNAME}" == eu* ]]; then 

    if tty -s; then
        BASHRC_HOST='euler'

    # do nothing for me as Jenkins user
    else
        return
    fi
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

if [[ ! -z $HOSTNAME ]]; then # Does not work on Mac
    # Command prompt
    short_host="${HOSTNAME:0:2}-${HOSTNAME:${#HOSTNAME}-1:${#HOSTNAME}}"
    export PS1="\u@$short_host:\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\]> "
fi

# Custom modules/paths/envs for each machine

# local
if [[ -z $HOSTNAME ]]; then
    setopt auto_cd
    alias sc="/Users/alauber/Documents/C2SM"
    alias mountEuler='sshfs euler:/cluster/scratch/alauber/ ~/Documents/C2SM/Euler'
    alias umountEuler='umount ~/Documents/C2SM/Euler'
    alias mountDaint='sshfs daint:/scratch/snx3000/alauber/ ~/Documents/C2SM/Daint'
    alias umountDaint='umount ~/Documents/C2SM/Daint'
    alias mountBalfrin='sshfs balfrin:/scratch/mch/alauber/ ~/Documents/C2SM/Balfrin'
    alias umountBalfrin='umount ~/Documents/C2SM/Balfrin'
fi

# tsa
if [[ "${BASHRC_HOST}" == "tsa" ]]; then
    source /oprusers/osm/.opr_setup_dir
    export OPR_SETUP_DIR=/oprusers/osm/opr.arolla
    export LM_SETUP_DIR=$HOME
    PATH=${PATH}:${OPR_SETUP_DIR}/bin
    export MODULEPATH=$MODULEPATH:$OPR_SETUP_DIR/modules/modulefiles 

# daint
elif [[ "${BASHRC_HOST}" == "daint" ]]; then
    . /etc/bash_completion.d/git.sh
    export PATH=$PATH:/users/alauber/script_utils
    test -s ~/.profile && . ~/.profile || true
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
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
    export MODULEPATH=/mch-environment/v5/modules:/usr/share/modules:/usr/share/Modules/$MODULE_VERSION/modulefiles:/usr/share/modules/modulefiles
    test -s ~/.profile && . ~/.profile || true


# vial
elif [[ "${BASHRC_HOST}" == "vial" ]]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/capstor/scratch/cscs/alauber/probtest/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/capstor/scratch/cscs/alauber/probtest/miniconda/etc/profile.d/conda.sh" ]; then
            . "/capstor/scratch/cscs/alauber/probtest/miniconda/etc/profile.d/conda.sh"
        else
            export PATH="/capstor/scratch/cscs/alauber/probtest/miniconda/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
    echo Mount squashfs!

# dom
elif [[ "${BASHRC_HOST}" == "dom" ]]; then
    test -s ~/.profile && . ~/.profile || true
fi

# Machine specific aliases

# tsa
if [[ "${BASHRC_HOST}" == "tsa" ]]; then
    alias sc='cd /scratch/alauber/'

# daint
elif [[ "${BASHRC_HOST}" == "daint" ]]; then
    alias sc='cd /scratch/snx3000/alauber/'
    alias st='[ "$(cd spack-c2sm && git describe --tags)" = "$(cat "config/cscs/SPACK_TAG_C2SM" 2>/dev/null)" ] && echo "Spack tag correct" || echo "Spack tag has changed"'

# balfrin
elif [[ "${BASHRC_HOST}" == "balfrin" ]]; then
    alias sc='cd /scratch/mch/alauber'
    alias st='[ "$(cd spack-c2sm && git describe --tags)" = "$(cat "config/cscs/SPACK_TAG_MCH" 2>/dev/null)" ] && echo "Spack tag correct" || echo "Spack tag has changed"'

# vial
elif [[ "${BASHRC_HOST}" == "vial" ]]; then
    alias sc='cd /capstor/scratch/cscs/alauber'
    alias m='squashfs-mount $SCRATCH/starting_scripts/vial-v1.0.squashfs:/user-environment -- bash'

# dom
elif [[ "${BASHRC_HOST}" == "dom" ]]; then
    alias sc='cd /scratch/snx3000tds/alauber/'

# euler
elif [[ "${BASHRC_HOST}" == "euler" ]]; then
    alias sc='cd /cluster/scratch/alauber/'
fi
# Model specific aliases

# ICON
alias lsL='ls -ltr LOG*' 
alias mr='if [[ -z "$EXP" ]]; then echo "EXP not set"; else ./make_runscripts ${EXP} && cd run; fi'
alias gi='g -R --exclude-dir=nvhpc_cpu --exclude-dir=nvhpc_gpu --exclude-dir=nvhpc_cpu_mixed --exclude-dir=nvhpc_gpu_mixed --exclude-dir=spack-c2sm --exclude-dir=externals'
alias ce='if [[ -z "$EXP" ]]; then echo "EXP not set"; else cp run/exp.$EXP nvhpc_cpu/run/. && cp run/exp.$EXP nvhpc_gpu/run/. && cp run/exp.$EXP nvhpc_cpu_mixed/run/. && cp run/exp.$EXP nvhpc_gpu_mixed/run/.; fi'
alias ch='cp run/tolerance/hashes/* nvhpc_cpu/run/tolerance/hashes/. && cp run/tolerance/hashes/* nvhpc_gpu/run/tolerance/hashes/. && cp run/tolerance/hashes/* nvhpc_cpu_mixed/run/tolerance/hashes/. && cp run/tolerance/hashes/* nvhpc_gpu_mixed/run/tolerance/hashes/.'
alias re='if [[ "$(basename "$(pwd)")" == "run" ]]; then rm -rf ../experiments; else rm -rf experiments; fi'




# General aliases
alias c="scancel"
alias sq='squeue -u alauber'
alias sqw='watch -n 3 squeue -u alauber'
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
