#!/bin/bash
## Study REF-> https://explainshell.com/
## Study REF-> https://developer.apple.com/library/content/documentation/OpenSource/Conceptual/ShellScripting/performance/performance.html
## Study REF-> https://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html

###!/usr/local/bin/dash
## BASH VS DASH - https://www.jpsdomain.org/public/2008-JP_bash_vs_dash.pdf
##TODO: DASH PORTABILITY SUPPORT (For Loop -> While Loop) 
#REF1: https://unix.stackexchange.com/questions/148035/is-dash-or-some-other-shell-faster-than-bash
#REF2: https://askubuntu.com/questions/621981/for-loop-syntax-in-shell-script
#REF3: https://wiki.archlinux.org/index.php/Dash
#REF4: https://lyness.io/the-functional-and-performance-differences-of-sed-awk-and-other-unix-parsing-utilities

#!/bin/sh
# number=0
# while [ $number -lt 10 ]
# do
#         printf "\t%d" "$number"
#         number=$((number + 1))
# done

# export LC_ALL=C 
export LC_ALL=en_US.UTF-8
export LoginDay=$(date +%F)
## LC_ALL=en_US or C?  To speed up in byte?
# https://unix.stackexchange.com/questions/303157/is-there-something-wrong-with-my-script-or-is-bash-much-slower-than-python/303167#303167
## Drawbacks 
# $ LC_ALL=en_US sort <<< $'a\nb\nA\nB'
# a
# A
# b
# B
# $ LC_ALL=C sort <<< $'a\nb\nA\nB'
# A
# B
# a
# b

# Authors : 
# [Ralic Lo (ralic.lo.eng@ieee.org)
# [NATHANIEL LANDAU] https://natelandau.com/nathaniel-landau-resume/

# Copyright [2017] 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### ./configure notes
#(3) When space is important, we suggest --without-readline, --disable-shared, 
# and possibly --disable-nls and --disable-dynamic-loading.
#For MacOSX, install coreutils (which includes greadlink)

# $brew install coreutils
# CC          C compiler command ## gcc
# CFLAGS      C compiler flags
# CXX         C++ compiler command ## gcc
# CXXFLAGS    C++ compiler flags ## gcc-E
# CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> 
# LDFLAGS     linker flags, e.g. -L<lib dir> 
# LIBS        libraries to pass to the linker, e.g. -l<library>
# CPP         C preprocessor ## gcc -E
# CXXCPP      C++ preprocessor

## TODO 
# --with-cxxflags='-mmic ' \
# --with-cflags='-mmic '
# --flto-compression-level  ## LTOFLAS Controls 
# https://gcc.gnu.org/onlinedocs/gcc-4.9.2/gcc/Optimize-Options.html
# MPIFLAG=" -lelan lmpi"

## Notes:
## change gcc to cc // 2017-06-08 ## change cc to mpicc //2017-09-07
## CXXCPP: 2017.9.12 -- Using g++7 ok, not ok using clang-5 or mpicpp"
##                   -- Other options : g++ -E or gcc -E
##                   -- It's ok to replace gcc c++ by gcc-7

### Defines commands to be excuted after parsing all scripts
### (For script Hoisting)
function START_UP@BEGIN() {
echo "[Info] Running boot scripts"	 
	SETCC="gcc"
	GCC_VER=7
	alias xxargs='xargs -n 1 -P $PACORES'
	alias sll=subl
}

START_UP@BEGIN

function START_UP@END() {
	printlibs > /dev/null
	bootlibs >/dev/null
	setcc
	cheditor vi > /dev/null
	export MAKEJOBS="-j16"
	alias cgrep="grep --color=always"
	neofetch
# export LDFLAGS="-L/usr/local/Cellar/gcc/7.2.0/lib/gcc/7 $LDFLAGS" 
# export CPPFLAGS="-I/usr/local/Cellar/gcc/7.2.0/lib/gcc/7/gcc/x86_64-apple-darwin17.0.0/7.2.0/include  $CPPFLAGS" 
# export CPPFLAGS="-I/usr/local/Cellar/gcc/7.2.0/include/c++/7.2.0/tr1 $CPPFLAGS"
	# macdev	
}

function setcc() {
	if [[ $# -eq 1 ]] ; then
	    SETCC=$1
    fi
    
    case $SETCC in
        "gcc") ## DEFAULT ##
            export GCC_FLAGS=" -mmovbe  -m128bit-long-double   -msseregparm -mfpmath=sse+387 -mfpmath=both -lpthread"
            FC="gfortran";  CC="gcc" ;CXX="gcc" ; 
            CPP="gcc -E" ; CXXCPP=" gcc -E" ;
        ;;    
        "gccx") ## GCC ##
			#10/06 GCC ONLY? , these flags may further import program performance when we are using gcc-7, tested on Debian9/Xeon CPU  ## 
	    export GCC_FLAGS="-mmovbe  -m128bit-long-double   -msseregparm -mfpmath=sse+387 -mfpmath=both  -lpthread"
            FC="gfortran-$GCC_VER";CC="gcc-$GCC_VER";CXX="gcc-$GCC_VER" ;CPP="gcc-$GCC_VER -E";CXXCPP="gcc-$GCC_VER -E"
            export HOMEBREW_CC="gcc-$GCC_VER"
        ;;
        "clang")  ## CLANG ##
            FC="gfortran";CC="cc";CXX="cc" ;CPP="gcc -E";CXXCPP="gcc -E"
            export HOMEBREW_CC="clang"
        ;;
        "mpicc") ## MPICC version ##
            FC="mpifort"; CC="mpicc"; CXX="mpicc" ; CPP="mpic++ -E "  ;CXXCPP="mpicc -E"  
            MPIFC="mpifort";MPICC="mpicc";MPICPP="mpicc -E" ;MPICXX="mpicxx"
            # FC="mpifort"; CC="mpicc"; CXX="mpicxx" ; CPP="mpicc -E"  ;CXXCPP="clang -E"  
            # MPIFC="mpifort";MPICC="mpicc";MPICPP="mpicc -E" ;MPICXX="mpicxx"
            HOMEBREW_CC="mpicc"; HOMEBREW_CXX="mpicxx"
        ;;
        *) ## NO Setting as default ##
        ;;  
    esac
    ## echo with $'' strings  = ANSI C Quoting:
echo "$(tput setaf 2)"$'[Info] setcc (gcc/gccx/clang/mpicc). To change compiler in BREW.
       Type brew --env for details,SETCC='$SETCC',PACORES='$PACORES"$(tput sgr0)"
}

function cheditor() {
    echo "[Info] cheditor, Script to change your default terminal editor"
    if [[ $# -eq 0 ]] ; then
        local VAR_EDITOR=subl   
    else
        local VAR_EDITOR="$@"
    fi
    export TEXT_Editor=$VAR_EDITOR
    export EDITOR=$VAR_EDITOR
}

# function checkOS() {
# }
# export HOMEBREW_BUILD_FROM_SOURCE=1
### For Linux/Debian
if [ "$(uname -s)" == "Linux" ]; then
    ## PARALLEL PROCESSING for lz4dir/xz4dir 
    PACORES=$(( $(grep -c ^processor /proc/cpuinfo) )) 
    PACORES=$(( $PACORES * 2 ))

    if [[ $(uname -r) == *"amzn1"* ]]; then
	  echo " RUNNING AWS LINUX!"
    setcc gcc
	fi
    UsrPATH="/home"
    UsrNAME=$(whoami)
    ## Linuxbrew Support
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    #export MASTERUSER= $(whoami)
     # sudo mkdir -p /home/linuxbrew
     # sudo ln -s -f /home/linuxbrew/.linuxbrew/usr /usr/local/.linuxbrew
     # sudo ln -s -f /home/linuxbrew/.linuxbrew/Cellar  /usr/local/Cellar ##  -f : force
     # sudo ln -s -f /home/linuxbrew/.linuxbrew/Homebrew  /usr/local/Homebrew ##  -f : force
     # sudo ln -s -f /home/linuxbrew/.linuxbrew/Homebrew/Library  /usr/local/Library ##  -f : force
     # sudo ln -s -f /home/linuxbrew/.linuxbrew/opt  /usr/local/opt ## -f : force
     # sudo ln -s  /home/linuxbrew/.linuxbrew/include  /usr/local/include ## -f : force
    # sudo find /usr/local -maxdepth 1 -type l | awk '{print "sudo chown -R $MASTERUSER "$1}' > chown.run;. chown.run
    # f:            Opens current directory in Linux Finder
    alias f='xdg-open ./'
    READLINK="readlink"
    # JAVA_HOME="$OPT_PREFIX/jdk"
    # export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_101.jdk/Contents/Home/jre"
    # LTOFLAGS="-flto" # -m32 # -m64 
    alias make="make $MAKEJOBS"
    COLOR_FLAG="--color=auto"
    export BREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

### For MacOS/Darwin
if [ "$(uname -s)" == "Darwin" ]; then
    MACOSX_DEPLOYMENT_TARGET=$(sw_vers | grep ProductVersion | awk '{print $2}')
    export MACOSX_DEPLOYMENT_TARGET="$MACOSX_DEPLOYMENT_TARGET"
    # export MACOSX_DEPLOYMENT_TARGET=10.5
    PACORES=$(sysctl hw | grep hw.ncpu | awk '{print $2}')
    PACORES=$(( $PACORES * 2 ))
    UsrPATH="/Users"
     # f:            Opens current directory in MacOS Finder
    alias f='open -a Finder ./'                
    READLINK="greadlink"
    system_VER=64
    LTOFLAGS= # "-flto" #-m64"  # -m32 -fopenmp  -m64 -m32 
    JAVA_HOME=$(/usr/libexec/java_home)
    # COLOR_FLAG="--color=auto"
    export BREW_PREFIX="/usr/local"
    
    alias make="gmake $MAKEJOBS"
    alias uname="guname" ### To enable -o flag.
	alias find="gfind" ## [Waring Ignored] gfind: invalid argument `-1d' to `-mtime'
	alias time="gtime -v"
	alias tar="gtar"
	alias xargs="gxargs" ## Using GNU's xargs to enable -i feature.
    # export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home
    # export JAVA6_HOME="/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home"
    # export JAVA8_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre"

    ## Set default blocksize for ls, df, du
    ## IMPORTANT Check it by : diskutil info / | grep "Block Size"
    export BLOCKSIZE=4096
fi
export OPT_PREFIX="$BREW_PREFIX/opt"

## Universal workspace for two or more versions of macOS development
alias apps='cd /Volumes/data/Applications'
alias linkapps='ln -s /Volumes/data/Applications $(pwd)/apps'   
alias work='cd /Volumes/data/WorkSpace'
alias linkwork='ln -s /Volumes/data/WorkSpace $(pwd)/work'
alias bp3='python3 setup.py bdist > dist.log;python3 setup.py install'
# http://www.netlib.org/benchmark/hpl/results.html

#https://gcc.gnu.org/onlinedocs/gcc-4.5.3/gcc/i386-and-x86_002d64-Options.html

### DANGER : -mo-align-double <--- This CPU flag may cause non-executable 
# export CPUFLAGS="$GCC_FLAGS -msse2  -masm=intel -msse3 "
export MachineFLAGS="-mmmx -maes -msse -maes $LTOFLAGS $CPUFLAGS" # 
export MATHFLAGS=" -ffast-math -fno-signed-zeros -ffp-contract=fast $MachineFLAGS "
### DEFAULT FLAGS SUPPORT
##http://www.netlib.org/benchmark/hpl/results.html #-isystem /usr/include 
export CFLAGS="-Ofast -fomit-frame-pointer -funroll-loops $MATHFLAGS " 
# -isystem $BREW_PREFIX/include ## RISKY CFLAGS
export CXXFLAGS="$MATHFLAGS "
export FFLAGS="$CFLAGS "

### set gcc debug flag, Default is not to use it.
# DEBUGFLAG="-g"
alias cpx="cc -c $LDFLAGS $DEBUGFLAG $CFLAGS -Ofast -flto"

export ARCHFLAGS="-march=native"
# -arch x86-64 -arch i386  -Xarch_x86_64

case $system_VER in
    32)
        export LDFLAGS="$LDFLAGS"
        export FFLAGS="$FFLAGS"
        export CFLAGS="$CFLAGS " #$ARCHFLAGS
        export CPPFLAGS="$CPPFLAGS"
        # export LD_LIBRARY_PATH="/Developer/SDKs/MacOSX.sdk/usr/lib/gcc/i686-apple-darwin11/4.2.1/:$LD_LIBRARY_PATH"
    ;;
    64) # 
        export LDFLAGS="$LDFLAGS"
        export FFLAGS="$FFLAGS"
        export CFLAGS="$CFLAGS " #$ARCHFLAGS
        export CPPFLAGS="$CPPFLAGS"
        # export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/Developer/SDKs/MacOSX.sdk/usr/lib/gcc/i686-apple-darwin11/4.2.1/"
    ;;
    *)
        export LDFLAGS="$LDFLAGS"
        export FFLAGS="$FFLAGS"
        export CFLAGS="$CFLAGS $ARCHFLAGS"
        export CPPFLAGS="$CPPFLAGS"
        # export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"
    ;;
esac

## e2fslib support
# export PATH="$(brew --prefix e2fsprogs)/lib:$PATH"

## QT Support
## OpenCV3 Support
## CUDA SUPPORT ##
export PATH="/usr/local/cuda/bin:/usr/local/cuda/nvvm/bin:$PATH"
export LDFLAGS="-L/usr/local/cuda/lib -L/usr/local/cuda/nvvm/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/cuda/include -I/usr/local/cuda/nvvm/include $CPPFLAGS"

## graphviz support 
## openblas support
## brew install openblas
export OPENBLAS_NUM_THREADS=32

## llvm support
## brew reinstall llvm -v --all-targets --rtti --shared --with-asan --with-clang --use-clang
# export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib $LDFLAGS"
# export CPPFLAGS="-I/usr/local/opt/llvm/include $CPPFLAGS" 
# -I/usr/local/opt/llvm/include/c++/v1/  ## RISKY CPPFLAGS
export 

## rJava Support
#R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
#R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I$(/usr/libexec/java_home | grep -o '.*jdk')"

## Setting Locale
## locale
# https://www.gnu.org/savannah-checkouts/gnu/libc/manual/html_node/Locale-Categories.html

echo "________________________________________________________________________________"
uname -a
## Change CL to be colored for MAC
export CLICOLOR=1
export TERM="xterm-color" 

