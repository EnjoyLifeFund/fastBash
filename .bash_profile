#!/bin/bash
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

## Set Default Editor , Priority : Sublime -> Nano -> Vim
## Supported brew edit, git commit
export TEXT_Editor=/usr/bin/subl || /usr/bin/nano || /usr/bin/vis
export EDITOR=/usr/bin/subl || /usr/bin/nano || /usr/bin/vis

# CC          C compiler command ## gcc
# CFLAGS      C compiler flags
# CXX         C++ compiler command ## gcc
# CXXFLAGS    C++ compiler flags ## gcc-E
# CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> 
# LDFLAGS     linker flags, e.g. -L<lib dir> 
# LIBS        libraries to pass to the linker, e.g. -l<library>
# CPP         C preprocessor ## gcc -E
# CXXCPP      C++ preprocessor


## TODO --
# --with-cxxflags='-mmic ' \
# --with-cflags='-mmic '
# --flto-compression-level  ## LTOFLAS Controls 
CCSET="gcc"
function setcc() {
	echo "PACORES="$PACORES
    echo "[Info] setcc ,Function to change compiler settings. CCSET="$CCSET
    case $CCSET in
        "gcc-7") ## GCC ##
            FC="gfortran-7";CC="gcc-7";CXX="gcc-7" ;CPP="gcc-7 -E";CXXCPP="gcc-7 -E"
            export HOMEBREW_CC="gcc-7"
        ;;
        "clang")  ## CLANG ##
            FC="gfortran";CC="cc";CXX="cc" ;CPP="gcc -E";CXXCPP="gcc -E"
            export HOMEBREW_CC="clang"
        ;;
        "mpicc") ## MPICC ##
        ## MPI version ##
	        FC="mpiftran"; CC="mpicc"; CXX="mpicxx" ; CPP="mpicc -E"  ;CXXCPP="clang -E"  
	        MPIFC="mpifort";MPICC="mpicc";MPICPP="mpicc -E" ;MPICXX="mpicxx"
	        #HOMEBREW_CC="mpicc"; HOMEBREW_CXX="mpicxx"
        ;;
        "gcc") ## GCC7 ##
            FC="gfortran";  CC="gcc" ;CXX="gcc" ; 
            # CPP="gcc -E" ; CXXCPP=" gcc -E" ;
            # export HOMEBREW_CC="cc"
        ;;    
        *) ## NO Setting as default ##

        ;;  
    esac
    brew --env
    # FLAGS_SET=$1
    ## change gcc to cc // 2017-06-08 ## change cc to mpicc //2017-09-07
## Note for CXXCPP: 2017.9.12 -- Using g++7 ok, not ok using clang-5 or mpicpp"
## Other options : g++ -E or gcc -E
}
MAKEJOBS="-j8"
alias cgrep="grep --color=always"

# export HOMEBREW_BUILD_FROM_SOURCE=1
### For Linux/Debian
if [ "$(uname -s)" == "Linux" ]; then

	## PARALLEL PROCESSING for lz4dir/xz4dir 
	PACORES=$(( $(grep -c ^processor /proc/cpuinfo) )) 
	PACORES=$(( $PACORES * 2 ))
    ## Linuxbrew Support
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
	JAVA_HOME="$OPT_PREFIX/jdk"
	system_VER=64
	#LTOFLAGS="-flto" # -m64 
	alias make="make $MAKEJOBS"
	COLOR_FLAG="--color=auto"

    ## Sublime support for debian based linux
    # sudo ln -s /opt/sublime/sublime_text /usr/bin/subl
    # echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    # wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    # sudo apt-get update ; sudo apt-get install sublime-text
    alias sll=subl
    export BREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

