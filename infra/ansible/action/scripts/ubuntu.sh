#!/bin/bash

clear

## Variables 

OS=$(cat /etc/os-release  | grep VERSION_ID  | awk -F "=" '{ print $2}' | sed 's/\"//g')
TODAY=$(date +%Y-%m-%d)
DATE=$(date +%Y%m%d)
HOSTNAME=$(hostname)

if [ "$OS" == "16.04" ]; then
	OSVERSION="Ubuntu 16.04"
elif [ "$OS" == "18.04" ]; then
	OSVERSION="Ubuntu 18.04"
elif [ "$OS" == "20.04" ]; then
	OSVERSION="Ubuntu 20.04"
elif [ "$OS" == "22.04" ]; then
	OSVERSION="Ubuntu 22.04"
fi

## ISMS_SECURITY APPLY ##

echo ""
echo "[$TODAY] ISMS 보안 취약점 조치 적용 스크립트 by Devops"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "$HOSTNAME ($OSVERSION)"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""


echo "[UNX-102] 패스워드 복잡성 설정"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/pam.d/common-auth-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/pam.d/common-auth | grep -v "#" | grep -v "^$"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ]; then
	## FILE BACKUP #
	sudo cp /etc/pam.d/common-auth /etc/pam.d/common-auth-$DATE
        OLD_DATA=$(cat /etc/pam.d/common-auth | grep -x "password.*ocredit=-1")
        ADD_DATA="password requisite pam_pwquality.so retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"

        if [ -z "$OLD_DATA" ]; then
                echo "After Value"
                sudo sh -c "sudo echo 'password requisite pam_pwquality.so retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1' >> /etc/pam.d/common-auth"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
                cat /etc/pam.d/common-auth | grep -v "#" | grep -v "^$"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
        else
                echo "After Value"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
                cat /etc/pam.d/common-auth | grep -v "#" | grep -v "^$"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
        fi
elif [ "$OS" == "22.04" ]; then
	## FILE BACKUP #
	sudo cp /etc/pam.d/common-password /etc/pam.d/common-password-$DATE
        OLD_DATA=$(cat /etc/pam.d/common-password | grep -x "password.*ocredit=-1")
        ADD_DATA="password requisite pam_pwquality.so retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1"

        # Ubuntu 22.04 pwquality pam 설치
        if dpkg -s libpam-pwquality &> /dev/null; then
	    echo "libpam-pwquality is already installed."
	else
	    echo "libpam-pwquality is not installed. Installing..."
	    sudo apt-get update || true
	    sudo apt-get install -y libpam-pwquality || true
	    echo "libpam-pwquality has been successfully installed."
	fi

        if [ -z "$OLD_DATA" ]; then
                echo "After Value"
                sudo sh -c "sudo echo 'password requisite pam_pwquality.so retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1' >> /etc/pam.d/common-password"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
                cat /etc/pam.d/common-password | grep -v "#" | grep -v "^$"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
        else
                echo "After Value"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
                cat /etc/pam.d/common-password | grep -v "#" | grep -v "^$"
                echo "--------------------------------------------------------------------------------------------------------------------------------"
        fi
else
	echo "Unsupported OS version"
fi

echo ""


echo "[UNX-103] 계정 잠금 임계값 설정"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/pam.d/common-auth-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/pam.d/common-auth-$DATE | grep -v "#" | grep -v "^$"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

# ubuntu 16에서 미동작 확인되어 삭제처리 20240719
#if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ]; then
if [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ]; then
	OLD_DATA=$(cat /etc/pam.d/common-auth | grep -x "auth.*pam_faillock.so.*unlock_time=600")
	ADD_DATA="auth.*unlock_time=600"
	
	## FILE BACKUP #
	sudo cp /etc/pam.d/common-auth /etc/pam.d/common-auth-$DATE

	if [ -z "$OLD_DATA" ]; then
		echo "After Value"
		sudo sh -c "sudo echo 'auth    required                        pam_faillock.so deny=5 unlock_time=600' >> /etc/pam.d/common-auth"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
		cat /etc/pam.d/common-auth | grep -v "#" | grep -v "^$"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
	else
		echo "After Value"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
		cat /etc/pam.d/common-auth | grep -v "#" | grep -v "^$"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
	fi
elif [ "$OS" == "22.04" ]; then
	## FILE BACKUP #
	sudo cp /etc/pam.d/common-account /etc/pam.d/common-account-$DATE
	OLD_PAM_ACCOUNT_DATA=$(grep -x "account.*required.*pam_faillock.so" /etc/pam.d/common-account)

	# If the line does not exist, add it to the file
	if [ -z "$OLD_PAM_ACCOUNT_DATA" ]; then
	    sudo sh -c "echo 'account    required    pam_faillock.so' >> /etc/pam.d/common-account"
	    echo "The pam_faillock configuration has been added to /etc/pam.d/common-account."
	else
	    echo "The pam_faillock configuration already exists in /etc/pam.d/common-account."
	fi

	NEW_LINES="auth       required                                      pam_faillock.so preauth silent audit deny=4 unlock_time=600