## Python include/lib support
PYVM_VER=python3.6m ## python3.6dm for debug
CPPFLAGS="-I/usr/local/opt/python3/include/$PYVM_VER $CPPFLAGS" 
LDFLAGS="-L/usr/local/opt/python3/lib $LDFLAGS"
CPPFLAGS="-I/usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/include/python3.6m $CPPFLAGS"
## GNU GCC support for OSX
## GNU GCC/ BINUTILS SUPPORT
## brew install binutils
# export PATH="$OPT_PREFIX/mingw-w64/bin:$PATH"
export MANPATH="$OPT_PREFIX/gnu-sed/libexec/gnuman:$MANPATH" ## man gsed for gnused
export MANPATH="$OPT_PREFIX/coreutils/libexec/gnuman:$MANPATH"
# export PATH="$OPT_PREFIX/coreutils/libexec/gnubin:$PATH"

## X11 Support
export PATH="/opt/X11/bin:$PATH"
export LDFLAGS="-L/opt/X11/lib $LDFLAGS"
export CPPFLAGS="-I$/opt/X11/include $CPPFLAGS"

## Android / Java src code   Support
# export PATH="$OPT_PREFIX/dex2jar/bin:$PATH"

## Rstudio Support
## brew install rstudio
export PATH="/Applications/RStudio.app/Contents/MacOS:$PATH"

## QT Setup
export PATH="$OPT_PREFIX/qt/bin:$PATH"

## MAC Developer Commandline Support
export PATH="/Library/Developer/CommandLineTools/usr/bin:$PATH"

##SWIFT SUPPORT
export PATH="/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:$PATH"

# TOMEE-PLUS
# export PATH="$PATH:$OPT_PREFIX/tomee-plus/libexec/bin"

# Node.js support
# REF: https://nodesource.com/blog/configuring-your-npmrc-for-an-optimal-node-js-environment/
export PATH="~/work/.npm/bin:$PATH"

# Android support on MAC
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:~/Library/Android/sdk/platform-tools
#android toolbox binary excutable 
export PATH=$PATH:~/Library/Android/sdk/tools

# Golang support / Blueprint Support # https://blue-jay.github.io/
# export JAYCONFIG=./env.json
export JAYCONFIG=$HOME/golang/bluejay_env.json
#/usr/local/go/bin
export GOPATH"=$HOME/golang"
export GOROOT="$OPT_PREFIX/go/libexec"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

# scala support in Intellij
export SCALA_HOME=$OPT_PREFIX/scala/idea

# Apache Spark Support  start-master.sh
# http://spark.apache.org/docs/latest/spark-standalone.html
# export PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/build
# export PYTHONPATH=/usr/local/lib/python3.6/site-packages
# export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
alias pip3="export PYTHONPATH=/usr/local/lib/python3.6/site-packages;pip3"
alias pypath3="export PYTHONPATH=/usr/local/lib/python3.6/site-packages"
alias pypath2="export PYTHONPATH=/usr/local/lib/python2.7/site-packages"
alias xpath="echo /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/"

SPARK_HOME="$OPT_PREFIX/apache-spark/libexec"
export PYSPARK_DRIVER_PYTHON=python3
# export PYSPARK_DRIVER_PYTHON_OPTS=notebook
export PATH="$PATH:$SPARK_HOME"
export PATH="$PATH:$OPT_PREFIX/apache-spark/libexec/sbin"

## Jupyter Notebook Support
# export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH

# Mysql Support
# alias mysql=/usr/local/mysql/bin/mysql
# alias mysqladmin=/usr/local/mysql/bin/mysqladmin
export PATH="$PATH:/usr/local/mysql/bin:$CASSANDRA_HOME/bin:$FORREST_HOME/bin"

# Tensorflow support on Mac OS X
# export TF_BINARY_URL=
# https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.3.0-py2-none-any.whl
# export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/mac/gpu/tensorflow_gpu-0.12.1-py3-none-any.whl
# https://pypi.python.org/packages/4f/8e/8f036b718c97b7a2a96f4e23fbaa55771686efaa97a56579df8d6826f7c5/tensorflow-1.3.0-cp36-cp36m-macosx_10_11_x86_64.whl
 
VG_TMPDIR=~/.tmp/openmpi ## For valgrind 
TMPDIR=~/.tmp/openmpi
BOOST_ROOT="/usr/local/opt/boost"
OpenMP_C_FLAGS=$CFLAGS
OpenMP_C_LIB_NAMES=
GNUTLS_CFLAGS=$CFLAGS

## Kubenate Support
# source $(brew --prefix)/etc/bash_completion
# source <(kubectl completion bash)
# [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt
#   ------------------------------------------------------------

# if [ $0 = "dash" ]; then
USER=$(id -un)
HOSTNAME=$(uname -n)
export PS1='________________________________________________________________________________
$(tput bold 6)$PWD $(tput setaf 6)@$HOSTNAME $(tput setaf 4)($USER)$(tput sgr0)
=>'
export SUDO_PS=$PS1
#fi

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
#  export CLICOLOR=1
#   export LSCOLORS=ExFxBxDxCxegedabagacad

#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------
# alias gtime='/usr/local/opt/gnu-time/bin/time'
# alias gmake='/usr/local/opt/make/bin/gmake'

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ls="ls $COLOR_FLAG"                   # Ensure ls will display color
alias ll='ls -FGlAhp $COLOR_FLAG'          # Preferred 'ls' implementation
alias sofu="du -d 1 * | sort -n -k1" ## Sort file using du , accending , --max-depth means -d

cd() { prevfolder=$(pwd);builtin cd "$@"; ll; } # Always list directory contents upon 'cd'
termfolder=$(pwd);
alias orig='cd $termfolder' ## Quick return to terminal-login folder
alias prev='cd $prevfolder' ## prev -- Quick switching between two folders.  2017/07/30

alias less='less -FSRXc'                    # Preferred 'less' implementation
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='/usr/bin/vi'                            # edit:         Opens any file in sublime editor
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias wwich='type -all'                     # wwich:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------
#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat

alias nofiles='echo "Total files in directory:" $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)
alias fsize="find . -type f -ls -printf '\0' | sort -zk7rn | tr -d '\0'" ## fsize  : find and sort file size, accending

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   extract:  Extract most know archives with one command
#   https://www.systutorials.com/docs/linux/man/1-lz4/
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.lz4)   unlz4dir $1        ;;
            *.tar.xz)    tar xf $1      ;;
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
			*.xz)	     xz -d $1		;;
            *.7z)        7z x $1        ;;
            *.lz4)       unlz4 $1       ;;
            *.lzma)      tar --lzma -xvf f $1 ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

alias qfind="find . -name "        # qfind:    Quickly search for file
function ff () { find . -name "$@" ; }      # ff:       Find file under the current directory
function ffs () { find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
function ffe () { find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string
function gftype() {
    echo "[Info] This support you to grep certian filename suffix"
    echo "[Usage] 'find . | gftype log' to find all *.log"
    grep ".*\."$1"$"
}

function findcp() {
    echo "[Info] findmv, Generate a script for copy ONLY files in CURRENT folder to another folder"
    echo "args1 : new folder name"
    echo '[Question] Starts ? (yes / others for skip)' 
    read option 
    case $option in
            yes)
                find . -maxdepth 1 -type f  -print0 | ffilter | xargs -n 1 -P $PACORES  -0 -I'{}' cp '{}' $1
            ;;
            *)
                echo "find . -maxdepth 1 -type f -print0 | ffilter | xargs -n 1 -P $PACORES  -0 -I'{}' cp '{}' $1"
            ;;
    esac
}
#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------
#   findpid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   Example : findpid bash
#   -----------------------------------------------------
    alias findpid="lsof -t -c"

## This script helps you find out the pid of a process on specific port
## Example : portid 80
    function portid () { 
     sport="$@"
     lsof -i:$sport
     echo "------"
     echo "Port:"$sport",PID=" $(lsof -i:$sport | grep $(whoami) | awk '{print $2}');
    }
    # function ppid() { 
    #   echo $! >test.pid | cat test.pid 
    # }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   myps: List processes owned by my user:
#   ------------------------------------------------------------
    function myps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

alias servall='sudo kill $(lsof -t -i:80,443,8080)&& echo "Killed processs on 80,443,8080"' # Reset all Http ports
alias netconns='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }


#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------
    alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

#   ---------------------------------------
#   8.  WEB DEVELOPMENT
#   ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs

# httpHeaders:      Grabs headers from web page
# example : httpHeaders www.google.com
alias httpHeaders="/usr/bin/curl -I -L"            
# httpDebug:  Download a web page and show info on what took time
function httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }


#   ---------------------------------------
#   9.  REMINDERS & NOTES
#   ---------------------------------------

#   remove_disk: spin down unneeded disk
#   ---------------------------------------
#   diskutil eject /dev/disk1s3

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

##### Dropbox_shell integration #####
#Looking for dropbox uploader
# if [ -f "./dup.sh" ]; then
#     DU="./dup.sh"
# else
#     DU=$(which dup.sh)
#     if [ $? -ne 0 ]; then
#         echo "Dropbox Uploader not found!"
#         return 1
#     fi
# fi

DU=/usr/local/bin/dup.sh


SHELL_HISTORY=~/.dropshell_history ##  .dropbox_uploader 
DU_OPT="-q"
DU_VERSION="0.2"

umask 077

#Dependencies check
# BIN_DEPS="id $READLINK ls basename ls pwd cut"
# for i in $BIN_DEPS; do
#    which $i > /dev/null
#    if [ $? -ne 0 ]; then
#        echo -e "Error: Required program could not be found: $i"
#        return 1
#    fi
# done

#Check DropBox Uploader
if [ ! -f "$DU" ] ; then
    echo "Dropbox Uploader not found: $DU"
    echo "Please change the 'DU' variable according to the Dropbox Uploader location."
else
    DU=$($READLINK -m "$DU")
fi

alias normalize_path="$READLINK -m"

################
#### START  ####
################
history -r "$SHELL_HISTORY"
username=$(id -nu) ##  or $(whoami)

#Initial Working Directory
function dls {
    local arg1=$1

    #Listing current dir
    if [ -z "$arg1" ]; then
        "$DU" $DU_OPT list "$CWD"

    #Listing $arg1
    else

        #Relative or absolute path?
        if [ ${arg1:0:1} == "/" ]; then
            "$DU" $DU_OPT list "$(normalize_path "$arg1")"
        else
            "$DU" $DU_OPT list "$(normalize_path "$CWD/$arg1")"
        fi

        #Checking for errors
        if [ $? -ne 0 ]; then
            echo -e "ls: cannot access '$arg1': No such file or directory"
        fi
    fi
}

function dcd {
    local arg1=$1

    OLD_CWD=$CWD

    if [ -z "$arg1" ]; then
        CWD="/"
    elif [ ${arg1:0:1} == "/" ]; then
        CWD=$arg1
    else
        CWD=$(normalize_path "$OLD_CWD/$arg1/")
    fi

    "$DU" $DU_OPT list "$CWD" > /dev/null

    #Checking for errors
    if [ $? -ne 0 ]; then
        echo -e "cd: $arg1: No such file or directory"
        CWD=$OLD_CWD
    fi
}

function dget {
    local arg1=$1
    local arg2=$2

    if [ ! -z "$arg1" ]; then
        #Relative or absolute path?
        if [ ${arg1:0:1} == "/" ]; then
            "$DU" $DU_OPT download "$(normalize_path "$arg1")" "$arg2"
        else
            "$DU" $DU_OPT download "$(normalize_path "$CWD/$arg1")" "$arg2"
        fi
        #Checking for errors
        if [ $? -ne 0 ]; then
            echo -e "get: Download error"
        fi
    #args error
    else
        echo -e "get: missing operand"
        echo -e "syntax: get <FILE/DIR> [LOCAL_FILE/DIR]"
    fi
}

function dput {
    local arg1=$1
    local arg2=$2

    if [ ! -z "$arg1" ]; then

        #Relative or absolute path?
        if [ "${arg2:0:1}" == "/" ]; then
            "$DU" $DU_OPT upload "$arg1" "$(normalize_path "$arg2")"
        else
            "$DU" $DU_OPT upload "$arg1" "$(normalize_path "$CWD/$arg2")"
        fi

        #Checking for errors
        if [ $? -ne 0 ]; then
            echo -e "put: Upload error"
        fi

    #args error
    else
        echo -e "put: missing operand"
        echo -e "syntax: put <FILE/DIR> <REMOTE_FILE/DIR>"
    fi
}

function drm
{
    local arg1=$1

    if [ ! -z "$arg1" ]; then

        #Relative or absolute path?
        if [ ${arg1:0:1} == "/" ]; then
            "$DU" $DU_OPT remove "$(normalize_path "$arg1")"
        else
            "$DU" $DU_OPT remove "$(normalize_path "$CWD/$arg1")"
        fi

        #Checking for errors
        if [ $? -ne 0 ]; then
            echo -e "rm: cannot remove '$arg1'"
        fi

    #args error
    else
        echo -e "rm: missing operand"
        echo -e "syntax: rm <FILE/DIR>"
    fi
}

function dmkdir
{
    local arg1=$1

    if [ ! -z "$arg1" ]; then

        #Relative or absolute path?
        if [ ${arg1:0:1} == "/" ]; then
            "$DU" $DU_OPT mkdir "$(normalize_path "$arg1")"
        else
            "$DU" $DU_OPT mkdir "$(normalize_path "$CWD/$arg1")"
        fi

        #Checking for errors
        if [ $? -ne 0 ]; then
            echo -e "mkdir: cannot create directory '$arg1'"
        fi

    #args error
    else
        echo -e "mkdir: missing operand"
        echo -e "syntax: mkdir <DIR_NAME>"
    fi
}

function dmv
{
    local arg1=$1
    local arg2=$2

    if [ ! -z "$arg1" -a ! -z "$arg2" ]; then

        #SRC relative or absolute path?
        if [ ${arg1:0:1} == "/" ]; then
            SRC="$arg1"
        else
            SRC="$CWD/$arg1"
        fi

        #DST relative or absolute path?
        if [ ${arg2:0:1} == "/" ]; then
            DST="$arg2"
        else
            DST="$CWD/$arg2"
        fi

        "$DU" $DU_OPT move "$(normalize_path "$SRC")" "$(normalize_path "$DST")"

        #Checking for errors
        if [ $? -ne 0 ]; then
            echo -e "mv: cannot move '$arg1' to '$arg2'"
        fi

    #args error
    else
        echo -e "mv: missing operand"
        echo -e "syntax: mv <FILE/DIR> <DEST_FILE/DIR>"
    fi
}