### For MacOS/Darwin
if [ "$(uname -s)" == "Darwin" ]; then
	
	PACORES=$(sysctl hw | grep hw.ncpu | awk '{print $2}')
	PACORES=$(( $PACORES * 2 ))
	 # f:            Opens current directory in MacOS Finder
    alias f='open -a Finder ./'                
    READLINK="readlink"
	# MACOSX_DEPLOYMENT_TARGET=$(sw_vers | grep ProductVersion | awk '{print $2}')
	# export MACOSX_DEPLOYMENT_TARGET="$MACOSX_DEPLOYMENT_TARGET"
	MACOSX_DEPLOYMENT_TARGET=10.8
	system_VER=64
	#LTOFLAGS="-flto " # -m32 -fopenmp  -m64 -m32 
	# Java Support
	JAVA_HOME=$(/usr/libexec/java_home)
	# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home
	# export JAVA6_HOME="/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home"
	# export JAVA8_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre"

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
	export BLOCKSIZE=4096
	## IMPORTANT Check it by : diskutil info / | grep "Block Size"

	## For mac -- To view du like linux 
	# function duh () {
	# 	du -k $1 $2 $3 $4 | awk '{if($1>1024){r=$1%1024;if(r!=0)
	# 	   {sz=($1-r)/1024}else{sz=$1/1024}print sz"Mt"$2;}
	# 	   else{print $1"Kt"$2}}'
	# } 
	# alias du=duh

	# alias find="gfind" ## [Waring Ignored] gfind: invalid argument `-1d' to `-mtime'
	# alias time="gtime -v"
	# alias python=python3

	# alias tar=gtar
	# alias xargs=gxargs ## Using GNU's xargs to enable -i feature.
	# ln -s /usr/local/bin/python3 /usr/local/bin/python
    alias make="gmake $MAKEJOBS"
    ## Be sure to create a /usr/bin/subl to link to sll.
    function sll() {
    	'/Applications/Sublime Text.app/Contents/MacOS/Sublime Text' $@  >& /dev/null
    }

    BREW_PREFIX="/usr/local"
fi

#### Completed OS related script #### 


export PKG_CONFIG_PATH="$BREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export PATH="$BREW_PREFIX/bin:$PATH"
export PATH="$BREW_PREFIX/sbin:$PATH"
export PATH="$BREW_PREFIX/lib:$PATH"
export PATH="$BREW_PREFIX/include:$PATH"
export OPT_PREFIX="$BREW_PREFIX/opt"

## Universal workspace for two or more versions of macOS development
alias apps='cd /Volumes/data/Applications'
alias linkapps='ln -s /Volumes/data/Applications $(pwd)/apps'   
alias work='cd /Volumes/data/WorkSpace'
alias linkwork='ln -s /Volumes/data/WorkSpace $(pwd)/work'
alias bp3='python3 setup.py bdist > dist.log;python3 setup.py install'

## Add this line for some python3 packages installation
# https://gcc.gnu.org/onlinedocs/gcc-4.9.2/gcc/Optimize-Options.html
# MPIFLAG=" -lelan lmpi"
# http://www.netlib.org/benchmark/hpl/results.html

MachineFLAGS="-mmmx  -msse -maes -march=native $LTOFLAGS" # -lpthread
MATHFLAGS="-ffast-math -Ofast -fno-signed-zeros -ffp-contract=fast $MachineFLAGS " #-mfpmath=sse+387 


### DEFAULT FLAGS SUPPORT
##http://www.netlib.org/benchmark/hpl/results.html
CFLAGS="-fomit-frame-pointer -funroll-loops  $MATHFLAGS "
CXXFLAGS="$MATHFLAGS "
FFLAGS="$CFLAGS  $MATHFLAGS "

### set gcc debug flag, Default is not to use it.
# DEBUGFLAG="-g"
alias cpx="cc -c $LDFLAGS $DEBUGFLAG $CFLAGS -Ofast -flto"

### CMAKE FLAGS SUPPORT
CMAKE_CXX_FLAGS="-Wall -Ofast $MATHFLAGS" 
CMAKE_CFLAGS="-Wall -Ofast $CFLAGS $MATHFLAGS" 
CMAKE_C_FLAGS="-Wall -Ofast  $MATHFLAGS" 
CMAKE_CXX_FLAGS_DEBUG="-Wall -Ofast $MATHFLAGS"
PROJ_LIB="~/work/proj"

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
### EXTRA LIB FLAGS ###
export CC="$CC"
export CPP="$CPP"
export CXX="$CXX"
export CXXCPP="$CXXCPP"


## QT Support
## OpenCV3 Support

## CUDA SUPPORT ##
export PATH="/usr/local/cuda/bin:/usr/local/cuda/nvvm/bin:$PATH"
export LDFLAGS="-L/usr/local/cuda/lib -L/usr/local/cuda/nvvm/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/cuda/include -I/usr/local/cuda/nvvm/include $CPPFLAGS"


