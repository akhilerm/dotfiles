alias update='sudo apt-get update -y && sudo apt-get upgrade -y'
alias checkip='curl checkip.amazonaws.com'

#exclude grepping through .git folders
alias grep='grep --exclude-dir=\.git --color=auto'

#make grep case insensitive by default
alias grep='grep -i'

alias ..='cd ..'

#generate output in human readable form
alias du='du -h'
alias df='df -h'
alias free='free -h'

#use GUI diff tool which comes along with goland
gdiff() {
	goland diff $1 $2
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
	for i in $(seq "$1")
	do
		cd ..
	done
}