function dcp
{
    local arg1=$1
    local arg2=$2

    if [ ! -z "$arg1" -a ! -z "$arg2" ]; then

        #SRC relative or absolute path?
        if [ ${arg1:0:1} == "/" ]; then
            SRC="$arg1"
        else
            SRC="$CWD/$arg1"
        fi

        #DST relative or absolute path?
        if [ ${arg2:0:1} == "/" ]; then
            DST="$arg2"
        else
            DST="$CWD/$arg2"
        fi

        "$DU" $DU_OPT copy "$(normalize_path "$SRC")" "$(normalize_path "$DST")"

        #Checking for errors
        if [ $? -ne 0 ]; then
            echo -e "cp: cannot copy '$arg1' to '$arg2'"
        fi

    #args error
    else
        echo -e "cp: missing operand"
        echo -e "syntax: cp <FILE/DIR> <DEST_FILE/DIR>"
    fi
}

function dfree
{
    "$DU" $DU_OPT info | grep "Free:" | cut -f 2
}

function dhelp 
{
            echo -e "Supported commands: dls, dcd, dpwd, dget, dput, dcat, drm, dmkdir, dmv, dcp, dfree, dlls, dlpwd, dlcd, help, exit\n"
      return 1
}

function dcat
{
    local arg1=$1

    if [ ! -z "$arg1" ]; then

        tmp_cat="/tmp/sh_dcat_$RANDOM"
        dget "$arg1" "$tmp_cat"
        cat "$tmp_cat"
        rm -rf "$tmp_cat"

    #args error
    else
        echo -e "cat: missing operand"
        echo -e "syntax: cat <FILE>"
    fi
}
### Tensorboard Support ###
function tengo() {
    tensorboard --host 127.0.0.1 --logdir="$@" &
    open http://127.0.0.1:6006
}

function tenx() {
    kill $(! lsof -i:6006 | grep localhost:6006 |awk '{print $2}' )
}

### HADOOP SERVER COMMANDS###
export HADOOP_HOME="$OPT_PREFIX/hadoop"
export HADOOP_SBIN="$OPT_PREFIX/hadoop/sbin"
export HADOOP_CONFIG="$OPT_PREFIX/hadoop/libexec/etc/hadoop"

function hstart() { 
    echo "[Info] hstart, Function to start hadoop server in brew"
    $HADOOP_SBIN/start-dfs.sh;$HADOOP_SBIN/start-yarn.sh
}

function hstop() {
    echo "[Info] hstop, Function to stop hadoop server in brew"
    $HADOOP_SBIN/stop-yarn.sh; $HADOOP_SBIN/stop-dfs.sh
}

function hcl() {
    echo "[Info] hcl, Function to show hadoop config list in brew"
    ls -l $HADOOP_CONFIG | grep xml
     echo "Hadoop Config Folder : "+HADOOP_CONFIG
}

function cmacabi() { 
    ## Check whether you are booting in 64bit firmware
    ## http://www.hackaapl.com/forcing-snow-leopard-os-x-to-boot-64-bit-kernel/
    ioreg -l -p IODeviceTree | grep firmware-abi
}

function ccpu () {
    echo "[Info] ccpu, Function to show the cpu's strength"
    if [ "$(uname -s)" == "Linux" ]; then
            /bin/cat /proc/cpuinfo &&
            lscpu
    elif [ "$(uname -s)" == "Darwin" ]; then
           system_profiler SPHardwareDataType
           sysctl -n machdep.cpu.brand_string
           sysctl hw && 
           system_profiler >> sysinfo && ## This command takes a long time
           echo "> cat sysinfo < to see result"
    fi
}


function cpci() {
	ls -Ral /sys/devices/pci*

}

function cgpu () {
    echo "[Info] cgpu, Function to show the gpu's strength"
    if [ "$(uname -s)" == "Linux" ]; then
            lspci  -v -s  $(lspci | grep VGA | cut -d" " -f 1) 
            ## For Nvidia
            nvidia-smi
            nvidia-smi -q
            ## Other tools
            clinfo
    elif [ "$(uname -s)" == "Darwin" ]; then
           glxinfo > gpuinfo && cat gpuinfo
           echo "> cat gpuinfo < to see result"
    fi
}

function cefi() {
    echo "[Info][MacOS] cefi, Show the running EFI version to be 64 bit or 32bit"
    ioreg -l -p IODeviceTree | grep firmware-abi
}

function kweb () {
    echo "[Info] kweb, Function to close port 8080"
    arg1=$(sudo lsof -t -i:8080)
    sudo kill $arg1 && echo "Killed processs on" $1
}

function rcf () {
    echo "[Info] rcf, Function to find rows and columns of a file, delimitor is a space ' '' "
    echo File name: $1
    awk '{ print "Rows : "NR"\nColumns : "NF }' $1
}

function find01() {
	echo "[Info] find01, Function to find number of 0 and 1 in a file"
	awk '/0/{zero++} /1/{one++} END{printf "0: %d\n1: %d\n", zero, one}' "$@"
}

function insertLine() {
	echo "[Info] insertLine, Add newText to the file from nthLine"
	echo "[Args] #1 file @2 line @3 newText"
    local file="$1" 
    local lineX="$2" 
    local newText="$3"
    sed -i -e "/^$lineX$/a"$'\\\n'"$newText"$'\n' "$file"
}

function transfile () {
    echo "[Info] transfile, Function that transverse a file."
	awk '{
	    if(NR==1) {
	        for(i=1;i<=NF;i++) {
	            arr[i] = $i
	        }
	    } else {
	        for(i=1;i<=NF;i++) {
	            arr[i] = arr[i]" "$i
	        }
	    }
	}
	END {for(i=1;i<=NF;i++) {
	    print arr[i]
	}}'  $1
}

function arrys () {
     echo "[Info] arrys, Function that Generate a random Integer array"
    num_rows=$1
    num_columns=$2

    for ((i=1;i<=num_rows;i++)) do
        for ((j=1;j<=num_columns;j++)) do
            matrix[$i,$j]=$RANDOM
        done
    done
    f1="%$((${#num_rows}+1))s"
    f2=" %9s"
    printf "$f1" ''
    for ((i=1;i<=num_rows;i++)) do
        printf "$f2" $i
    done
    echo
    for ((j=1;j<=num_columns;j++)) do
        printf "$f1" $j
        for ((i=1;i<=num_rows;i++)) do
            printf "$f2" ${matrix[$i,$j]}
        done
        echo
    done
}

function createswap () {
    echo "[Info][Linux] creatswap, Function that create swap for linux based system"
    sudo mkdir -p /var/cache/swap/
    sudo dd if=/dev/zero of=/var/cache/swap/swap0 bs=1M count=1000
    sudo chmod 0600 /var/cache/swap/swap0
    sudo mkswap /var/cache/swap/swap0 
    sudo swapon /var/cache/swap/swap0
}

## Port Scann for specific IP
function allport() {
    nmap -Pn $1 >> ps_reports&
}

## Show Kernal's Threads Counts // MAC only
function cthreads () {
    sysctl  -A | grep thread
    if [ "$(uname -s)" == "Darwin" ]; then
        sysctl kern.maxproc
        sysctl kern.maxvnodes
        sysctl kern.maxfiles
    fi
}

## https://en.wikipedia.org/wiki/Netcat
## Test all connection avaiable of an ip or host address
function ports() {
	nc -vzu "$@" 1-65535 > ports_"$@"
	cat ports_"$@"
}

########################################
## Netcat Info -- IPV4                ##
##https://en.wikipedia.org/wiki/Netcat##
########################################
## IPV6 VERSION https://www.freebsd.org/cgi/man.cgi?query=nc6&sektion=1&apropos=0&manpath=FreeBSD+9.0-RELEASE+and+Ports

## Redirect localhost:99 to google:443
function p2google() {
	open http://localhost:12345/
	ncat -l 12345 -c 'nc www.nthu.edu.tw 80'
}

## Example : nc for file transfer
function ncfile() {
	cat "$@" | nc -l 3333  & ## (on server, file sender) 
	nc localhost 3333 > "$@"_data.get & ##(on client, file receiver)
	cat  "$@"_data.get
}

## Example : Share index.html for only once.
function ncwebshot() {
	 { printf 'HTTP/1.0 200 OK\r\nContent-Length: %d\r\n\r\n' "$(wc -c < index.html)"; cat index.html; } | nc -l 8080
}

function ncclient() {
	local IP="127.0.0.1"
	local PORT="8877"
	local SHARED_SECRET="RalicLo"

	OPENSSL=$( wwich openssl | awk '{print $3}')
	OPENSSL_CMD="$OPENSSL enc -a -A -aes-256-gcm"

	while IFS= read -r MSG; do
		echo "$MSG" | $OPENSSL_CMD -e -k "$SHARED_SECRET"
		echo
	done | \
	nc "$IP" "$PORT" | \
	while IFS= read -r REC; do
		echo "From Server: $(echo "$REC" | $OPENSSL_CMD -d -k "$SHARED_SECRET")"
	done
}

function ncserver() {
	local IP="127.0.0.1"
	local PORT="8877"
	local SHARED_SECRET="RalicLo"

	OPENSSL=$( wwich openssl | awk '{print $3}')
	OPENSSL_CMD="$OPENSSL enc -a -A -aes-256-gcm"

	while IFS= read -r MSG; do
		echo "$MSG" | $OPENSSL_CMD -e -k "$SHARED_SECRET"
		echo
	done | \
	nc -l "$PORT" | \
	while IFS= read -r REC; do
		echo "From Client: $(echo "$REC" | $OPENSSL_CMD -d -k "$SHARED_SECRET")"
	done
}

## No wiresharks sniffing
function nosharks() {
	mkdir -p ~/.cache > /dev/null
	local eIN=~/.cache/eIn;mkfifo $eIN
	local eOUT=~/.cache/eOut;mkfifo  $eOUT
	nc -l 995 -k > $eIN < $eOUT &
 while true; do
  openssl s_client -connect www.google.com:443 -quiet < $eIN > $eOUT
 done
 	echo "[Info] Using Port 995 to proxy ssl connection for sniffing prevention"
}

## Show Word counts in a file
## Usage  : mywc Filename
## Author : Ralic Lo
function mywc() {
     # Firt two methods are high memory usage
     # cat $1 |tr ' ' '\n' | sort | uniq -c | awk '{print $2" "$1}'
     # cat $1 | tr [:space:] '\n' | grep -v "^\s*$" | sort | uniq -c |sort -r 
     awk '{for(w=1;w<=NF;w++) print $w}' $1 | sort | uniq -c | sort -nr | awk '{print $2" "$1}'
}

### bc : simple calculator
# https://en.wikipedia.org/wiki/Bc_(programming_language)
## Example :   a=10;calc? $a+3*5
function calc () {
	bc -l <<<  "$@"
}
## Check memory leak in a process() 
## Requirement : brew install valgrind 
## Example :  leak? ls -l
function leak? () {
	valgrind --leak-check=yes "$@"
}

## GET IPs from log file.
## Usage  : iplog Filename
## Author : Ralic Lo
function iplog() {
    mywc $1 | grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}.*"  > logs
    cat logs | gawk -F " " '{print $1}'
    echo "[Info]  cat ip_logs for ip counts"
    echo "[Usage] Find log entries from the same IP"
}

function mip() {
    mkdir mip
    z=$(wc -l ips| awk '{print $1}')
    zbak=$z
    zz=0
    while [ $z -gt 0 ] 
    do
        ((z--))
        # echo $z  ## for debug only
        cat ips | awk '{print "ipinfo " $1 " &&"}' > ./mip/mip.log
        echo 'echo [INFO]  ALL Task COMPLETED ' >> ./mip/mip.log
        . ./mip/mip.log  &&
        ((zz= $z % 50))
        # echo $zz ## for debug only
        while [ $zz -eq 1 ]
        do  
            # echo '[INFO] Created 50 PIDs,  sleep 1 sec'
            # sleep 1 ## for debug only
            zz=0
        done
    done
    # sleep 60 && echo [INFO] Task mip COMPLETED &
    echo $zbak ## for debug only
}

## This script finds possible server ip address
## Usage : cip www.example.com
## Author: Ralic Lo

function cip () {
    local z=10000
    local zz=0
    while [ $z -gt 0 ] 
    do
        ((z--))
        #echo $z
        dig -n $1 | grep IN | awk '{print $5}' >> tester 
        ((zz= $z % 50))
        while [ $zz -eq 1 ]
        do
            cat tester | sort | uniq > tester2
            zz=0
            yes|cp tester2 tester
        done
    done
}
## Encrypt file with password
## Usage cry filename password 
## Author : Ralic Lo
function cry() {
    openssl aes-256-cbc -a -salt -in $1 -out cry.out ## -k $2
    echo "Target File: " $1 " encrypted as cry.out"
}

## Decrypt file with password
## Usage dontcry filename password 
## Author : Ralic Lo
function dncry() {
    openssl aes-256-cbc  -d -a -in $1 -out dncry.out ##-k $2
    echo "Target File: " $1 " decrypted as dncry.out"
}

## This script allows you to upload files to mega storage
## Usage : runmega , . megad2  , . megaf2
## Author: Ralic Lo
function runmega() { 
    find . -type d | sort| uniq | awk '{print "megacmd mkdir mega:/test/"$1" &"}' > megad
    cat megad > megad2
    find . | sort | uniq | sed 's/^.\{1\}//g'| awk '{print "megacmd put ."$1" mega:/test"$1}' > megaf
    cat megaf > megaf2
    rm megaf
    rm megad
}


## $1 weblink 
function curls() { 
	mkdir -p ~/.cache
	local curlink=$1
	curl $curlink > ~/.cache/curls.log
	cat ~/.cache/curls.log | greplinks >curls.out
	cat curls.out
}