## e2fslib support
# export PATH="$(brew --prefix e2fsprogs)/lib:$PATH"
## graphviz support 
## openblas support
## brew install openblas
export OPENBLAS_NUM_THREADS=32

## llvm support
## brew reinstall llvm -v --all-targets --rtti --shared --with-asan --with-clang --use-clang
export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/llvm/include -I/usr/local/opt/llvm/include/c++/v1/ $CPPFLAGS"


## rJava Support
#R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
#R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I$(/usr/libexec/java_home | grep -o '.*jdk')"

## Java 9 Support 
JAVA_9="/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home"

## Setting Locale
## locale
# https://www.gnu.org/savannah-checkouts/gnu/libc/manual/html_node/Locale-Categories.html

echo "________________________________________________________________________________"
export LC_ALL=en_US.UTF-8
uname -a

## Change CL to be colored for MAC
export CLICOLOR=1
export TERM="xterm-color" 

# export PATH=$OPT_PREFIX/gcc7/bin:$PATH
export PATH="$OPT_PREFIX/gcc/lib/gcc/7:$PATH"


## Python include/lib support
PYVM_VER=python3.6m ## python3.6dm for debug
#CPPFLAGS="-I/usr/local/opt/python3/include/$PYVM_VER $CPPFLAGS" 
#LDFLAGS="-L/usr/local/opt/python3/lib $LDFLAGS"

## GNU GCC setup for OSX
## GNU GCC/ BINUTILS SUPPORT
## brew install binutils
# export PATH="$OPT_PREFIX/mingw-w64/bin:$PATH"
export MANPATH="$OPT_PREFIX/gnu-sed/libexec/gnuman:$MANPATH" ## man gsed for gnused
export MANPATH="$OPT_PREFIX/coreutils/libexec/gnuman:$MANPATH"
export PATH="$OPT_PREFIX/coreutils/libexec/gnubin:$PATH"
export LDFLAGS="-L/usr/local/Cellar/gcc/7.2.0/lib/gcc/7  $LDFLAGS" 
export CPPFLAGS="-I/usr/local/Cellar/gcc/7.2.0/lib/gcc/7/gcc/x86_64-apple-darwin17.0.0/7.2.0/include  $LDFLAGS" 

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
# export PATH=/Library/Developer/CommandLineTools/usr/bin:$PATH

##SWIFT SUPPORT
export PATH="/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:$PATH"

# TOMEE-PLUS
export PATH="$PATH:$OPT_PREFIX/tomee-plus/libexec/bin"

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

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home/jre
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

    #Git branch support
    #https://github.com/jimeh/git-aware-prompt
    # export GITAWAREPROMPT=~/.bash/git-aware-prompt
    # source "${GITAWAREPROMPT}/main.sh"
    export PS1="________________________________________________________________________________\n \[\e[1;13m\]\w\[\e[0m\] @ \[\e[1;35m\]\h\[\e[0m\] (\[\e[1;92m\]\u\[\e[0m\]) \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[\e[0m\] \n|=> "
    export PS2="| => "
    export SUDO_PS1="________________________________________________________________________________\n \[\e[1;13m\]\w\[\e[0m\] @ \[\e[1;35m\]\h\[\e[0m\] (\[\e[1;92m\]\u\[\e[0m\]) \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[\e[0m\] \n|=> "
    export SUDO_PS2="| => "


#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
#   export CLICOLOR=1
#   export LSCOLORS=ExFxBxDxCxegedabagacad

#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------
# alias gtime='/usr/local/opt/gnu-time/bin/time'
# alias gmake='/usr/local/opt/make/bin/gmake'

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ls="ls $COLOR_FLAG"					# Ensure ls will display color
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
alias edit='subl'                           # edit:         Opens any file in sublime editor
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
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

alias numFiles='echo "Total files in directory:" $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

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
            *.7z)        7z x $1        ;;
			*.lz4)       unlz4 $1       ;;
          	*.tar.lz4)   u4dir $1	    ;;
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

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

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
	# 	echo $! >test.pid | cat test.pid 
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

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
    function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

alias servall='sudo kill $(lsof -t -i:80,443,8080)&& echo "Killed processs on 80,443,8080"' # Reset all Http ports
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
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
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
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

#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat


##### Dropbox_shell integration #####
# #Looking for dropbox uploader
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


