alias update='sudo apt-get update -y && sudo apt-get upgrade -y'
alias checkip='curl checkip.amazonaws.com'
alias ..='cd ..'

#jump to OpenEBS directory
alias oebs='cd "$GOPATH"/src/github.com/openebs'
alias ndm='cd "$GOPATH"/src/github.com/openebs/node-disk-manager'

#exclude grepping through .git folders and make case insensitive
alias grep='grep -i --exclude-dir=\.git --color=auto'

#generate output in human readable form
alias du='du -h'
alias df='df -h'
alias free='free -h'

#use GUI diff tool which comes along with goland
gdiff() {
	goland diff $1 $2
}

#make directory and go into it
mkcd() { 
	mkdir -p $1; cd $1 
}

#search through history
hs() { 
	command="history"
	for arg in "$@"
	do
		command="$command | grep $arg"
	done
	eval $command
}

#mv with parent
pmv() {
    src=$1
    dst=$2
    mkdir -p "$dst"/"$(dirname $src)"
    mv "$src" "$dst"/"$(dirname $src)"/
}

#Extract archives
extract() {
	if [ -f $1 ] ; then
		case $1 in
		  *.tar.bz2)   tar xjvf $1    ;;
		  *.tar.gz)    tar xzvf $1    ;;
		  *.bz2)       bzip2 -d $1    ;;
		  *.rar)       unrar $1    ;;
		  *.gz)        gunzip $1    ;;
		  *.tar)       tar xf $1    ;;
		  *.tgz)       tar xzf $1    ;;
		  *.zip)       unzip $1     ;;
		  *.7z)        7z x $1    ;;
		  *)           echo "'$1' cannot be extracted via extract()"   ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

#cd multiple dricetories
up() {
	DIR_PATH=""

	if [ -z $1 ] ; then
		return
	fi

	for i in $(seq "$1")
	do
		DIR_PATH="$DIR_PATH../"
	done
	cd $DIR_PATH
}

gi() { 
	curl -sL https://www.gitignore.io/api/$@
	echo ""
}