function greplinks() {
	grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
	sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' 
}
## Cordova Plguin AddOn Function
function cpas() {
	declare -a cordovaPlugins=(
         ### Plugins https://goo.gl/eHEJwm
         ## http/browser
        "cordova-plugin-broadcaster"
        "cordova-plugin-http"
        "cordova-customplugin-inappbrowser"
         ## camera / Automatic License Plate Recognition 
        "cordova-plugin-camera"
        #"cordova-plugin-openalpr"
         ## audio/ Automatic speech recognition / NLP 
        "cordova-plugin-audiotoggle"
        "cordova-plugin-speechrecognition"
        "cordova-plugin-apiai"
         ## bluetooth /wifi
        "cordova-plugin-bluetoothle"
        "cordova-plugin-ble-central"
        "cordova-plugin-ble"
        "cordova-plugin-wifiinfo"
         ## Sensors / Gyro / GPS /Google Map
        "cordova-plugin-geolocation"
        "cordova-plugin-gyroscope"
        # "cordova-plugin-sso-facebook"
        # "cdv-googlemaps"
         ## IOT Connectivity
        "cordova-plugin-blinkup "
         ## Barcode 
        "manateeworks-barcodescanner-v3"
         ## Contact Books
        "cordova-plugin-contacts-phonenumbers"
         ## OpenCV
        #"cordova-plugin-image-detection"
    )
	local N_CPAs=$((${#cordovaPlugins[@]}))
    echo "Total Cordova libs  = " $N_CPAs
    echo "" > ~/.cache/CordovaLibs.db 
   	while [ $((N_CPAs )) -gt 0 ]   ;
    do
    	N_CPAs=$((N_CPAs-1))
	    echo "${N_CPAs} ${cordovaPlugins[$N_CPAs]}" >> ~/.cache/CordovaLibs.db
	    echo "[Info] cordova plugin add  ${cordovaPlugins[$N_CPAs]}"
	    cordova plugin add  ${cordovaPlugins[$N_CPAs]}
	done
	cat ~/.cache/CordovaLibs.db
}


## Prerequesite : cios, cadnd
## Author: Ralic Lo

function capp () {
    echo "[Info] : capp, This script help you build ios and android app easier."
    echo "options: cordova | reacts | (get)mobile | (cfav)icon"
    read option
    case $option in 
        get)
            getmobile
        ;;
        cordova)
        #REF https://github.com/wymsee/cordova-HTTP
        cordova create myApp
        cd myApp
        cordova platform add ios
        cordova platform add android

        
        ## Default Icon from Rstudio.
        curl https://www.rstudio.com/wp-content/uploads/2014/06/RStudio-Ball.png >icon.png
        cordova-icon
        cordova build
        ;;
        reacts)
        reacts
        ;;
        cfav)
         ## Default Icon from Rstudio.
        curl https://www.rstudio.com/wp-content/uploads/2014/06/RStudio-Ball.png >icon.png
        cordova-icon
        curl http://www.iloveheartstudio.com/_cat/1500/world/continents/far-east/taiwan.png >splash.png
        cordova plugin add cordova-plugin-splashscreen-iphoneX-support
        # cordova-splash
        ;;
    esac
}


## Reference : 
## https://ccoenraets.github.io/cordova-tutorial/build-cordova-project.html
## This script allows you to use cordova-cli to run ios project
## Usage : getmobile
## Author: Ralic Lo

function getmobile() {
            brew update && brew upgrade
            brew install git nodejs watchman flow android-sdk android-platform-tools
            npm install concurrently json express graceful-fs shelljs react react-native hammer -g
            #npm --depth Infinity update
            ## favicon splash support
            npm install cordova-icon -g
            npm install cordova-splash -g
            brew install imagemagick
}

## This script allows you to generate icon/flash for cordova development
## Prerequesite : Execute under a cordova project root directory
## Author: Ralic Lo
function cicon() {
        echo Generating Icons and Splash from App root, icon.png, splash.png
        curl https://www.rstudio.com/wp-content/uploads/2014/06/RStudio-Ball.png >icon.png
        cordova-icon
        curl http://www.iloveheartstudio.com/_cat/1500/world/continents/far-east/taiwan.png >splash.png
        cordova-splash
}

## Usage : cios
## Prerequesite : Execute under a cordova project root directory
## Author: Ralic Lo

function cios() {
    cordova platform add ios
    cordova emulate ios -list
    cordova emulate ios --target="iPhone-6, 9.3"
}

## Usage : cadnd
## Prerequesite : Execute under a cordova project root directory
## Author: Ralic Lo

function cadnd() {
    echo "[Info] cadnd, This script allows you to use cordova-cli to run android project"
    echo "options: new | run"
    read option
    case $option in 
        new)
            cordova platform add android
            cordova build android
        ;;    
        run)
            cordova run android
        ;;
        *)
        echo "Use Geny to start an android simulator"
        echo "If Error: Unknown platforms: andriod, please type 'cordova platform add android'"
        ;;
    esac
}
 
## Usage : reacts , choose option
## Prerequesite : node.js, npm , XCode , Android Studio, Android Build Tools 23.0.1
## Author: Ralic Lo
function reacts () {
    echo "[Info] reacts, This script allows you to use react-native cli to run android project"
    echo "options : (setup) | (install) | (init) | (web) | (ios) | (android)"
    read option
    case $option in 
        setup)
            echo "[Info] Install React-native-cli"
            npm install -g react-native-cli
            echo "[Info] Install Suitable Android build tools"
            android list sdk -a 
            version=$(android list sdk -a | grep 23.0.1 | awk '{print substr ($1,0,1)}')
            android update sdk -a -u -t $version
            unset verion
        ;;
        init)
            echo "[Info] Initiate React-Native Project"
            react-native init reactApp
        ;;
        web)
            echo "cd reactApp"
            echo "react-native start&"
            echo "open http://localhost:8081"
            cd reactApp
            react-native start &
            sleep 1
            open http://localhost:8081
        ;;    
        ios)
            cd reactApp
            react-native run-ios
        ;;
        android)
            cd reactApp
            react-native run-android
        ;;
        *)
        ;;
    esac
}

function rise() {
	echo "[Info] rise, run react-native apps"
    echo "options : (ios) | (android)"
    read option
    case $option in 
		ios)
            cd reactApp
            react-native run-ios
        ;;
        android)
            cd reactApp
            react-native run-android
        ;;
        *)
        ;;
    esac
}

## Prerequesite : Must have genymotion installed
## Author: Ralic Lo
function geny(){
    echo "[Info] geny, This script allows you to use cordova-cli to run ios project on Mac"
    #Alternative android avd
    #REF: https://facebook.github.io/react-native/docs/android-setup.html
    open /Applications/Genymotion.app
}


## This script allows you to update github master 
## Usage : Use it carefully.., under Development
## Author: Ralic Lo
function goes6(){
    ## require json /nodejs installed.
    cat package.json | json repository.url > git.origin
    # echo "git init" > es6.run
    echo "git add -f *" > es6.run
    echo 'git commit -m "ES6-Syntax Update"'>> es6.run
    # echo 'git remote remove origin'>> es6.run
    echo "git remote add origin https://github.com/ralic/${PWD##*/}" >> es6.run
    # echo "git request-pull" $(cat git.origin) master>> es6.run
    echo "git push origin master" >>es6.run
    cat es6.run
}

## This script redirect unwanted traffic on your ssh port 
## Usage : Use it carefully.. , works for CentOS/RedHat system
## Author: Ralic Lo
function redIP() {
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    # sysctl net.ipv4.ip_forward=1
    iptables -t nat -A PREROUTING -s $1 -p tcp --dport 22 -j DNAT --to-destination $1
    ################################ IP ############# PORT ######################  IP
}

## This script helps to setup docker on macOS
## For macOS
## Author: Ralic Lo
function ddocker () {
    echo "------"
    echo [Info] If you have not installed docker "brew install docker-machine docker-compose" 
    echo [Info] If you have not installed virtualbox "brew install cask virtualbox" 
    echo [Info] Use dm to access docker machine "alias dm=docker-machine" 
    echo [Info] Use dm to create default virturl box "dm create -d virtualbox default" 
    echo [Info] Use dm to create default virtual box for kaggle "docker-machine create -d virtualbox --virtualbox-disk-size  160000  --virtualbox-memory 4096 default"
    echo [Info] Use dm to access docker machine "dm start default" 
    echo [Info] Use dm to list docker machine "dm ls" 
    echo [Info] Use dm to stop docker machine "dm stop" 
    echo [Info] For Kaggle : 'docker pull kaggle/rstats:latest'
    echo [Info] For Kaggle : 'docker run -it -p 8787:8787 --rm -v $UsrPATH/mchirico/Dropbox/kaggle/death:/tmp/working  kaggle/rstats /bin/bash -c "rstudio-server restart & /bin/bash"'
    echo "------"
    alias dm=docker-machine
    sudo docker-machine ls
    sudo docker-machine env
    sudo eval $(docker-machine env default)
}

## This script helps to initial Electron Desktop application (from Github) 
## Usage : ec <filename> 
## For macOS , Installed Electron
## Author: Ralic Lo
function ec () {
    # Download and install Electron here --  http://electron.atom.io/
    ## Check software version
    if [ "$(sw_vers -productName)" == "Mac OS X" ]; then
    $UsrPATH/$(id -un)/work/electron-api-demos/node_modules/electron-prebuilt/dist/Electron.app/Contents/MacOS/Electron "$@"
    fi
}