SHELL_HISTORY=~/.dropshell_history
DU_OPT="-q"
#BIN_DEPS="id $READLINK ls basename ls pwd cut"
DU_VERSION="0.2"

umask 077

#Dependencies check
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

function dls
{
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

function dcd
{
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

function dget
{
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

function dput
{
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

# Finished adapting your PATH environment variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

function ccpu () {
    echo "[Info] ccpu, Function to show the gpu's strength"
	if [ "$(uname -s)" == "Linux" ]; then
	        /bin/cat /proc/cpuinfo &&
	        lscpu
	fi

	if [ "$(uname -s)" == "Darwin" ]; then
	  	   system_profiler SPHardwareDataType
		   sysctl -n machdep.cpu.brand_string
	       sysctl hw && 
	       system_profiler >> sysinfo && ## This command takes a long time
	       echo "> cat sysinfo < to see result"
	fi
}

function cgpu () {
    echo "[Info] cgpu, Function to show the gpu's strength"
	if [ "$(uname -s)" == "Linux" ]; then
	        lspci  -v -s  $(lspci | grep VGA | cut -d" " -f 1) 
	fi

	if [ "$(uname -s)" == "Darwin" ]; then
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
	arg1 = $(sudo lsof -t -i:8080)
    sudo kill $arg1 && echo "Killed processs on" $1
}

function rcf () {
    echo "[Info] rcf, Function to find rows and columns of a file, delimitor is a space ' '' "
	echo File name: $1
	awk '{ print "Rows : "NR"\nColumns : "NF }' $1
}

function tsfile () {
    echo "[Info] tsfile, Function that transverse a file."
	awk '
	{
	    for (i = 1; i <= NF; i++) {
	        if(NR == 1) {
	            s[i] = $i;
	        } else {
	            s[i] = s[i] " " $i;
	        }
	    }
	}
	END {
	    for (i = 1; s[i] != ""; i++) {
	        print s[i];
	    }
	}' $1
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

##
## Port Scann for certain IP
##
function allport() {
    nmap -Pn $1 >> ps_reports&
}

##
## Show Kernal's Threads Counts // MAC only
##
function cthread () {
    sudo sysctl  -A | grep thread
	if [ "$(uname -s)" == "Darwin" ]; then
	    sysctl kern.maxproc
		sysctl kern.maxvnodes
		sysctl kern.maxfiles
	fi
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
        z=10000
        zz=0
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
	openssl enc -in $1 -out cry.out -e -aes256 -k $2 --salt
	echo "Target File: " $1 " encrypted as cry.out"
}

## Decrypt file with password
## Usage dontcry filename password 
## Author : Ralic Lo

function dncry() {
	openssl enc -in $1 -out dncry.out -d -aes256 -k $2
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


## Reference : 
## This script help you build ios and android app easier.
## Usage : capp
## Prerequesite : gomobil, cios, cadnd
## Author: Ralic Lo

function capp () {
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
        cordova plugin add cordova-plugin-http
        cordova plugin add cordova-plugin-camera
        cordova plugin add cordova-plugin-bluetoothle
        cordova plugin add cordova-plugin-ble-central
        ## Default Icon from Rstudio.
        curl https://www.rstudio.com/wp-content/uploads/2014/06/RStudio-Ball.png >icon.png
        cordova-icon
        curl 
        ;;
        reacts)
        reacts
        ;;
        cfav)
         ## Default Icon from Rstudio.
        curl https://www.rstudio.com/wp-content/uploads/2014/06/RStudio-Ball.png >icon.png
        cordova-icon
        curl http://www.iloveheartstudio.com/_cat/1500/world/continents/far-east/taiwan.png >splash.png
        cordova-splash
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

## This script allows you to use cordova-cli to run android project
## Usage : cadnd
## Prerequesite : Execute under a cordova project root directory
## Author: Ralic Lo

function cadnd() {
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

## This script allows you to use react-native cli to run android project
## Usage : reacts , choose option
## Prerequesite : node.js&npm , XCode , Android Studio, Android Build Tools 23.0.1
## Author: Ralic Lo

function reacts () {
    echo "options : (install) | (init) | (web) | (ios) | (android)"
    read option
    case $option in 
        setup)
            echo "[Info] Install React-native-cli"
            npm install -g react-native-cli
            echo "[Info] Install Sutiable Android build tools"
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
## This script allows you to use cordova-cli to run ios project on Mac
## Usage : geny
## Prerequesite : Must have genymotion installed
## Author: Ralic Lo

function geny(){
    #Alternative android avd
    #REF: https://facebook.github.io/react-native/docs/android-setup.html
    open /Applications/Genymotion.app
}


## This script allows you to update github master .. 
## Usage : Use it carefully..
## Under Development
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
## Usage : Use it carefully..
## For CentOS/RedHat system
## Author: Ralic Lo

function redIP() {
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    # sysctl net.ipv4.ip_forward=1
    iptables -t nat -A PREROUTING -s $1 -p tcp --dport 22 -j DNAT --to-destination $1
    ################################ IP ############# PORT ######################  IP
}

## This script helps to setup docker on macOS
## Usage : 
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
    echo [Info] For Kaggle : 'docker run -it -p 8787:8787 --rm -v /Users/mchirico/Dropbox/kaggle/death:/tmp/working  kaggle/rstats /bin/bash -c "rstudio-server restart & /bin/bash"'
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
    /Users/$(id -un)/work/electron-api-demos/node_modules/electron-prebuilt/dist/Electron.app/Contents/MacOS/Electron "$@"
    fi
}

function composer () {
## Exit if no args.
if [[ $# -eq 0 ]] ; then
    echo [Error] No arguments.
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
     # [Linux] 
     # ip -6 addr show eth0| grep inet6 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/'
     #[Linux] 
     # ip -6 addr show en0| grep inet6 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/'
    ip -6 addr show en0 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/'
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
## It works under a router.
function linkme() {
    echo open https://[$(myipv6)]
    surl https://[$(myipv6)]
    open https://[$(myipv6)] 
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

function ggit() {
    echo "options: (load) gcloud | (init) credential |  (info) project/repository  "
    echo "options: (add) google  | (push) to google  |  (clone) from google "
    read option
    case $option in 
        load) 
            # The next line updates PATH for the Google Cloud SDK.
            source '/Users/raliclo/private/google-cloud-sdk/path.bash.inc'
            # The next line enables shell command completion for gcloud.
            source '/Users/raliclo/private/google-cloud-sdk/completion.bash.inc'
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
            [Info] Use "load" before running any commands.
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
    rm -R '/Users/raliclo/Library/Caches/Google/Chrome/Default/Media Cache'
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
function cmiot() {
    usg=ALkJrhi7ckC8KCnB15kFgAPpSMtdQ6YLmg
    TT_API="https://translate.googleusercontent.com/translate_c?depth=2&nv=1&rurl=translate.google.com&sl=auto&sp=nmt4&tl=zh-TW&u="
    cmio $TT_API"$@"$usg
}

## This script is to use google's website tranlation to english
alias ggzh=cmiot

function cmioten() {
    TT_API="https://translate.google.com/translate?depth=1&hl=en&nv=2&rurl=translate.google.com.tw&sl=auto&sp=nmt4&tl=en&u="
    cmio $TT_API"$@"
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
#                  gradle installDebug 

#                echo [Info] Please Select again.
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

## This script is powerful touch, that enforce to create a file in the path.

ptouch() {
    for p in "$@"; do
        _dir="$(dirname -- "$p")"
        [ -d "$_dir" ] || mkdir -p -- "$_dir"
    touch -- "$p"
    done
}


## This script is powerful wget to get a website clone.
## https://www.guyrutenberg.com/2014/05/02/make-offline-mirror-of-a-site-using-wget/
## RATE LIMIT : 
## ‐‐limit-rate=200k ‐‐wait=60
## Simplified : wget -mkEpnp http://example.org

uberget() {
    wget  ‐‐random-wait  -e robots=off  --mirror --adjust-extension --page-requisites  --user-agent=Mozilla --convert-links --no-parent -r -x "$1"
}

## This script is to build Java program using gradle with all cores.
## gjob : build parallely and never stop when failure
## glist : list all partial projects

gjob() {
    gradle build --parallel --daemon --continue "$@"
    # --configure-on-demand 
}

glist() {
  gradle build --parallel --daemon  -q projects 
  # --configure-on-demand 
}
## This script is to use google's website tranlation to english
gen() {
	trans_prefix="https://translate.google.com/translate?hl=en&sl=auto&tl=en&u="
	open $trans_prefix$@
}


## This command help read specific line in a file
## Format : cline line#  (filename)
## Example : cline 10 (test.txt)
cline() {
    awk NR=="$@"
}

## This script helps move first few lines to new file
## Format

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

adup() {
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
golive() {
    gulp_loc=g
    yes| cp ~/$(echo $gulp_loc)/gulpfile.js .
    npm install gulp gulp-live-server live-server --save
    live-server
}

## this script help you find x/y coordinate of a location

gps () {
    if [ "$#" -lt 1 ]
    then
      echo "input error"
      echo "usage: $0 <adderss>"
      echo "example usage: gps Taiwan"
    fi

    address=$1

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
# function mysqlboot() {}
    ##https://gist.github.com/fallwith/987731#file-homebrew_mysql_pass_reset-txt
    ## 0) Check Mysql Root password
    # cat /usr/conf/mysql.conf
    # 1) Stop Mysql
    # /etc/init.d/mysql stop
    # 2) Start Mysql Safe
    # mysqld_safe -skip-grant-tables &
    # 3) Start Mysql
    # /etc/init.d/mysql start
    # 4) Login as root
    # mysql -u root -p
    # kill `cat /mysql-data-directory/host_name.pid`

## This script help creates a bootable mac usb for sierra
## Change usbName for different Volume.
## https://support.apple.com/en-us/HT201372

function createUSB() {
    macVersion=Sierra
    usbName=MinionDisk
    sudo /Applications/Install\ macOS\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/$usbName --applicationpath /Applications/Install\ macOS\ Sierra.app --nointeraction &&say Done
}

## This script help print a template for configuration of Cmake
function ccmake() {
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
    cd "$@"
    hub create gnu_"$@"
    git push --force --mirror https://github.com/ralic/gnu_"$@".git
    cd ..
    # rm -rf "$@"
}

## https://www.npmjs.com/package/gh
## http://nodegh.io/
## https://github.com/node-gh/gh
#git clone https://github.com/sametmax/0bin.git
##origin	https://github.com/Python3pkg/diveintopython3 (push)

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

## This script help remove the last character of a file, whatever it is 
function nolast() {
    sed 's/.$//' "$@" > "$@".nolast
}

## This script help remove the first character of a file, whatever it is 
function nofirst() {
    sed 's/^..//'  "$@" > "$@".nofirst
}

## This script help report the difference of two files
function idf () {
	echo "[Info] Report comparision, LEFT: GCC, RIGHT : Clang"
	### sdiff or icdiff
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
	BOT_PATH=~/work/bottles/tmpbot/"$1"
	mkdir -p $BOT_PATH;cd $BOT_PATH
	echo $BOT_PATH > bot_path
	brew info "$1" > message.txt
	uname -ov >> message.txt
	brew install "$@" --build-bottle  > autobot.log
	brew upgrade "$@" --build-bottle  >> autobot.log
	brew bottle "$@" >> autobot.log
	brew postinstall "$@"
}

function botok(){
	s1=1
	s2=$(cat autobot.log  | grep 'bottle do'|wc -l)
	if [ "$s1" == "$s2" ]
	then
		sed -i '1s/\(.*\)/[SUCCESSED]\1/' message.txt 
	else 
		sed -i '1s/\(.*\)/[FAILED]\1/' message.txt 
	fi
	yes|cp -rf * ~/work/bottles
	cd ~/work/bottles
	gitmsg
}

function brewbot() {
	unlink /usr/local/bin/python
	unset PYTHONPATH;unalias python;brew upgrade --build-bottle
	ln -s /usr/local/bin/python3 /usr/local/bin/python
}

function autobots () {
 	brew outdated  > tobe.bot
 	tee tobe.run <<-'EOF'
function bot() {
	BOT_PATH=~/work/bottles/tmpbot/"$1"
	mkdir -p $BOT_PATH;cd $BOT_PATH
	echo $BOT_PATH > bot_path
	brew info "$1" > message.txt	
	uname -ov >> message.txt
	brew install "$@" --build-bottle  > autobot.log
	brew upgrade "$@" --build-bottle  >> autobot.log
	brew bottle "$@"  >> autobot.log
	brew postinstall "$@"
}
function botok(){
	s1=1
	s2=$(cat autobot.log  | grep 'bottle do'|wc -l)
	if [ "$s1" == "$s2" ]
	then
		sed -i '1s/\(.*\)/[SUCCESSED]\1/' message.txt 
	else 
		sed -i '1s/\(.*\)/[FAILED]\1/' message.txt 
	fi
	yes|cp -rf * ~/work/bottles
	cd ~/work/bottles
	gitmsg
}
function gitmsg() {
	git add *;git commit -F message.txt;git push
}
EOF
     cat tobe.bot | awk '{print "bot "$1";botok"}' >> tobe.run
     echo 'brew cleanup' >> tobe.run
     echo '[Info]  Do you want to start auto bottles ? (yes/press enter to skip)'
     unset option
     read option 
     case $option in
	        yes)
				echo '[Info] Running Autobot'
				. tobe.run  &
	        ;;
	        *)
				$(pwd)/tobe.run
     			echo '[Info] execute  ". tobe.run &" to start auto bottles'
	        ;;
	esac
}

function brewbottles() {
	brew list | awk '{print "brew bottle "$1}' >bottle.list
	. bottle.list > bottle.log
}

function brewpush() {
	brewP="$1"
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
        cd /home/linuxbrew/.linuxbrew/Library/Taps/homebrew/homebrew-core/Formula/
    fi
    git remote set-url origin https://github.com/ralic/homebrew-core.git
}

function lfgf() {
    git remote set-url origin https://github.com/Homebrew/homebrew-core.git    
}

function gosystem() {
    cd /Library/Preferences/SystemConfiguration
}

function findtxt() {
	echo "[Usage] findtxt about 'keyword' recursively in current folder"
	echo "[Info] example : findtxt '/usr/bin/env python'"
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
}

function gftype() {
	echo "[Info] This support you to grep certian filename suffix"
	echo "[Usage] 'find . | gftype log' to find all *.log"
	grep ".*\."$1"$"
}

function replacetxt() {
	echo "[Usage] replacetxt  'old' 'new' 'filename'"
	echo "[Info] example : findtxt '/usr/bin/env python'"
    local search=$1
    local replace=$2
    local filename=$3
    # Note the double quotes
    sed -i "s/${search}/${replace}/g" $filename
}

function gitcopy() {	
	git clone --recursive --depth=50 --branch=master "$@"
}

function gitmsg() {
	git add *;git commit -F message.txt;git push
}
function gitsend() {
	git commit -F .git/COMMIT_EDITMSG;git push
}

function gitarget() {
	echo "[Usage] 'gitarget GithubTreeUrl', here the commited url is from browing github"
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

function gitgetsubs() {
	echo "[Info] Find all submodules directorys : cat submodules.txt"
	## Remove head and tails , ## Remove 1st line
	find . -name .git | grep -v '\./.git' | sed 's/^..\(.*\).....$/\1/'  > submodules.txt
	cat submodules.txt 	| awk '{print "cat "$1"/.git/config| grep url | sed -n 1p "}' > submodules.run
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
	echo "## This script helps you add modified files only on git, good for python packages upgrade"
	git ls-files --modified | xargs git add
}

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

## This cript helps you push all submodules using git.
alias gitpushall="git push --recurse-submodules=on-demand"

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
	time ulz4dir ./$1.tar.lz4;rm -rf ./$1; 
	time uxz4dir ./$1.tar.xz4;rm -rf ./$1 
	echo "'.xz/$1' -> './$1'"
	time utar ./$1.tar.xz;rm -rf ./$1 
	cd ..  >>  /dev/null
	rm -rf xbenchTest
}
# echo  $(($PACORES - 1))
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

function uxz4dir() {
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
function ulz4dir() {
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

function rebrew () {
	unset PYTHONPATH
    brew list | grep -v gettext | grep -v gcc| grep -v llvm| xargs brew deps --tree
    brew list | xargs brew reinstall --build-bottle
	brew upgrade
    ## --overwrite --force 
}

function relinkbrew () {
   ## Remove --force
   brew list | xargs brew link --overwrite  | grep Warning | grep keg-only
}


function brewtree () {
    brew upgrade
    brew list | xargs brew deps --tree > brew.tree
    cat brew.tree
}

## This script helps porting all python scripts to python3 .
## Prequisite : brew install xargs python3
function allpy3() {
    find . -name '*.py' | xargs 2to3-3.6 -w
    find . -name '*.bak' | xargs  rm
}


## This script helps upgrading all installed python3 packages.
function repip3() {
	pip3 list |awk '{print "echo [Info]pip3 install --upgrade "$1";pip3 install --upgrade "$1}' > pip3.tmp
	### some packages may gets downgraded 
	cat pip3.tmp |  grep -vF "echo [Info]pip3 install --upgrade azure;pip3 install --upgrade azure"> pip3.update
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
	 find . -executable -type f | xargs file > execfile.log;
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
## It's ok to replace gcc c++ by gcc-7
alias jp3="python3 /usr/local/lib/python3.6/site-packages/jupyter.py notebook"
# export PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/include/:$PATH"
export PATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/4.2/include:$PATH"
##/bin/cp /usr/local/Cellar/gettext/0.19.8.1/lib/libintl.8.dylib /usr/local/lib/libintl.8.dylib
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
## Perl5 upgrade // Run once ?
# PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
# echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> ~/.bash_profile

## Rust  & Weld Support
## curl https://sh.rustup.rs -sSf | sh
export PATH="$HOME/.cargo/bin:$PATH"
export WELD_HOME="~/.weld"

## Reset lib prioirty
export PATH="$PATH:/Volumes/data/WorkSpace"
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport"
alias nets="/usr/sbin/networksetup -listallhardwareports"
export PATH="/Users/dojo/work/.npm/bin/:$PATH"


## OPT lib support
export PATH="$OPT_PREFIX/parallel-netcdf/include:$PATH"
export PATH="$OPT_PREFIX/openssl/lib:$PATH:"
export PATH="$OPT_PREFIX/texinfo/bin:$PATH"



## Customized / Shared package path for multi-OS version
export PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:$PATH"
# mkdir -p /Volumes/data/python/3.6/site-packages
# cp -rf /usr/local/lib/python3.6/site-packages /Volumes/data/WorkSpace/python/3.6/site-packages
# rm -rf /usr/local/lib/python3.6/site-packages
# ln -s -f /Volumes/data/WorkSpace/python/3.6/site-packages /usr/local/lib/python3.6/site-packages 
# ln -s -f /usr/local/lib/python3.6/site-packages /Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages
# ln -s -f /usr/local/bin/glibtoolize  /usr/local/bin/libtoolize
alias gopy3="cd /usr/local/lib/python3.6/site-packages"
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
    "openssl" "xz" "zlib" "bison" #"bzip2" 
    "gmp" "mpfr" "llvm" "ncurses"
    "boost" "boost-mpi" "boost-python" "open-mpi" "tbb"
    "gettext"  #"readline"
    "lapack" "openblas"
    "libkml" "libtool" "libunistring" "libiconv"
    "binutils" "sqlite"
    "opencl" "grt"
    "suite-sparse" "valgrind"
    "python3"
    )

function printlibs {
    mkdir -p ~/.cache > /dev/null
    Nliblist=${#liblist[@]}
    echo "Total libs  = " $Nliblist
    echo "" > ~/.cache/brewlibs.db 
    echo "" > ~/.cache/brewlibs.links
    for (( ii=1; ii<${Nliblist}+1; ii++ ));
    do
    echo $ii" "${Nliblist}" "${liblist[$ii-1]} >> ~/.cache/brewlibs.db
    echo linkopts ${liblist[$ii-1]} >> ~/.cache/brewlibs.links
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
	export LINKFLAGS="$CPPFLAGS"
}

function morelibs(){
	linkopts portable-expat
	linkopts portaudio
	linkopts libarchive
	linkopts qt
	linkopts metis
	linkopts opencv
	linkopts cython
}
setcc
keylibs
printlibs > /dev/null
bootlibs >/dev/null

#   Set Global Paths
#   ------------------------------------------------------------
export PATH="$PATH:/bin:/sbin:/usr/include:/usr/lib"
#   Set Local Paths, ensure local path wil lbe ahead of all other path
#   ------------------------------------------------------------
export PATH="/usr/local/bin:/usr/local:/usr/local/sbin:/usr/local/include:/usr/local/lib:$PATH"
#   Set Brew Paths, ensure local path will be ahead of local path
export PATH="$BREW_PREFIX/bin;$BREW_PREFIX/sbin:$BREW_PREFIX/lib;$BREW_PREFIX/include;$PATH"
export MANPATH="$BREW_PREFIX:/share/man:$MANPATH"
export INFOPATH="$BREW_PREFIX/share/info:$INFOPATH"