auth    [success=1 default=ignore]      pam_unix.so nullok
auth        [default=die]                                pam_faillock.so authfail audit deny=4 unlock_time=600
auth        sufficient                                    pam_faillock.so authsucc audit deny=4 unlock_time=600"
	if ! grep -q "pam_faillock.so" /etc/pam.d/common-auth; then
	    # Backup the original file
	    sudo cp /etc/pam.d/common-auth /etc/pam.d/common-auth.bak
	    sudo sed -i '/auth.*\[success=1 default=ignore\].*pam_unix.so nullok/d' /etc/pam.d/common-auth

	    # Create a temporary file
	    TMP_FILE=$(mktemp)

	    # Add the new lines to the temporary file
	    echo "$NEW_LINES" | sudo tee $TMP_FILE > /dev/null

	    # Append the original file to the temporary file
	    sudo cat /etc/pam.d/common-auth >> $TMP_FILE

	    # Move the temporary file to overwrite the original file
	    sudo mv $TMP_FILE /etc/pam.d/common-auth

	    echo "The pam_faillock configuration has been added to the top of /etc/pam.d/common-auth."
	else
	    echo "The pam_faillock configuration already exists in /etc/pam.d/common-auth."
	fi
else
	echo "Unsupported OS version"
fi

echo ""

## FILE BACKUP #
sudo cp /etc/group /etc/group-$DATE
sudo cp /usr/bin/su /usr/bin/su-$DATE
echo "[UNX-105] ROOT 계정 SU 제한"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/group-$DATE"
echo "BACKUP FILE - /usr/bin/su-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Before \"wheel\", \"sudo\" , \"google-sudoers\" Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/group | grep -e wheel -e sudo -e google-sudoers
ls -al /usr/bin/su
echo ""

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ] || [ "$OS" == "22.04" ]; then
	echo "After \"wheel\", \"sudo\" , \"google-sudoers\" Value"	
	echo "-------------------------"
	cat /etc/group | grep -e wheel -e sudo -e google-sudoers
        sudo chmod 4750 /usr/bin/su
	echo ""
fi

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ] || [ "$OS" == "22.04" ]; then
	OLD_DATA=$(cat /etc/pam.d/su | grep -x "auth.*use_uid")

	if [ -z "$OLD_DATA" ]; then
		echo "After Value"
		sudo sh -c "sudo echo 'auth            required        pam_wheel.so use_uid' >> /etc/pam.d/su"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
		cat /etc/pam.d/su | grep -v "#" | grep -v "^$"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
	else
		echo "After Value"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
		cat /etc/pam.d/su | grep -v "#" | grep -v "^$"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
	fi
else
	echo "Unsupported OS version"
fi

echo ""

## FILE BACKUP #
sudo cp /etc/pam.d/common-password /etc/pam.d/common-password-$DATE

echo "[UNX-106] 패스워드 최소 길이 설정"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/pam.d/common-password-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/pam.d/common-password-$DATE | grep -v "#" | grep -v "^$"
echo ""

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ]; then
	DATA_LINE=$(cat /etc/pam.d/common-password | grep -x -n "password.*sha512" | awk -F ":" '{ print $1 }')
	ORI_DATA=$(cat /etc/pam.d/common-password | grep -x "password.*sha512")
	ADD_DATA="password        [success=1 default=ignore]      pam_unix.so nullok obscure min=8 sha512"

	if [ "$ORI_DATA" == "$ADD_DATA" ]; then
		echo "After Value"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
		cat /etc/pam.d/common-password | grep -v "#" | grep -v "^$"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
	else
		echo "After Value"

		NEW_DATA_LINE=`expr $DATA_LINE + 1`
		sudo sed -i "$DATA_LINE s/password/\# password/g" /etc/pam.d/common-password
		sudo sed -i "$NEW_DATA_LINE i $ADD_DATA" /etc/pam.d/common-password
		echo "--------------------------------------------------------------------------------------------------------------------------------"
		cat /etc/pam.d/common-password | grep -v "#" | grep -v "^$"
		echo "--------------------------------------------------------------------------------------------------------------------------------"
	fi
elif [ "$OS" == "22.04" ]; then
	echo "Already configured in [UNX-102]"
	cat /etc/pam.d/common-password | grep 'minlen'
else
	echo "Unsupported OS version"
fi

echo ""

## FILE BACKUP #
sudo cp /etc/login.defs /etc/login.defs-$DATE