function composer () {
if [[ $# -eq 0 ]] ; then
    echo "[Error] No arguments."
    return 0
fi
    # https://getcomposer.org/download/
    php /usr/local/bin/composer.phar "$@"
}

## This script helps to initiate and connect a postgreSQL database
## For macOS , Installed Electron
## Author: Ralic Lo

function pgstart () {
echo [Info] "brew install postgresql"
echo [Info] Start  Database Server : "postgres -D /usr/local/var/postgres &"
echo [Info] Create Database : "createdb mydb "
echo [Info] Drop   Database : "drop mydb "
echo [Info] Enter  Database : "psql mydb "
echo [Info] Check Configuration : "cat /usr/local/var/postgres/postgresql.conf"

postgres -D /usr/local/var/postgres &
psql mydb
}

## This script helps to bootstrap scala compile/test
## Usage : ssrun <filename> 
## Author: Ralic Lo

function ssrun () {
## Exit if no args.
if [[ $# -eq 0 ]] ; then
    echo [Info] Compile : "scalac HelloWorld.scala"
    echo [Info] Run : "scala -cp . HelloWorld" # Default cp="class path" doesn't include current folder
    echo [Info] ADD CLASSPATH : "export CLASSPATH=$CLASSPATH:."
    echo [Info] Usage : "ssrun filename"
    echo "------"
    # REF : http://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html
    echo [Info] Look Into the class : "javap HelloWorld" 
    # REF : http://www.scala-lang.org/files/archive/nightly/docs/manual/html/scalap.html
    echo [Info] Usage : "scalap HelloWorld"
    # REF :https://github.com/kwart/jd-cmd
    echo "------"
    echo [Error] No arguments.
    return 0
fi
 echo "[Result/Runned]"
 scalac "$@".scala
 echo "------"
 echo "[Decoder]"
 scala -cp . "$@"
 scalap -version "$@"
 javap -sysinfo -c "$@"
}

function jdcli () {
    export DIRNAME=/usr/local/Cellar/jd-gui/1.5.1
    java -jar "$DIRNAME/jd-gui-1.5.1.jar" $@ 
}

## This script helps to bootstrap speak/translate service
## Author: Ralic Lo
## OS: macOS 
## REQUIREMENT-1: brew install gawk rlwrap curl 
## REQUIREMENT-2:  https://github.com/soimort/translate-shell
## Install Script: 
## wget https://www.soimort.org/translate-shell/trans; chmod 750 trans; mv trans /usr/local/bin
## https://www.soimort.org/translate-shell/#installation

## Better Voice
## https://github.com/espeak-ng/espeak-ng/blob/master/docs/mbrola.md

function gspeak() {
## Exit if no args.
if [[ $# -eq 0 ]] ; then
    echo "--Google translate in command line----"
    echo [Info] "--shell"   : "Shell interface"
    echo [Info] ":en"      : "Translate to English(default)"
    echo [Info] ":zh"      : "Translate to Chinese"
    echo [Info] ":ja"      : "Translate to Japanese"
    echo [Info] "-b"       : "brief mode"
    echo [Error] No arguments.
    return 0
fi
echo "------"
trans "$@" ## trans is enabled after install translate-shell
echo "------"

espeak -vzh+f2 -s 200 "$1"
}

## This script helps to speak a file to mp3
## Author: Ralic Lo
## OS: macOS 
## REQUIRED: brew install espeak ffmpeg
## REF : http://espeak.sourceforge.net/commands.html
## REF : http://askubuntu.com/questions/178736/generate-mp3-file-from-espeak
## Teacher REF : https://en.wikipedia.org/wiki/Comparison_of_speech_synthesizers

function fspeakm() {
if [[ $# -eq 0 ]] ; then
    echo [Info] "Speak in Male Voice"
    echo [Error] No arguments.
    return 0
fi
## Speak in m4 tone, 200 words 
espeak -vzh+m4 -s 125 -f "$@"
}

function fspeakf() {
if [[ $# -eq 0 ]] ; then
    echo [Info] "Speak in Female Voice"
    echo [Error] No arguments.
fi

espeak -vzh+f2 -s 200 -f "$@"
}

function speakmp3() {
if [[ $# -eq 0 ]] ; then
    echo [Info] "speak to mp3... Male Voice"
    echo [Error] No arguments.
fi
    rm male.mp3
    rm female.mp3
    fspeakm "$@" --stdout | ffmpeg -i - -ar 44100 -ac 2 -ab 192k -f mp3 male.mp3 
    fspeakf "$@" --stdout | ffmpeg -i - -ar 44100 -ac 2 -ab 192k -f mp3 female.mp3 
}


## Get ip_geoinfo
## Usage : ipinfo filename
## Author: Ralic Lo

function ipinfo() {
        echo '{"ip":"'$1'"'> ipgeo.json
        curl "http://addgadgets.com/ipaddress/index.php?ipaddr=$1" |
        grep -E "Country.*<\/td>|Latitude.*<\/td>|Longitude.*<\/td>" |
        sed 's/<[^>]*>/"/g' |
        sed 's/""/"/g'|
        sed 's/ /_/g'|
        sed 's/:&nbsp;/":/g'|
        sed 's/^/,/'  >> ipgeo.json
        echo '}' >> ipgeo.json
        cat ipgeo.json  
}


## This script helps to provide google map direction service query
## Usage : gdir "first-location" "second-location"
## Author: Ralic Lo

function gdir() {
    if [[ $# -eq 2 ]] ; then
    #npm i google-maps-direction-cli -g
    #Example direction "taoyuan" "taipei"
    direction "$1" "$2"
    return
    fi
    direction
}

function glat() {
    if [[ $# -eq 0 ]] ; then
        echo [Info] latlng=23.69781,120.96
        echo [Info] example gip 23.69781,120.96
        echo $1 
        echo 'curl https://maps.googleapis.com/maps/api/geocode/json?latlng=$1,$2 | json results[0].formatted_address'
    return 0
    fi
    latlng=$1
    curl https://maps.googleapis.com/maps/api/geocode/json?latlng=$latlng | json results[0].formatted_address
    unset latlng
}

## This script helps to turn ip2loc
## Requirement : Node.js shelljs ipfo
## Author: Ralic Lo

function ip2loc() {
    if [[ $# -eq 0 ]] ; then
    ipinfo $(myip2)
    return 0
    fi

    ipinfo $1 ||
    echo $(json -f ipgeo.json City_Latitude)","$(json -f ipgeo.json City_Longitude) >tmp
    latlng="$(cat tmp)"
    glat $latlng > tmp
    unset latlng

    src="
    fs=require('fs');
    ip=require('./ipgeo.json');
    data=fs.readFileSync('./tmp').toString().replace(/\n$/, '');
    ip.Address=data;
    fs.writeFileSync('./ipgeo.json',JSON.stringify(ip, null, 2) , 'utf-8');"
    echo $src > src.js
    
    shjs src.js
    unset src
    rm src.js
    rm tmp
    cat ipgeo.json
}

## This script helps to push/install apk into android 
## Requirement : android studio "platform tools"
## Author: Ralic Lo

function aapk() {
    if [[ $# -eq 0 ]] ; then
        echo "Please type in the file name, without extension .apk"
    return 0
    fi
    if [ ${1: -4} == ".apk" ] ; then
        echo [Running] adb push "./"$1".apk" "/data/local/tmp/"$1
        adb push "./"$1".apk" "/data/local/tmp/"$1
        echo [Running] adb shell pm install -r "/data/local/tmp/"$1
        adb shell pm install -r "/data/local/tmp/"$1
        return
    else
        echo "This is not apk file, pushing it to /data/local/tmp"
        echo "For pushing golang executable"
        echo "export GOARCH=arm;export GOOS=linux;export GOARM=7;go build"
        echo adb shell chmod 755 /data/local/tmp/$1
        echo adb shell
        echo cd /data/local/tmp
        adb push "./"$1 "/data/local/tmp/"$1
        adb shell chmod 755 /data/local/tmp/$1
        return
    fi 
}

## This script helps to decompile / recompile /push list apk in android
## Requirement : android studio "platform tools" apk
## Author: Ralic Lo

function capk() {
    echo Usage: ppk 'filename without apk'
    echo "options: (dec) | (enc)rypt | (list) | (push)"
    read option
    case $option in 
        dec)  apktool d $1".apk"
            return
        ;;    
        enc)  
            apktool r $1".apk"
            return
        ;;
        list)
            adb shell uname -a # Displaying shell's kernal
            adb shell pm list packages -f # Display all installed apk
            return
        ;;
        push)  
            aapk $1
            return
        ;;
        *)
        ;;
    esac
    
}

function cleanyum() {
    yum clean all
    package-cleanup --leaves --all --exclude-bin | xargs yum remove -y
}

# How Do I Find The Largest Top 10 Files and Directories On a Linux / UNIX / BSD?
#http://www.cyberciti.biz/faq/how-do-i-find-the-largest-filesdirectories-on-a-linuxunixbsd-filesystem/
function big10() {
    du -hsx * | sort -rh | head -10
    du -a /var | sort -n -r | head -n 10
    for i in G M K; do du -ah | grep [0-9]$i | sort -nr -k 1; done | head -n 11
}


## This script helps to dig out private IP and public IP in AWS/GCE
## Requirement : curl iprout2mac
## Author: Ralic Lo

alias myip2='dig +short myip.opendns.com @resolver1.opendns.com' ##  Public facing IP Address

function myip3() {
    echo "options: Private IP -- (aws)  | (goog)le | (eth0)"
    echo "options: Public  IP -- (pub)lic ip"
    read option
    case $option in 
        aws) curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
            return
        ;;    
        goog)  
             curl -fsSL -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip
            return
        ;;
        eth0)
            ip addr show |grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
            echo $(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
            return    
        ;;
        pub)
            echo Public IP is $(myip2)
            return
        ;;
        *)
            echo brew install iproute2mac for MacOS before use
        ;;
    esac
}

## This script helps to get your ipv6 address 
## Requirement :  [MacOS] curl iprout2mac     

## Author: Ralic Lo

function myipv6() {
     if [ "$(uname -s)" == "Darwin" ]; then
         ip -6 addr show en0 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/'
     else
         ip -6 addr show eth0| grep inet6 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/'
     fi
}

## Requirement :  npm install goo.gl -g 
## Return shortened URL from google's service.
## ex:   surl www.taiwan.com
## http://www.taiwan.com -> https://goo.gl/RZeFs2

function surl() {
    goo.gl --key=AIzaSyAMbjiR9XN1DADOKmb2bZiFw9R4Wtq6SVE $1 >>surl.log
    tail -n 1 surl.log
}

## This script helps to provide a link to your server using ipv6.
## It works if you have an IPV6 ISP provider.
function linkme() {
    echo open https://[$(myipv6 | cline 1)]
    surl https://[$(myipv6 | cline 1)]
    open https://[$(myipv6 | cline 1)] 
}

function googlink() {
    curl -s -d'&url=URL' http://goo.gl/api/url | sed -e 's/{"short_url":"//' -e 's/","added_to_history":false}/\n/'
}

function oacurl() {
     # brew install mercurial -- for hg clone
    java -cp oacurl-1.3.0.jar com.google.oacurl.Login \
      --scope https://www.googleapis.com/auth/webmasters --oauth2 \
      --consumer-key=YOUR_CLIENT_ID --consumer-secret=YOUR_CLIENT_SECRET
}

## This script helps to prepare private git in google cloud.
## REF https://console.cloud.google.com/code/develop/browse/daydream?project=mesos-1369&authuser=2
## Requirement : Google Cloud SDK installed
## REF https://cloud.google.com/sdk/docs/quickstart-mac-os-x
## Author: Ralic Lo

export gproject=mesos-1369
export gfolder=daydream
source ~/work/gcloud/google-cloud-sdk/path.bash.inc
source ~/work/gcloud/google-cloud-sdk/completion.bash.inc
function ggit() {
    echo "options: (load) gcloud | (init) credential |  (info) project/repository  "
    echo "options: (add) google  | (push) to google  |  (clone) from google "
    read option
    case $option in 
        load) 
            # The next line updates PATH for the Google Cloud SDK.
            source '$UsrPATH/$UsrNAME/private/google-cloud-sdk/path.bash.inc'
            # The next line enables shell command completion for gcloud.
            source '$UsrPATH/$UsrNAME/private/google-cloud-sdk/completion.bash.inc'
            return
        ;;      
        init) 
            gcloud init && git config credential.helper gcloud.sh
            echo [gproject]= $gproject ,[gfolder] = $gfolder
        ;;
        info)
            echo [gproject]= $gproject ,[gfolder] = $gfolder
            # create a variable to hold the input
            read -p "Change Project? [Type] projectname or [Enter] to Skip: " newproject
            # Check if string is empty using -z. For more 'help test'    
            if [[ -z "$newproject" ]]; then
               echo "No input entered"
               return
            else
               # If userInput is not empty show what the user typed in and run ls -l
               echo "You entered $newproject"
                gproject=$newproject
            fi
            read -p "Change Folder ? [Type] foldername or [Enter] to Skip: " newfolder
            if [[ -z "$newfolder" ]]; then
               echo "No input entered"
               return
            else
               echo "You entered $newfolder"
               gfolder=$newfolder
            fi
            echo [gproject]= $gproject ,[gfolder] = $gfolder
        ;; 
        add) 
            echo [gproject]= $gproject ,[gfolder] = $gfolder
            echo "Confirm add to google? Type 'google' to confirm"
            read google
            git remote add $google https://source.developers.google.com/p/$gproject/r/$gfolder
            echo "Remove any remote ?"
            read remove
            echo "Confirm or Escape to remove" $remove
            git remote rm $remove 
        ;;
        push)
            echo "-f : force all ? "
            read force
            git add $force * 
            echo "Commit Commment ?:  "
            read comment
            git commit -m $comment
            git branch
            echo "Which Branch ?:  "  "use google/origin ?"
            read branch
            git push --all $branch
        ;;
        clone)
            gcloud source repos clone $gfolder --project=$gproject
        ;;
        *)
            "[Info] Use 'load' before running any commands."
        ;;
    esac
}

function vs () {
    /Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron "$@" &
}

function bsc() {
    browser-sync start --server --files "*.html, css/*.css"
}


## This script helps to support chorme-cli
## Author: Ralic Lo

function cm() {
   chrome-cli "$@"
}

function cmi() {    
    chrome-cli --incognito "$@"
}

function cpmt () {
    cm open  "https://translate.google.com/translate?hl=en&sl=auto&tl=zh-TW&sandbox=1&u=""$@"
}

## For variable of current tab-id
function cmnow() {
    cm info|grep Id | head -n 1| awk '{print $2}'
}

function cmtabs() {
   chrome-cli list tabs $@
}

function cmgg() {
    chrome-cli open 'https://www.google.com/#safe=active&q='$@
}

## Read Source file form specific tab
function cmsrc() {
        if [[ $# -eq 0 ]] ; then
             chrome-cli source -t $(cmnow)
        else 
                chrome-cli source -t $@
        fi
}
## This script helps to inject javascript file into running chrome tab
## Author: Ralic Lo
function cmrun() {
    if [[ $# -eq 0 ]] ; then
        echo Example : chrome-cli execute "script=function () {
                            var a=3;var b=5;
                            console.log('Cool Success',a+b);
                            return a+b;
                        }()" -t $(cmnow)
        return
    fi
    ## ex. cmrun test.js
    echo chrome-cli execute '"$(cat $1)"'  -t $(cmnow)> run.script 
    . run.script $1 & echo $! >run.pid 
    sleep 1
    rm run.script
    rm run.pid
}


## This script helps to query tag in running chrome tab
## Usage : cmquery div
## Example : cmquery ''div.top-card > span > h3 > a'
## Author: Ralic Lo

function cmquery() {
    src="var script = function(){
    var k=document.querySelectorAll('$1');
        console.log(k);
    for (var i in k) {
        console.log('Result',i,':',k[i])
        k.item()
    }
    return k; 
    }()"
    echo "execute script:" $src
    chrome-cli execute "$src" -t $(cmnow)
    unset src
}

function cmk() {
    chrome-cli close -t "$@"
}

function cmk10() {
     cml | head -n 10| awk '{print $1}'|regex '[0-9]+'| awk '{print "cmk "$0}'> cm.run
     . cm.run
}

function cmsave() {
     cml | sort | uniq| awk '{print "cmo "$2}'  > cm.save"$@"
}

function cmclean() {
    # Clean chrome cache
    rm -R '$UsrPATH/$UsrNAME/Library/Caches/Google/Chrome/Default/Media Cache'
}

function cmi() {
    chrome-cli info -t "$@"
}

function cmo() {
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  "$@"
}

function cmio() {
    cmo --incognito "$@"
}

function cmiot2() {
    TT_API2="https://translate.google.com/translate?hl=&sl=auto&tl=zh-TW&u="
    chrome-cli open $TTAPI2"$@"
}
## READ WEBSITE IN CHINESE,ZH-TW 
function cmiot() {
    usg=ALkJrhi7ckC8KCnB15kFgAPpSMtdQ6YLmg
    TT_API="https://translate.googleusercontent.com/translate_c?depth=2&nv=1&rurl=translate.google.com&sl=auto&sp=nmt4&tl=zh-TW&u="
    cmio $TT_API"$@"$usg
}
## READ WEBSITE IN ENGLISH
alias ggzh=cmiot

function cmioten() {
    TT_API="https://translate.google.com/translate?depth=1&hl=en&nv=2&rurl=translate.google.com.tw&sl=auto&sp=nmt4&tl=en&u="
    cmio $TT_API"$@"
}

## This script is to use google's website tranlation to english
function gen() {
    trans_prefix="https://translate.google.com/translate?hl=en&sl=auto&tl=en&u="
    open $trans_prefix$@
}

# function cmit() {
#     echo [Info] Enter Options to translate 
#     echo (1)zh-TW (2) EN (3) KOrean (4) JaPan (5)
#     read option
#         case $option in 
#             1) 
#                  return
#             ;;      
#             zh-TW) 
#             ;;
#         esac
#     cmo --incognito "https://translate.google.com/translate?hl=en&sl=auto&tl=zh-TW&sandbox=&u=""$@"
# }

function cmcall() {
    chrome-cli open "http://$@"
}

function cml() {
    chrome-cli list links
}

function cma() {
    chrome-cli activate -t "$@"
}

function cmload() {
    cm info | grep Loading | awk '{print $2}'
}

function ccc () {
        if [ "${cmc}" == "No" ] ; then
            echo "TRUE"
         else
            echo "FALSE"
         fi
}

function regex() { gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'; }

function checkjdk() {
    cd  /Library/Java/JavaVirtualMachines/
}

## This script allows your download youtube as mp4 files.
function yp() {
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "$@"
}

## This script Help initial MOE Test on IOS / Android
function mockmoe() {
    echo "[Option] Mocking on which mobile platform ?"
    echo "1) Start Android Emulator"
    echo "2) Install Android Application"
    echo "3) Start iOS Simulator"
    echo "4) Install iOS Application"
    # echo "9) Exit"
    read option
    # while [ $option -ne 0]
    # do
        case $option in 
            1) 
                 emulator -netdelay none -netspeed full -avd  $avd Pixel_XL_API_O&
                 return
            ;;      
            2) 
                 gradle installDebug 
                 return
            ;;
            3) 
                 open '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app' &
                 return
            ;;
            4) 
                 gradle installDebug 
                 return
            ;;
            *)
               echo [Info] Please Select again.
            ;;
        esac
    # done
}

## This script is powerful touch, to enforce creating a file in the path 
function ptouch() {
    for p in "$@"; do
        _dir="$(dirname -- "$p")"
        [ -d "$_dir" ] || sudo mkdir -p -- "$_dir"
    sudo touch -- "$p"
    done
}

## This script is powerful wget to get a website clone.
## https://www.guyrutenberg.com/2014/05/02/make-offline-mirror-of-a-site-using-wget/
## RATE LIMIT : ‐‐limit-rate=200k ‐‐wait=60
## Simplified : wget -mkEpnp http://example.org
function uberget() {
## Other agents: https://support.google.com/webmasters/answer/1061943?hl=en
## "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"
## Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36 
tee ~/.wgetrc <<-'EOF'
header = Accept-Language: en-us,en;q=0.5
header = Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
header = Connection: keep-alive
user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1"
referer = /
robots = off
EOF
    wget ‐‐random-wait --mirror --adjust-extension --page-requisites  --convert-links --no-parent -r -x "$1"
}

## This script is to build Java program using gradle with all cores.
## gjob : build parallely and never stop when failure
## glist : list all partial projects

function gjob() { # --configure-on-demand 
    gradle build --parallel --daemon --continue "$@"
}

function glist() {  # --configure-on-demand 
  gradle build --parallel --daemon  -q projects 
}
## This command help read specific line in a file
## Example : cline 10 (test.txt)
cline() {
    awk NR=="$@"
}

## This script helps move first 100 lines to new file
new100() {
    dateinfo=$(date +%Y-%m-%d-%H%M)
    echo $dateinfo
    filename="$@"
    head -n 100 $filename > $filename$"_"$dateinfo ;
    tail -n +100 $filename > $filename.tmp ;
    yes|cp $filename.tmp $filename; 
    rm $filename.tmp
     echo [Info]Moved first 100 lines to new file $filename$"_"$dateinfo
}

## This script helps update android sdk to the latest
function adup() {
    android update sdk --no-ui --all
}

## This script helps create Gulp file monitoring
## Prerequisite : npm, gulpfile.js
# var gulp = require('gulp');
# var gls = require('gulp-live-server');
# gulp.task('default', function() {
#    //https://www.npmjs.com/package/gulp-live-server
#   var server = gls.static('./', 80);
#   server.start();
#     //use gulp.watch to trigger server actions(notify, start or stop) 
#     gulp.watch(['**/*.css', '**/*.html'], function (file) {
#       server.notify.apply(server, [file]);
#     });
# });

function golive() {
    gulp_loc=g
    yes| cp ~/$(echo $gulp_loc)/gulpfile.js .
    npm install gulp gulp-live-server live-server --save
    live-server
}

## this script help you find (lat, lon) coordinate of a location

function gps () {
    if [ "$#" -lt 1 ]
    then
      echo "input error"
      echo "usage: $0 <adderss>"
      echo "example usage: gps Taiwan"
    fi
    local address=$1
    wget -O- -q "https://maps.googleapis.com/maps/api/geocode/json?address=$address"|\
    grep -A2 '"location"'|\
    tail -n2|\
    cut -d\: -f2|\
    tr '\n' ' '
    echo ""
}

## this script help randomize mac_address for wifi

function myoldmac() {
    ifconfig en1 | awk '/ether/{print $2}'
    spoof list
}
function mymac() {
    ifconfig en1 | awk '/ether/{print $2}'
    spoof list
}
function mynewmac() {
    sudo spoof randomize en0
    sudo spoof randomize en4 
    spoof list
}

## AWK SPECIAL CHARACTER, single quote and dobule quote
# $ awk 'BEGIN { print "Here is a single quote <\47>" }'
# -| Here is a single quote <'>
# $ awk 'BEGIN { print "Here is a double quote <\42>" }'
# -| Here is a double quote <">

## Check whether a file existed in the file system
## Example filex /etc/passwd
## Example filex /etc/passwd | grep null
function filex() {
    echo "[Press Enter to Skip print out the file]"
    [[ -f "$@" ]] && echo "[Info] File exist , Reading file info(y/n) ?";
    read option ;
    case $option in 
        y)
            cat "$@" 
        ;;
    esac || echo "[Info]  File does not exist" ; 
}

## This script help you reboot mysql root access
function mysqlboot() {
    #https://gist.github.com/fallwith/987731#file-homebrew_mysql_pass_reset-txt
    # 0) Check Mysql Root password
    cat /usr/conf/mysql.conf
    # 1) Stop Mysql
    /etc/init.d/mysql stop
    # 2) Start Mysql Safe
    mysqld_safe -skip-grant-tables &
    # 3) Start Mysql
    /etc/init.d/mysql start
    # 4) Login as root
    mysql -u root -p
    kill `cat /mysql-data-directory/host_name.pid`
}
## This script help creates a bootable mac usb for sierra
## Change usbName for different Volume.
## https://support.apple.com/en-us/HT201372
function createUSB() {
    macVersion=Sierra
    usbName=MinionDisk
    sudo /Applications/Install\ macOS\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/$usbName --applicationpath /Applications/Install\ macOS\ Sierra.app --nointeraction &&say Done
}

function ccmake() {
    echo "[Info] This script help print a template for configuration of Cmake"
    echo "1) Configure phase:"
    echo 'cmake -Hfoo -B_builds/foo/debug -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_DEBUG_POSTFIX=d -DCMAKE_INSTALL_PREFIX=/usr'
    echo "2) Build and Install phases"
    echo "cmake --build _builds/foo/debug --config Debug --target install"
}

## This script helps find all href links from a file.
function findlinks() {
    sed -n 's/.*href="\([^"]*\).*/\1/p' "$@"
}

## This script help mirror GNU Software Projects to Github
## https://www.gnu.org/software/software.html
## Prerequsite : brew install hub , git
function gnu_mirror2() {
    git clone git://git.savannah.gnu.org/"$@".git
    cd "$@" >> /dev/null
    hub create gnu_"$@"
    git push --force --mirror https://github.com/ralic/gnu_"$@".git
    cd .. >> /dev/null
    # rm -rf "$@"
}
## [github CLI] npm install gh -g
## https://www.npmjs.com/package/gh
## http://nodegh.io/
## https://github.com/node-gh/gh
#git clone https://github.com/sametmax/0bin.git
#origin    https://github.com/Python3pkg/diveintopython3 (push)

function gitpy3 () {
    srcgit=$(git remote -v | grep origin | grep push | awk '{print $2}')
    owner=$(git remote -v  | grep origin |grep push | awk '{print $2}' |sed 's/https\:\/\/github.com\///' | sed 's/\/.*//g')
    gitname=$(git remote -v  | grep origin| grep push | awk '{print $2}' | sed 's/https\:\/\/github.com\///' | sed 's/\//\ /g' | awk '{print $2}')
    gh re --fork $gitname --organization Python3pkg
    allpy3
    git remote add source $srcgit
    git remote set-url origin https://github.com/Python3pkg/$gitname
    git add *
    git commit -m "Convert to Python3"
    dget .travis.yml
  #  git .travis.yml
  #  git commit -m "Add Travis-CI"
    git push origin
    # gh pr --submit $owner --title "Convert to Python3" --description " using : find . -name "*.py" | xargs 2to3 -w"
    echo 'gh pr --submit $owner --title "Convert to Python3" --description " using : find . -name "*.py" | xargs 2to3-3.6 -w"'
 }

# 	echo "This function help remove the last character of a file, whatever it is"
function nolast() {
    sed 's/.$//' 
}
# 	echo "This function help remove the first character of a file, whatever it is"

function nofirst() {
    sed 's/^..//' 
}
# 	echo "This function removes all empty lines in the file"
function noempty() {
	sed '/^$/d'
}

function readvalue() {
	value=$(<$1)
	echo "[Info] Read file"$@"into variable $value :" $value
}

## This function help trim the imput
function trim() {	
	awk '{$1=$1};1' "$@"
}

function idf () {
    echo "[Info] Report comparision, File1_Name: "$1", File2_Name :"$2
    ### sdiff or icdiff may also works
    diff --side-by-side $1 $2 > idf.report
    cat -n idf.report | grep "|" > idf.summary
    echo "[DIFF REPORT SUMMARY]"
    cat idf.summary
}

function instabots() {
tee install.folders <<-'EOF'
function mv2cellars() {
    ls -d */ > folders.here
    cat folders.here | awk '{print "yes|mv " $1 " /usr/local/Cellar"}' >> install.go
}
EOF
    find . -type f | awk '{print "extract "$1}' > install.run
    . install.run
    . install.folders
    . install.go
    echo "Type . install.go to install in cellars"
}

function bot() {
    local BOT_PATH=~/work/bottles/tmpbot/"$1"
    mkdir -p $BOT_PATH;cd $BOT_PATH
    brew info "$1" > message.txt
    uname -ovr >> message.txt
    brew install "$@" --build-bottle --no-sandbox  > autobot.log
    brew upgrade "$@" --build-bottle --no-sandbox  >> autobot.log
    brew bottle "$@" >> autobot.log
    brew postinstall "$@"
}

function forcebots() {
    cat autobot.log | grep built | awk '{print $2'} > built.txt
    cat built.txt | sed 's|:||g' | sed 's/\// /g' | awk '{print "forcebot "$5}' >forcebot.list
}

