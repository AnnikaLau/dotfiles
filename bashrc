# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#

test -s ~/.alias && . ~/.alias || true

# determine hostname for later use in all dotfiles
if [[ "${HOSTNAME}" == tsa* ]]; then
    BASHRC_HOST='tsa'
elif [[ "${HOSTNAME}" == daint* ]]; then 
    BASHRC_HOST='daint'
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
    alias hh='/Users/alauber'
    alias sc="/Users/alauber/Documents/C2SM"
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
    __conda_setup="$('/scratch/snx3000/alauber/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/scratch/snx3000/alauber/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/scratch/snx3000/alauber/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/scratch/snx3000/alauber/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

# euler
elif [[ "${BASHRC_HOST}" == "euler" ]]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/cluster/scratch/alauber/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/cluster/scratch/alauber/miniconda3/etc/profile.d/conda.sh" ]; then
             . "/cluster/scratch/alauber/miniconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
            echo one
        else
             export PATH="/cluster/scratch/alauber/miniconda3/bin:$PATH"  # commented out by conda initialize
            echo two
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
# dom
elif [[ "${BASHRC_HOST}" == "dom" ]]; then
    test -s ~/.profile && . ~/.profile || true
fi

# Spack
case ${BASHRC_HOST} in
      tsa) 
          export SPACK_ROOT=/project/g110/spack/user/tsa/spack 
          ;;
      daint) 
          export SPACK_ROOT=/project/g110/spack/user/daint/spack
          ;;
      dom) 
          export SPACK_ROOT=/project/g110/spack/user/dom/spack 
          ;;
      *)
          echo bashrc: Spack not available on $BASHRC_HOST!
esac

# Machine specific aliases

# tsa
if [[ "${BASHRC_HOST}" == "tsa" ]]; then
    alias srcspack="source $SPACK_ROOT/share/spack/setup-env.sh"
    alias spak="spack  --config-scope=${HOME}/.spack/$BASHRC_HOST"
    alias sc='cd /scratch/alauber/'
    alias aall="scancel -u alauber"
    alias sq='squeue -u alauber'
    alias squ='squeue'
    alias hh='cd /users/alauber/'

# daint
elif [[ "${BASHRC_HOST}" == "daint" ]]; then
    alias srcspack="source $SPACK_ROOT/share/spack/setup-env.sh"
    alias spak="spack  --config-scope=${HOME}/.spack/$BASHRC_HOST"
    alias sc='cd /scratch/snx3000/alauber/'
    alias aall="scancel -u alauber"
    alias c="scancel"
    alias sq='squeue -u alauber'
    alias squ='squeue'
    alias hh='cd /users/alauber/'
    alias jenkins='cd /scratch/snx3000/jenkins/workspace'
    alias lsa='ml daint-gpu && ml PyExtensions && ml cray-python PyExtensions python_virtualenv'
    alias ex='sc && cd extpar && ml daint-gpu && ml CDO && . /project/g110/extpar_envs/venv_jenkins_daint/bin/activate && export PYTHONPATH=$PYTHONPATH:$(pwd)/python/lib'

# dom
elif [[ "${BASHRC_HOST}" == "dom" ]]; then
    alias srcspack="source $SPACK_ROOT/share/spack/setup-env.sh"
    alias spak="spack  --config-scope=${HOME}/.spack/$BASHRC_HOST"
    alias sc='cd /scratch/snx3000tds/alauber/'
    alias aall="scancel -u alauber"
    alias sq='squeue -u alauber'
    alias squ='squeue'
    alias hh='cd /users/alauber/'

# euler
elif [[ "${BASHRC_HOST}" == "euler" ]]; then
    alias srcspack="source $SPACK_ROOT/share/spack/setup-env.sh"
    alias spak="spack  --config-scope=${HOME}/.spack/$BASHRC_HOST"
    alias sc='cd /cluster/scratch/alauber/'
    alias c="scancel"
    alias aall="scancel -u alauber"
    alias hh='cd /cluster/home/alauber/'
    alias sq='squeue -u alauber'
    alias squ='squeue'

# mistral
elif [[ "${BASHRC_HOST}" == "mistral" ]]; then
    alias aall="scancel -u b381001"
    alias sq='squeue -u b381001'
    alias squ='squeue'
    alias hh='cd /pf/b/b381001'
    alias sc='cd /scratch/b/b381001'
    alias jenkins='cd /mnt/lustre01/scratch/b/b380729/workspace'
fi

# Model specific aliases

# COSMO
alias ct="cat testsuite.out"
alias tt="tail -f testsuite.out"
alias bu='./test/jenkins/build.sh'
alias vo='vim INPUT_ORG'
alias vp='vim INPUT_PHY'
alias vd='vim INPUT_DYN'
alias vio='vim INPUT_IO'

# ICON
alias lsL='ls -ltr LOG*' 
alias tL='tail -f LOG*'


# General aliases
alias ls='ls --color'
alias lsl='ls -ltrh --color'
alias la='ls -A'
alias g='grep -i'
alias t='tail -f'
alias ..='cd ..'
alias ml='module load'
alias su='source'
alias srcrc='source ~/.bashrc'
alias rcvim='vim ~/.bashrc'
alias gt='git status'
alias ga='git add'
alias gco='git commit'
alias gc='git checkout'
alias gd='git diff'
alias gsi='git submodule init'
alias gsu='git submodule update'
alias gsui='git submodule update --init'
alias ncd='ncdump -h'
alias ncw='ncview'
alias fp='find "$PWD" -name'
alias ipython='python -m IPython'
alias mountEuler='sshfs euler:/cluster/scratch/alauber/ ~/Documents/C2SM/Euler'
alias umountEuler='umount ~/Documents/C2SM/Euler'
alias mountDaint='sshfs daint:/scratch/snx3000/alauber/ ~/Documents/C2SM/Daint'
alias umountDaint='umount ~/Documents/C2SM/Daint'
alias lsC='ctags -R'