echo "[UNX-107, UNX-108] 패스워드 최대,최소 사용기간 설정"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/login.defs-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/login.defs-$DATE | grep "PASS_MAX_DAYS" | grep -v "#"
cat /etc/login.defs-$DATE | grep "PASS_MIN_DAYS" | grep -v "#"
echo ""

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] ||  [ "$OS" == "20.04" ] ||  [ "$OS" == "22.04" ]; then

	CHK_MAX_DAYS="PASS_MAX_DAYS   90"

	OLD_MAX_DAYS=$(cat /etc/login.defs  | grep -x "PASS_MAX_DAYS.*99999")
	NEW_MAX_DAYS=$(cat /etc/login.defs  | grep -x "PASS_MAX_DAYS.*90")
	OLD_MAX_DAYS_LINE=$(cat /etc/login.defs  | grep -n -x "PASS_MAX_DAYS.*9999"  | awk -F ":" '{ print $1 }')

	CAL_OLD_MAX_DAYS_LINE=`expr $OLD_MAX_DAYS_LINE + 1`
	ADD_MAX_DAYS="PASS_MAX_DAYS   90"

	if [ "$CHK_MAX_DAYS" == "$NEW_MAX_DAYS" ]; then
		sleep 0
	else
		sudo sed -i "$OLD_MAX_DAYS_LINE s/PASS_MAX_DAYS/\# PASS_MAX_DAYS/g" /etc/login.defs
		sudo sed -i "$CAL_OLD_MAX_DAYS_LINE i $ADD_MAX_DAYS" /etc/login.defs
		sleep 0
	fi

	CHK_MIN_DAYS="PASS_MIN_DAYS   1"

	OLD_MIN_DAYS=$(cat /etc/login.defs | grep -x "PASS_MIN_DAYS.*0")
	NEW_MIN_DAYS=$(cat /etc/login.defs | grep -x "PASS_MIN_DAYS.*1")
	OLD_MIN_DAYS_LINE=$(cat /etc/login.defs  | grep -n -x  "PASS_MIN_DAYS.*0" | awk -F ":" '{ print $1 }')

	CAL_OLD_MIN_DAYS_LINE=`expr $OLD_MIN_DAYS_LINE + 1`
	MIN_DAYS_ADD="PASS_MIN_DAYS   1"

	if [ "$CHK_MIN_DAYS" == "$NEW_MIN_DAYS" ]; then
		sleep 0
	else
		sudo sed -i "$OLD_MIN_DAYS_LINE s/PASS_MIN_DAYS/\# PASS_MIN_DAYS/g" /etc/login.defs
		sudo sed -i "$CAL_OLD_MIN_DAYS_LINE i $MIN_DAYS_ADD" /etc/login.defs
		sleep 0
	fi

	echo "After Value"	
	echo "--------------------------------------------------------------------------------------------------------------------------------"
	cat /etc/login.defs | grep "PASS_MAX_DAYS" | grep -v "#"
	cat /etc/login.defs | grep "PASS_MIN_DAYS" | grep -v "#"
else
	echo "Unsupported OS version"
fi

echo "" 

# FILE BACKUP #
sudo cp /etc/passwd /etc/passwd-$DATE

echo "[UNX-110] 사용자 Shell 점검"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/passwd-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/passwd-$DATE |grep "^sync"
echo ""

sudo usermod -s /sbin/nologin sync

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/passwd |grep "^sync"
echo ""

# FILE BACKUP #
sudo cp /etc/shadow /etc/shadow-$DATE

echo "[UNX-203] /etc/shadow 파일 소유자 및 권한 설정"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/shadow-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
ls -al /etc/shadow
echo ""

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
sudo chmod 400 /etc/shadow
ls -al /etc/shadow
echo ""

echo "[UNX-207] SUID, GUID, Sticky bit 설정파일 점검"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
ls -al /usr/sbin/unix_chkpwd
ls -al /usr/bin/newgrp
ls -al /usr/bin/at
echo ""

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
sudo chmod -s /usr/sbin/unix_chkpwd
sudo chmod -s /usr/bin/at
sudo chmod -s /usr/bin/newgrp
ls -al /sbin/unix_chkpwd
ls -al /usr/bin/newgrp
ls -al /usr/bin/at
echo ""


# FILE BACKUP #
sudo cp /etc/profile /etc/profile-$DATE