function forcebot() {
    bot "$@"
    local returnFolder=$(pwd)
    cd /usr/local/opt/"$@" > /dev/null
    replacetxt '"built_as_bottle":false' '"built_as_bottle":true' INSTALL_RECEIPT.json >/dev/null
    cd $returnFolder
    brew bottle "$@"
    botok 
}
function botok(){
    local PUSH=true
    local returnFolder=$(pwd)
    local s1=1;
    local s2=$(cat autobot.log  | grep 'bottle do'|wc -l)
    local s3=$(cat autobot.log | grep "This formula doesn't require compiling."| wc -l )
    local s4=$(($s2+$s3))
    if [ $s1 == $s4 ]
    then
        sed -i '1s/\(.*\)/[Succeed]\1/' message.txt ;PUSH=true
    else 
        sed -i '1s/\(.*\)/[Failed]\1/' message.txt ;PUSH=false
    fi
    brew --env > env.txt
    if [ $PUSH == true ]
    then
        yes|cp -rf * ~/work/bottles
        cd ~/work/bottles >>/dev/null
        gitmsg
        cd $returnFolder >>/dev/null
    else 
        mkdir -p ~/work/bottles/tmpbot/.failed >>/dev/null
        cat message.txt >> ~/work/bottles/tmpbot/.failed/failed.log
    fi
}

function brewbot() {
    unlink /usr/local/bin/python
    unset PYTHONPATH;unalias python;brew upgrade --build-bottle
    ln -s /usr/local/bin/python3 /usr/local/bin/python
}

function autobots () {
    brew outdated  > tobe.bot
    wwich bot | sed '1d' > tobe.run
    wwich botok | sed '1d'>> tobe.run
    wwich gitmsg | sed '1d'>> tobe.run
    cat tobe.bot | awk '{print "bot "$1";botok"}' >> tobe.run
    echo 'brew cleanup' >> tobe.run
    echo '[Info]  Do you want to start auto bottles ? (yes/press enter to skip)' 
    read option 
    case $option in
            yes)
                echo '[Info] Running Autobot'
                . tobe.run  &
            ;;
            *)
                echo '[Info] execute  ". tobe.run &" to start auto bottles'
            ;;
    esac
}

function brewbottles() {
    brew list | awk '{print "brew bottle "$1}' >bottle.list
    . bottle.list > bottle.log
}

function brewpush() {
    local brewP="$1"
    echo "[Usage] brewpush recipe name"
    echo "[Alert] Please make sure you 'brew audit --new-formula <foo>' !!  (yes?)"
    read option
    case $option in
            yes)
                brew update 
                # required in more ways than you think (initializes the brew git repository if you don't already have it)
                cd $(brew --repo homebrew/core)
                # Create a new git branch for your formula so your pull request is easy to
                # modify if any changes come up during review.
                # git checkout -b <some-descriptive-name>
                git add Formula/$brewP.rb
                git commit
            ;;
            *)
                return 0
            ;;
    esac
}


function gobrew() {
    if [ "$(uname -s)" == "Darwin" ]; then
        cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula
    else
        cd /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core/Formula
    fi
    echo git remote set-url origin https://github.com/ralic/homebrew-core.git
}

function lfgf() {
    if [ "$(uname -s)" == "Darwin" ]; then
        git remote set-url origin https://github.com/Homebrew/homebrew-core.git 
    elif [ "$(uname -s)" == "Linux" ]; then
        git remote set-url origin https://github.com/Linuxbrew/homebrew-core.git 
    fi  
}

### MAC :Adjust Kernel to 64 bit
# https://www.finetunedmac.com/forums/ubbthreads.php?ubb=showflat&Number=31746
# http://www.hackaapl.com/forcing-snow-leopard-os-x-to-boot-64-bit-kernel/
function gosystem() {
    cd /Library/Preferences/SystemConfiguration
}

function cspace() {
    echo "[Info] Checking boot configurations in Linux to see if it supports namesspace, required by ICU4C"
    echo "File : /boot/config-$(uname -a | awk '{print $3}')"

    if [[ `sudo cat /boot/config-$(uname -a | awk '{print $3}') |grep '^CONFIG_USER_NS'` == "CONFIG_USER_NS=y" ]]; 
    then echo "You have support for User Namespaces"; 
    else echo "Sorry, you don't have support for User Namespaces"; 
    fi
}

function alldone() {
	echo "[Usage] To check if there is runnning background jobs in current subshell"
	if [ $(jobs|wc -l) -eq 0 ] ; 
		then 
			echo "[Results] No background job running in current shell";
			return true; 
		else 
			echo "[Results] "$(jobs |wc -l)" background_jobs running."
			return false;
	fi
}

function kouser() {
    echo "[Info] Remove and logout a user's all jobs"
    killall -u "$@"
}

function kvnc() {
    ps aux | grep vnc | grep  desktop | awk '{print "kill "$2}' > kvnc.pid
    . kvnc.pid
}

function nobgjobs() {
	echo "[Info] Removed all background jobs"
    BGJOBS="$(jobs -p)";
    if [ -n "${BGJOBS}" ]; 
    	then
	        kill -KILL ${BGJOBS};
    fi
}

# function addjobs() {
# 	echo "[Info] Add backround jobs if nothing is in background: " $@
# 	while [ alldone ] 
# 		do
# 		$@ &
# 		break
# 	done 
# }

function countchar() {
	echo "[Usage]  countchar 'filename' 'character'"
	echo "[Output] numbers of repated patttern"  
    local search=$2
	local filename=$1
	cat $filename | sed s/[^${search}]//g  | awk '{ print length }' > count_$search.txt
	cat count_$search.txt
}

function joincsv() {
	echo "[Usage] Join multiple file as ',' comma splited file"
	paste -d"," "$@" > comma_csv.txt
	cat  comma_csv.txt
}

function findtxt() {
    echo "[Usage] findtxt about 'keyword' recursively in current folder"
    echo "[Info] example : findtxt '/usr/bin/env python' "
    echo "[Alt] brew install ack ; ack '/usr/bin/env python' "
    echo "[Output] file name , line number , text details, result in findtxt.log"
    grep -Rnw "$@" > findtxt.raw
    cat findtxt.raw | sed s/:/\\t/ | sed s/:/\\t/ | grep -v Binary > findtxt.log
    cat findtxt.log
}

function cleantxt() {
    echo "[Info]~/Library/Application Support/??? contains the catalog with plugins."
    echo "[Info]~/Library/Preferences/??? contains the rest of the configuration settings."
    echo "[Info]~/Library/Caches/??? contains data caches, logs, local history, etc. (large size)"
    echo "[Info]~/Library/Logs/??? contains logs."
    rm findtxt.*
    rm comma_csv.txt
    rm count_*.txt
}

function replacetxt() {
    echo "[Usage] replacetxt  'old' 'new' 'filename'"
    echo "[Info] example : findtxt '/usr/bin/env python'"
    echo "[Notes] remove the g"
    local search=$1
    local replace=$2
    local filename=$3
    # Note the double quotes
    sed -i "s/${search}/${replace}/g" $filename
}
function gitcopy() {    
    git clone --recursive --depth=50 --branch=master "$@"
}
function gitpushall() {
    echo "[Info] This cript helps you push all submodules using git."
    git push --recurse-submodules=on-demand "$@"
}
function gitmsg() {
    git add *;git commit -F message.txt;git push
}
function gitsend() {
    git commit -F .git/COMMIT_EDITMSG;git push
}

function gitfind() {
	echo "[Info] This script helps searching git history using git"
	git log --grep "$@"
	## Ex. gitfind bitcoin
}

