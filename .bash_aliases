alias vbm='VBoxManage'
alias bfg='java -jar /opt/bfg.jar'
alias ovpn='sudo openvpn --dev tun0 --persist-tun --config /home/akhil/.config/openvpn/client.ovpn'
alias update='sudo apt-get update -y && sudo apt-get upgrade -y'
alias wa-uae='google-chrome --user-data-dir=/home/akhil/.config/google-chrome/CustomUser/UAEWhatsApp/ https://web.whatsapp.com 1> /dev/null 2> /dev/null &'
alias checkip='curl checkip.amazonaws.com'
alias scrcpy='scrcpy &> /dev/null &'
# exclude grepping through .git folders.
alias grep='grep -i --exclude-dir=\.git --color=auto'

#Python virtualenv 
#Usage : venv <env-name>
#	 To activate the virtualenv
#      : venv
#	 List all available envs

venv() {
	if [ $# -eq 0 ]; then
		echo $(ls ~/.virtualenv)
	else
		source ~/.virtualenv/$1/bin/activate
	fi
}

# Extract Archives

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


# Compress files

compress() {
	if [[ -n "$1" ]]; then
     		FILE=$1
        	case $FILE in
        		*.tar ) 	shift && tar cf $FILE $* ;;
    			*.tar.bz2 ) 	shift && tar cjf $FILE $* ;;
     			*.tar.gz )  	shift && tar czf $FILE $* ;;
        		*.zip ) 	shift && zip $FILE $* ;;
        		*.rar ) 	shift && rar $FILE $* ;;
        	esac
    else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
    fi
}

#Switch to dvorak
asdf() {
	setxkbmap dvorak
	xdq Control Control+Shift Mod1 Mod1+Shift Control+Mod1
}

#switch to us qwerty
aoeu() {
	setxkbmap us
	kill -9 $(ps -ax | grep xdq | awk '{print $1}')
}

#multiple cd ..
up(){
	for i in $(seq $1); do
		cd ..
	done
}