echo "[UNX-111, UNX-211] TMOUT, UMASK 설정"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/profile-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
umask
echo "$TMOUT"
echo ""

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ] || [ "$OS" == "22.04" ]; then

       NOW_TMOUT=$(echo $TMOUT)

       if [ -n "$NOW_TMOUT"  ]; then
	       echo "TMOUT: $TMOUT"
       else
	       
	       sudo sh -c "sudo echo '' >> /etc/profile"
	       sudo sh -c "sudo echo 'TMOUT=600' >> /etc/profile"
       fi

       NOW_UMASK=$(umask)

       if  [ "$NOW_UMASK" == "022" ]; then
               echo "UMASK: $NOW_UMASK"
       else
               sudo sh -c "sudo echo '' >> /etc/profile"
               sudo sh -c "sudo echo 'umask 022' >> /etc/profile"
               sudo sh -c "sudo echo 'export umask' >> /etc/profile"
	       source /etc/profile
       fi
else
	echo "Unsupported OS version"
fi

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
umask
echo "$TMOUIT"

echo ""

# FILE BACKUP #
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config-$DATE

echo "[UNX-101, UNX-314] ROOT 계정 원격 접속 제한, LOGIN 경고 메시지 제공 설정"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/ssh/sshd_config-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/ssh/sshd_config-$DATE | grep -x "#Banner.*"
cat /etc/ssh/sshd_config-$DATE | grep -x "#PermitRootLogin.*"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ] || [ "$OS" == "22.04" ]; then

	CHK_ROOT=$(cat /etc/ssh/sshd_config | grep PermitRootLogin | grep -v "without-password")

	if [ "$CHK_ROOT" == "#PermitRootLogin prohibit-password" ]; then
		sudo sed -i 's/\#PermitRootLogin prohibit-password/\#PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
		sudo sed -i'' -r -e "/\#PermitRootLogin prohibit-password/a\PermitRootLogin no" /etc/ssh/sshd_config 

	elif [ "$CHK_ROOT" == "PermitRootLogin prohibit-password" ]; then
		sudo sed -i 's/PermitRootLogin prohibit-password/\#PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
		sudo sed -i'' -r -e "/\#PermitRootLogin prohibit-password/a\PermitRootLogin no" /etc/ssh/sshd_config 

	elif [ "$CHK_ROOT" == "PermitRootLogin no" ]; then
		sleep 0
	fi
else
	echo "Unsupported OS version"
fi

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ] || [ "$OS" == "22.04" ]; then
 
	if [ ! -f /etc/motd ] ; then
		sudo touch /etc/motd
		echo -e "\n-------------------------------------------------------------------------\nWARNING : Unauthorized access to this system is forbidden and will be\nprosecuted by law. By accessing this system, you agree that your actions\nmay be monitored if unauthorized\n-------------------------------------------------------------------------" | sudo tee -a /etc/motd > /dev/null
	elif [ -f /etc/motd ] && ( ! grep -q "WARNING" /etc/motd ); then
		echo -e "\n-------------------------------------------------------------------------\nWARNING : Unauthorized access to this system is forbidden and will be\nprosecuted by law. By accessing this system, you agree that your actions\nmay be monitored if unauthorized\n-------------------------------------------------------------------------"  | sudo tee -a /etc/motd > /dev/null
	else
		echo "Already configured /etc/motd file"
	fi
else
	echo "Unsupported OS version"
fi

if [ "$OS" == "16.04" ] || [ "$OS" == "18.04" ] || [ "$OS" == "20.04" ] || [ "$OS" == "22.04" ]; then
	
	# CHK_BANNER=$(cat /etc/ssh/sshd_config | grep -x "#Banner.*")
	CHK_BANNER=$(cat /etc/ssh/sshd_config | grep "Banner" | grep -v "#")
	
	BANNER=$(cat /etc/ssh/sshd_config | grep -x "Banner.*tail")
	BANNER_LINE=$(cat /etc/ssh/sshd_config | grep -n -x "#Banner.*" | awk -F ":" '{ print $1}')
	BANNER_ADD="Banner /etc/motd.tail"
	
	if [ "$CHK_BANNER" == "$BANNER_ADD" ]; then 
		sleep 0	
	else
		CAL_BANNER_LINE=`expr $BANNER_LINE + 1`
		
		sudo sed -i "$CAL_BANNER_LINE i $BANNER_ADD" /etc/ssh/sshd_config
	fi
		sudo su root -c "cat > /etc/motd.tail <<EOF
-------------------------------------------------------------------------
WARNING : Unauthorized access to this system is forbidden and will be
prosecuted by law. By accessing this system, you agree that your actions
may be monitored if unauthorized
-------------------------------------------------------------------------
EOF"
	       sudo systemctl restart sshd

	echo "After Value"
	echo "--------------------------------------------------------------------------------------------------------------------------------"
	cat /etc/ssh/sshd_config | grep -x "Banner.*/etc/motd.tail"
	cat /etc/ssh/sshd_config | grep PermitRootLogin | grep -v "without-password" | grep -v "#"
else
	echo "Unsupported OS version"
fi

echo ""