function gitreview() {
	if [[ $# -eq 0 ]] ; then
        echo "[Info] This script helps review git commit logs since specified date"
		echo "[Example] gitreview '2017-12-11' '--grep bitcoin' , Default Date=2017-01-01"
		git --no-pager log --graph --pretty=format:"%ad %C(yellow)%H%C(cyan)%C(bold) %C(cyan)(%cr)%Creset %C(green)%ce%Creset %s" --date=iso --since=2017-01-01
	else 
        git --no-pager log --graph --pretty=format:'%ad %C(yellow)%H%C(cyan)%C(bold) %C(cyan)(%cr)%Creset %C(green)%ce%Creset %s' --date=iso --since="$1" $2 
    fi
}

function gitlogs() {
	gitreview | sed '1,2d' > ~/.cache/bot.commit
	cat -n ~/.cache/bot.commit |cut -c1-150
}

function gitarget() {
    echo "[Usage] 'gitarget GithubTreeUrl', here the commited url is from blob of github"
    echo "[Example] gitarget https://github.com/ralic/python3.62mac/tree/5394bbc291eb816e7cb05a195ed93b394ad14daf"
    echo $1 | sed 's/\/tree\/*/ /' | sed "s/https:\/\/github.com\///g" |sed 's/\// /' > git.wanted
    ## $1 user , $2 repo , $3 commit
    cat git.wanted | awk '{print "git clone https://github.com/"$1"/"$2";cd "$2";git checkout "$3}' > git.take
    . git.take
}

function gitcut() {
    echo "[Info] Cutting off commit from history "
    git rebase -i "$@"
}

function brewhistory() {
	local DATE=$1
	local BOT_PATH=~/work/bottles/tmpbot/commit.log
	gitreview '2017-12-11' > tmpbot/tocut
}

function gitgetsubs() {
    echo "[Info] Find all submodules directorys : cat submodules.txt"
    ## Remove head and tails , ## Remove 1st line
    find . -name .git | grep -v '\./.git' | sed 's/^..\(.*\).....$/\1/'  > submodules.txt
    cat submodules.txt  | awk '{print "cat "$1"/.git/config| grep url | sed -n 1p "}' > submodules.run
    . submodules.run |sed 's/^.//'> submodules.urls
    cat submodules.urls | awk '{print "git submodule add "$3}'> submodules.adder
    cat submodules.txt | awk '{print "[submodule \""$1"\"],path="$1}' > submodules.path
    paste -d"," submodules.path submodules.urls > submodules.txt
    tr , '\n' < submodules.txt > .gitmodules
    . submodules.adder
    rm submodules.*
    cat .gitmodules
    git submodule
    git submodule init
    git submodule sync --recursive
    git add .gitmodules
}

function gitupdates() {
    # git submodule
    # git submodule sync --recursive;
    # git submodule update --recursive 
    git submodule foreach git pull
}

function gitdf() {
    echo "## This script helps you compare new commmit and previous commit in git"
    echo "If you dont' agree with this change, use 'git reset HEAD' to reverse the change."
    git diff HEAD^ HEAD  ## or git show
}

function gitadm() { 
    echo "[Info]## This script helps you add files into git, default '--modified'"
    echo "[Example] gitadm deleted"
    if [[ $# -eq 0 ]] ; then
        git ls-files --modified | xargs git add
    else 
        git ls-files --"$@" | xargs git add
    fi
}


## REF : https://stackoverflow.com/questions/1186535/how-to-modify-a-specified-commit-in-git
function gitmodify() {
    echo "[Info]  gitmodify, This script help you just modify single commit and its message."
    echo "[Step-1] Use 'reword' to replace 'pick' in the interactive edtior."
    echo "[Step-2] git push -f to overwrite messages"
    cheditor /usr/bin/vi
    git rebase --interactive $1
    git commit --all --amend --no-edit
    git rebase --continue
    export TEXT_Editor=subl
    cheditor
}

# Go forward in Git commit hierarchy, towards particular commit 
# Does nothing when the parameter is not specified.
git4wd() {
  git checkout $(git rev-list --topo-order HEAD.."$*" | tail -1)
}

# Go back in Git commit hierarchy
alias gitback='git checkout HEAD~'

## This script help backup your current git 
## and pull everthing from remote and reset it
## REF : https://stackoverflow.com/questions/1628088/reset-local-repository-branch-to-be-just-like-remote-repository-head
function gitrestart() {
    git checkout master
    echo "[Info] Creating branch in 'local/develop' from local/master ..."
    git branch develop
    git fetch --all --recurse-submodules
    echo "[Info] Restoring 'local/master' from 'origin/master' ... "
    git reset --hard origin/master
    echo "[Info]Do you want to remove 'local/develop' branch ? (yes / or  Press 'enter' to skip)"
    read option
    case $option in
            yes)
                git branch -D develop
            ;;
            *)
                echo "[Info]enter "$folder" to cleanup records."
            ;;
    esac
}

## REF : https://stackoverflow.com/questions/2862590/how-to-replace-master-branch-in-git-entirely-from-another-branch

function gitdmaster() {
    echo '[Info]  This script helps to replace master from development'
    git checkout develop
    git merge -s ours master
    git checkout master
    git merge develop
}

function myhg2git() {
    #https://git-scm.com/book/en/v2/Git-and-Other-Systems-Migrating-to-Git
    ## Install library
    rm authors
    rm authors.clean
    git clone https://github.com/ralic/fast-export.git
    ## Hg clone
    # hg_repo=example
    # hg clone $hg_repo

    ## Authors conversion
    hg log | grep user: | sort | uniq | sed 's/user: *//' > ./authors
    cat authors | grep -v " at " | uniq > authors.clean
    cat authors.clean | awk 'match($0,/^(\S*\s\S*\s*)||^(\S*\s)/) {print substr($0,RSTART,RLENGTH)"="$0}' >authors.format

    ## Ready for Converstion
    git config core.ignoreCase false
    echo "[Info] Run following command to transfer it to git format"
    echo "/tmp/fast-export/hg-fast-export.sh -r . -A authors.format"
}

function svn2git() {
    echo "[Example]git svn clone http://cvs2svn.tigris.org/svn/cvs2svn/trunk cvs2svn-trunk"
}

## This script helps unarchive .deb files from debian.org.

function nodebt() {
    ar -x path/to/deb/"$@".deb
}

## This script helps to creat a tar.xz for a folder.
function getar() {
#    tar -zcf "$1".tar.gz "$1"
    XZ_OPT=-e9 tar cJf "$1".tar.xz "$1"
    du -sh $1
    du -sh $1.tar.xz
}

function utar() {
    extract "$1"
}

## brew install xz , brew install lz4
### Patching mac default compress to be .tar.xz 
# alias compress=getar
function xbench() {
    echo $'[Info] This script benchmarks tar.xz,tar.xz4,tar.lz4 speed, ex. xbench "Folder name"\n'
    echo $'[Info] lz4dir score'
    time lz4dir $1
    echo $'[Info] xz4dir score'
    time xz4dir $1
    echo $'[Info] xzdir score'
    time getar $1
    mkdir -p xbenchTest  >>  /dev/null
    mv $1.tar.* ./xbenchTest  >>  /dev/null
    cd xbenchTest >>  /dev/null
    time unlz4dir ./$1.tar.lz4;rm -rf ./$1; 
    time unxz4dir ./$1.tar.xz4;rm -rf ./$1 
    echo "'.xz/$1' -> './$1'"
    time utar ./$1.tar.xz;rm -rf ./$1 
    cd ..  >>  /dev/null
    rm -rf xbenchTest
}

function 49zdir() {
	zip -r "$@".zip "$@" -s 49m
}

function zipdir() { 
    zip -r "$1".zip "$1" > /dev/null
    du -sh $1
    du -sh $1.zip
 }          
# zipdir:         To create a ZIP archive of a folder
function xz4dir() {
    find $1 -type d -print0| xargs -n 1 -P $PACORES -0 -I'{}' mkdir -p './.xz4/{}' 
    find $1 -type f | ffilter | xargs -n 1 -P $PACORES xz -e9k
    find $1 -name '*.xz' -print0 | xargs -n 1 -P $PACORES -0 -I'{}'  mv  '{}' './.xz4/{}'
    tar -cf $1.tar.xz4 .xz4/$1
    rm -rf .xz4
    du -sh $1
    du -sh $1.tar.xz4
}

function unxz4dir() {
    tar -xf $1
    find .xz4 -type f |ffilter| xargs -n 1 -P $PACORES xz -d 
    mv .xz4/* . 
    rm -rf .xz4
}

## This ffilter  will take care of escaping the spaces and quotes
## Sometimes find  if -print0 not working
function ffilter() {
##  | sed -e "s/'/\\\'/g" -e 's/"/\\"/g' -e 's/ /\\ /g' 
    sed -e "s/'/\\\'/g" -e 's/"/\\"/g' -e 's/ /\\ /g' 
}
function lz4dir() {
    find $1 -type d -print0 | xargs -n 1 -P $PACORES -0 -I'{}' mkdir -p './.lz4/{}'
    find $1 -type f | ffilter | xargs -n 1 -P $PACORES  lz4 -9m
    find $1 -name '*.lz4' -print0  |  xargs -n 1 -P $PACORES -0 -I'{}' mv '{}' './.lz4/{}'
    tar -cf $1.tar.lz4 .lz4/$1 
    rm -rf .lz4
    du -sh $1
    du -sh $1.tar.lz4
}
function unlz4dir() {
    tar -xf $1
    find .lz4 -type f  | ffilter |  xargs -n 1 -P $PACORES unlz4 -m --rm
    mv .lz4/* . 
    rm -rf .lz4
}
function rsynctype() {
    echo '[Info] Copy only certain file extension to new directory Args :"$1" = type , "$2"= directory '
    echo "[Question] Run the command? (yes / others for skip)"
    read option
    case $option in 
         yes) 
        rsync -rv --include '*/' --include '*.$1' --exclude '*' --prune-empty-dirs $2 rsync_type
        ;;      
       *) 
        echo "[Command]rsync -rv --include '*/' --include '*.$1' --exclude '*' --prune-empty-dirs $2 rsync_type"
        ;;
    esac
}

## This script helps cleaning brew cache.
function brewcc () {
    rm  $HOME/.cache/Homebrew/*
    rm  ~/Library/Caches/Homebrew/*
}

function getlicense() {
tee LICENSE.h <<-'EOF'
/**
# Copyright 2017 Ralic Lo<ralic.lo.eng@ieee.org> . All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*//
EOF
}

function multijobs() { 
tee multijobs.sh <<-'EOF'
    echo "[Info] default job file name = hello.txt"
    if [[ $# -eq 0 ]] 
        then
            filename=hello.txt ## commands TBD
        else
            filename=$1
    fi
    folder=runners  ## runners to remmember where the runner is
    begin=1 ## Beginning lines, default : 1
    range=$(wc $filename -l | awk '{print $1}') ## threshold for TBD files.
    processX=10 ## create how many sub-processes
    sleeper=1 ## sleeper how many secs
    count=0;
    mkdir $folder
    for ((i=$begin;i<=range;i++)); do
            if [ $((i%processX)) -eq 0 ]
                then
                    # cline $((i)) $filename 
                    cline $((i)) $filename > $folder/run.$((i))
                    . $folder/run.$((i)) &
                    echo "[Info] Line: "$count , "Sleep " $sleeper " secs"
                    sleep $sleeper
                else
                    #cline $((i)) $filename
                    cline $((i)) $filename > $folder/run.$((i))
                    . $folder/run.$((i)) &
            fi
            count=$((count+1))
    done
    echo "[INFO] Process list -- "$filename "completed"
    ls $folder
    echo "[INFO] Say ((yes)) to remove temp folder:"
    read option
    case $option in
            yes)
                rm $folder/run.*
                rmdir $folder
            ;;
                    *)
                echo "[Info]enter "$folder" to cleanup records."
            ;;
    esac
EOF
    
    chmod 700 multijobs.sh

    echo "[Info] Generated multijob runner"
    echo "[Info] ex: ./multijobs jobs.file "
    echo "filename = hello.txt ## @param filename to run"
    echo "begin=1 ## Beginning line"
    echo "range=@endofline ##  @param Track to the last line of file"
    echo "processX=10 ## @param how many sub-processes in a batch"
    echo "sleeper=1 ## @param  how many secs in next batch run"
    echo "count=0;"
}

### List all npm packages with only one level of depth
alias ng1="npm list -g --depth=1"

## This script helps reinstalling all brew packages. 
## Note: It's good for reinstalled packages from developer's brew repository
## git clone https://github.com/ralic/cellar-backup

function rebrewall () {
    unset PYTHONPATH
    brew list | grep -v gettext | grep -v gcc| grep -v llvm| xargs brew deps --tree
    brew list | xargs brew reinstall --build-bottle
    # brew upgrade
    ## --overwrite --force 
}
function rebrewa() {
  brew reinstall $1 --build-bottle --no-sandbox
}

function relinkbrew () {
   ## Remove --force
   brew list | xargs -n 1 -P $PACORES brew link --overwrite $1 | grep Warning | grep keg-only
}

function brewtree () {
    brew upgrade
    brew list | xargs brew deps --tree > brew.tree
    cat brew.tree
}

## This script helps porting all python scripts to python3 .
## Prequisite : brew install xargs python3
function allpy3() {
    find . -name '*.py' | xxargs 2to3-3.6 -w
    find . -name '*.bak' | xxargs  rm
}
function gotravis(){
	mkdir backup
	echo message.txt >> .gitignore
	cp .travis.yml backup
	cp requirements.txt backup
	## Get travis setup from dropbox
	dget .travis.yml
	dget requirements.txt
	dget helpTest.py
	## Get package name from setup.py ## | cut -d'"' -f 2
	PY3PKG=$(cat setup.py | grep 'name=' | sed s/..$// | sed s/.*=.//) 
	# PY3PKG=$(cat setup.py | grep 'py_modules' | sed 's/...$//;s/.*=//;s/^ *//;s/ *$//;s/^..//')
	## Fetch info from pip3 , sometimes nothing.
	pip3 show $PY3PKG >> message.txt  
	## Fulfill all previous requirement
	cat backup/requirements.txt > requirements.txt 
	## Repace default pkgname
	replacetxt 'Bat-belt' $PY3PKG '.travis.yml' 
	git add .travis.yml
	git add requirements.txt
	git add helpTest.py
	git add .gitignore
}

## This script helps upgrading all installed python3 packages.
function repip3() {
    pip3 list | awk '{print "echo [Info]pip3 install --upgrade "$1";pip3 install --upgrade "$1}' > pip3.tmp
    ### some packages may gets downgraded 
    cat pip3.tmp | grep -vF "echo [Info]pip3 install --upgrade azure;pip3 install --upgrade azure"| grep -vF "echo [Info]pip3 install --upgrade azure-mgmt;pip3 install --upgrade azure-mgmt" > pip3.update
    rm pip3.tmp
    echo "pip3 install --upgrade py4j jupyter bleach" >> pip3.update 
    echo "rm -rf ~/Library/Caches/pip" >> pip3.update
    . pip3.update
}

## This script generates hello_1~ hello_100 into hello.txt
function hi100() {
     for i in {1..100};do echo "echo "hi_$((i)) >> hello.txt;done
     cat hello.txt
}

## Find only executables
## This sciprt help search for all executables
function findexe() {
	 if [ "$(uname -s)" == "Darwin" ]; then
         gfind . -executable -type f | xargs file > execfile.log;
     else
         find . -executable -type f | xargs file > execfile.log;
     fi
     cat execfile.log
}

## This script shows you example how to parallel ping differnt servers
function pping() {
     parallel -j0 ping -nc 3 ::: qubes-os.org gnu.org freenetproject.org
     parallel --help
}

## This function helps you genenrate a text file without editor
## USAGE : teec "filename" 
alias teec="echo '[Info] Generate a excutable or readable text file';echo '[Info] Type EOF to end the shell';tee $1 <<-'EOF'"

### Replacing orginal Mac build 
function ignu7() {
    alias ld=/usr/local/bin/ld 
    alias gcc-ar=gcc-ar-7
    alias gcc-nm=gcc-nm-7
    alias gcc-ranlib=gcc-ranlib-7
    alias nm=gnm
    alias nm=gcc-nm-7
    alias ranlib=gcc-ranlib-7
    alias gcov=gcov-7
    alias gcov-dump=gcov-dump-7
    alias gcov-tool=gcov-tool-7
    alias c++=c++-7
    alias cpp=cpp-7
    alias gcc="gcc-7 -Ofast"
    alias g++=g++-7
    alias fortran=gfortrain
    alias libtoolize=glibtoolize
    alias libtool=glibtool
    alias ar=gar
    alias grep=ggrep --color=always
    alias sed=gsed
}

function unlikeg() {
    unalias ld
    unalias gcc-ar
    unalias gcc-nm
    unalias gcc-ranlib
    unalias nm
    unalias ranlib
    unalias gcov
    unalias gcov-dump
    unalias gcov-tool
    unalias c++
    unalias cpp
    unalias gcc
    unalias g++
    unalias fortran
    unalias libtoolize
    unalias libtool
    unalias ar
    unalias tar
    unalias grep
    unalias sed
}

## NOTE :
alias jp3="python3 /usr/local/lib/python3.6/site-packages/jupyter.py notebook"

## Perl5 upgrade // Run once 
# PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
# echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> ~/.bash_profile

## Rust  & Weld Support
## curl https://sh.rustup.rs -sSf | sh
export PATH="$HOME/.cargo/bin:$PATH"
export WELD_HOME="~/.weld"

## Reset lib prioirty
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport"
alias nets="/usr/sbin/networksetup -listallhardwareports"
export PATH="$UsrPATH/$UsrNAME/work/.npm/bin:$PATH"

## Customized / Shared package path for multi-OS version
export PATH="$OPT_PREFIX/opt/python3/Frameworks/Python.framework/Versions/3.6/bin:$PATH"

# mkdir -p /Volumes/data/python/3.6/site-packages
# cp -rf /usr/local/lib/python3.6/site-packages /Volumes/data/WorkSpace/python/3.6/site-packages
# rm -rf /usr/local/lib/python3.6/site-packages
# ln -s -f /Volumes/data/WorkSpace/python/3.6/site-packages /usr/local/lib/python3.6/site-packages 
# ln -s -f /usr/local/lib/python3.6/site-packages /Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages
# ln -s -f /usr/local/bin/glibtoolize  /usr/local/bin/libtoolize
function gopy3() {
	if [ "$(uname -s)" == "Linux" ]; then
		cd "/home/linuxbrew/.linuxbrew/lib/python3.6/site-packages"
	fi
	if [ "$(uname -s)" == "Darwin" ]; then
		cd "/usr/local/lib/python3.6/site-packages"
	fi
}
alias gonpm="cd /usr/local/lib/node_modules"

### List of Setting
alias mvp='mvn -version'

### GLOBALS ###
function macdev() {
    CPPFLAGS="-I/usr/include/ -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
    ARCHFLAGS="-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
    # LDFLAGS="-L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib -L/usr/lib"
    LD_LIBRARY_PATH="/Applications/Xcode.app/Contents/Developer/usr/lib/:$LD_LIBRARY_PATH"
    PATH="/Applications/Xcode.app/Contents/Developer/usr/bin/:$PATH"
    getflags
}

function sublin(){
    echo "[Info] sublin, Function to install sublime editor as CLI EDITOR"
    echo "
    [Info] Sublime support for debian based linux
    sudo ln -s /opt/sublime/sublime_text /usr/bin/subl
    echo 'deb https://download.sublimetext.com/ apt/stable/' | sudo tee /etc/apt/sources.list.d/sublime-text.list
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-get update ; sudo apt-get install sublime-text"
    if [ $(cat /usr/local/bin/subl  | wc -l) -ne 2 ] ; then 
            if [ "$(uname -s)" == "Linux" ]; then
                    tee /usr/local/bin/subl <<-'EOF'
                #!/bin/bash
                /usr/bin/subl "$@"
EOF
            elif [ "$(uname -s)" == "Darwin" ]; then
                        tee /usr/local/bin/subl <<-'EOF'
                 #!/bin/bash
                 '/Applications/Sublime Text.app/Contents/MacOS/Sublime Text' "$@"
EOF
            fi
    fi
    chmod 500 /usr/local/bin/subl 
    echo "--- Installed /usr/local/bin/subl ----"
}

function getflags() {
    echo "________________________________________________________________________________"
    echo -e "COMPILERS: @FC=" $FC "@CC="$CC "@CPP=" $CPP "@CXX=" $CXX "@CXXCPP=" $CXXCPP 
    echo -e "@ARCHFLAGS=$ARCHFLAGS \n@CFLAGS=$CFLAGS \n@FFLAGS=$FFLAGS \n@LDFLAGS=$LDFLAGS \n@CPPFLAGS=$CPPFLAGS"
}


function linkopts() {
    NEXTLIB="$@"
    OPT_PREFIX=$OPT_PREFIX
    export LDFLAGS="-L$OPT_PREFIX/$NEXTLIB/lib $LDFLAGS"
    export CPPFLAGS="-I$OPT_PREFIX/$NEXTLIB/include $CPPFLAGS"
    export PATH="$OPT_PREFIX/$NEXTLIB/include:$PATH"
    export PKG_CONFIG_PATH="$OPT_PREFIX/$NEXTLIB/lib/pkgconfig:$PKG_CONFIG_PATH"
    # getflags
}


##  Note . 2017.09.18
##  In brewed libs, i686 .
##  "readline"  is placed in readline folder, so it can't be loaded this way.
##  1. Copy /usr/local/opt/readline/include/readline to /usr/local/include
##  2. ln -s /usr/local/opt/readline/include/readline /usr/local/include/readline
##  "bzip2" may have some bug, so do not link it.

# LDFLAGS="-L/usr/local/lib -L$(brew --prefix e2fsprogs)/lib $LDFLAGS"
declare -a liblist=(
    # "openssl" 
    # "openssl@1.1" 
    "llvm" "ncurses" 
    "lapack" "openblas"
    # "boost" "boost-mpi" "boost-python"
    # "open-mpi" "tbb"
    # "xz" "zlib" "bison" 
    # "gettext"  				## May cause mac running to infinite loop
    # "gmp" "mpfr" "isl" "libmpc"			## GCC related
    # "gcc" "bzip2" "readline"
    # "libkml" "libtool" "libunistring" "libiconv"
    # "binutils" "sqlite" "icu4c"
    # "thrift" "libarchive"  "aws-sdk-cpp" ## for osquery
    "opencl" "grt"
    # "suite-sparse" "valgrind"
    # "python3"
    # "rtmpdump" "libmetalink" ## Powerful curl related
    )

function printlibs {
	## FILO printlibs
    mkdir -p ~/.cache > /dev/null
    Nliblist=$((${#liblist[@]}))
    echo "Total libs  = " $Nliblist
    echo "" > ~/.cache/brewlibs.db 
    echo "" > ~/.cache/brewlibs.links
    while [ $((Nliblist )) -gt 0 ]   ;
    do
    Nliblist=$((Nliblist - 1))
    echo "$Nliblist ${liblist[$Nliblist]}" 
    echo ${Nliblist}" "${liblist[$Nliblist]} >> ~/.cache/brewlibs.db
    echo linkopts ${liblist[$Nliblist]} >> ~/.cache/brewlibs.links
    done
    echo "~/.cache/brewlibs.db:"
    cat ~/.cache/brewlibs.db
    echo "~/.cache/brewlibs.links:"
    cat ~/.cache/brewlibs.links
}   

function printlibs2 {
	## FIFO printlibs , not working in dash.
    mkdir -p ~/.cache > /dev/null
    Nliblist=${#liblist[@]}
    echo "Total libs  = " $Nliblist
    echo "" > ~/.cache/brewlibs.db 
    echo "" > ~/.cache/brewlibs.links
    for (( libn=1; libn <${Nliblist}+1; libn ++ ));
    do
    echo $libn " "${Nliblist}" "${liblist[$libn -1]} >> ~/.cache/brewlibs.db
    echo linkopts ${liblist[$libn -1]} >> ~/.cache/brewlibs.links
    done
    echo "~/.cache/brewlibs.db:"
    cat ~/.cache/brewlibs.db
    echo "~/.cache/brewlibs.links:"
    cat ~/.cache/brewlibs.links
}   

function bootlibs {
    . ~/.cache/brewlibs.links
    getflags
}

function keylibs() {
    export LDFALGS="-L$BREW_PREFIX/lib $LDFLAGS"
    export CPPFLAGS="-I$BREW_PREFIX/include $CPPFLAGS"
    export LDFLAGS="-L$OPT_PREFIX/readline/lib $LDFLAGS"
    export CPPFLAGS="-I$OPT_PREFIX/readline/include/readline $CPPFLAGS"
    export PKG_CONFIG_PATH="$BREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
    export LINKFLAGS="$CPPFLAGS"
}

function morelibs(){
    linkopts portable-expat
    linkopts portaudio
    linkopts qt
    linkopts metis
    linkopts opencv
    linkopts cython
}

#   ------------------------------------------------------------
#   Set Global Paths
#   ------------------------------------------------------------
# export PATH="/bin:/sbin:/usr/bin:$PATH"
# export PATH="/usr/include:/usr/lib:$PATH"
#   ------------------------------------------------------------

#   ------------------------------------------------------------
#   Brew first Paths : Comment them out for fresh system.
#   ------------------------------------------------------------
export PATH="/usr/local/bin:/usr/local:/usr/local/sbin:/usr/local/include:/usr/local/lib:/opt/aws/bin:$PATH"
export PATH="$BREW_PREFIX/bin:$PATH"
export PATH="$BREW_PREFIX/sbin:$PATH"
export PATH="$BREW_PREFIX/lib:$PATH"
export PATH="$BREW_PREFIX/include:$PATH"
export MANPATH="$BREW_PREFIX:/share/man:$MANPATH"
export INFOPATH="$BREW_PREFIX/share/info:$INFOPATH"
export LDFALGS="-L/home/linuxbrew/.linuxbrew/lib $LDFALGS"
export CPPFALGS="-I/home/linuxbrew/.linuxbrew/lib $CPPFALGS"

### CMAKE FLAGS SUPPORT
export CMAKE_CXX_FLAGS="-isystem $CPPFLAGS /usr/local/include" 
export CMAKE_CFLAGS="-Wall -Ofast $CFLAGS $MATHFLAGS" 
export CMAKE_C_FLAGS="-Wall -Ofast  $MATHFLAGS" 
export CMAKE_CXX_FLAGS_DEBUG="-Wall -Ofast $MATHFLAGS"
export PROJ_LIB="~/work/proj"

### flutter support
export PATH="~work/flutter/bin:~/work/flutter/bin:$PATH"

function cumakes() {
    ##\ /usr/include 
    cmake -G 'Unix Makefiles' -DCMAKE_CXX_FLAGS=
    cmake -G 'Unix Makefiles' -DCMAKE_CXX_FLAGS=-isystem -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/$1
    make -j$PACORES -k
}
START_UP@END

# Finished adapting your PATH environment variable for use with MacPorts.
# export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

#### MAc OS related script #### 
# export PATH="$PATH:/Volumes/data/WorkSpace"
    ## For mac -- To view du like linux 
    # function duh () {
    #   du -k $1 $2 $3 $4 | awk '{if($1>1024){r=$1%1024;if(r!=0)
    #      {sz=($1-r)/1024}else{sz=$1/1024}print sz"Mt"$2;}
    #      else{print $1"Kt"$2}}'
    # } 
    # alias du=duh

# ln -s /usr/local/bin/python3 /usr/local/bin/python 
# alias python=python3 
# export PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/include/:$PATH"
# export PATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/4.2/include:$PATH"
##/bin/cp /usr/local/Cellar/gettext/0.19.8.1/lib/libintl.8.dylib /usr/local/lib/libintl.8.dylib

#PATH=/Users/ralic/work/flutter/flutter/bin:/Users/ralic/work/flutter/flutter/bin:/usr/local/opt/llvm/include:/usr/local/opt/ncurses/include:/usr/local/opt/lapack/include:/usr/local/opt/openblas/include:/usr/local/opt/opencl/include:/usr/local/opt/grt/include:~work/flutter/bin:~/work/flutter/bin:/usr/local/include:/usr/local/lib:/usr/local/sbin:/usr/local/bin:/usr/local/bin:/usr/local:/usr/local/sbin:/usr/local/include:/usr/local/lib:/opt/aws/bin:/usr/local/opt/opt/python3/Frameworks/Python.framework/Versions/3.6/bin:/Users//work/.npm/bin:/Users/ralic/.cargo/bin:/Volumes/data/WorkSpace/gcloud/google-cloud-sdk/bin:~/work/.npm/bin:/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:/Library/Developer/CommandLineTools/usr/bin:/usr/local/opt/qt/bin:/Applications/RStudio.app/Contents/MacOS:/opt/X11/bin:/usr/local/cuda/bin:/usr/local/cuda/nvvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/ralic/Library/Android/sdk/platform-tools:/Users/ralic/Library/Android/sdk/tools:/Users/ralic/golang/bin:/usr/local/opt/go/libexec/bin:/usr/local/opt/apache-spark/libexec:/usr/local/opt/apache-spark/libexec/sbin:/usr/local/mysql/bin:/bin:/bin
