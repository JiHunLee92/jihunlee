#!/bin/bash

## Variables
OS=$(hostnamectl | grep "Operating System" | awk -F ":" '{ print $2 }')
TODAY=$(date +%Y-%m-%d)
DATE=$(date +%Y%m%d)
HOSTNAME=$(hostname)

if [ "$OS" == " Amazon Linux 2" ]; then
        OSVERSION="Amazon Linux 2"
elif [ -f /etc/system-release ] && grep -q "Amazon Linux" /etc/system-release && grep -q "release 2018" /etc/system-release; then
        OSVERSION="Amazon Linux 1"
else
        echo "OS 버전이 확인되지않아 스크립트를 종료합니다."
        exit 0
fi

## ISMS_SECURITY APPLY ##

echo ""
echo "[$TODAY] ISMS Security Vulnerability Action Application Script by Devops"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "$HOSTNAME ($OSVERSION)"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

## FILE BACKUP #
sudo cp /etc/pam.d/login /etc/pam.d/login-$DATE
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config-$DATE

echo "[UNX-101, UNX-314] ROOT account remote access restrictions, Provides a warning message when logging in"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/pam.d/login-$DATE"
echo "BACKUP FILE - /etc/ssh/sshd_config-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
sudo cat /etc/pam.d/login-$DATE | grep "auth       required     /lib64/security/pam_securetty.so"
sudo cat /etc/ssh/sshd_config-$DATE | grep -x "#Banner.*"
sudo cat /etc/ssh/sshd_config-$DATE | grep -x "#PermitRootLogin.*"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

UNX101_1=$(sudo cat /etc/pam.d/login | grep "auth       required     /lib64/security/pam_securetty.so")

if [ "$UNX101_1" == "auth       required     /lib64/security/pam_securetty.so" ]; then
        sleep 0.1
else
        sudo sed -i "2 i\auth       required     /lib64/security/pam_securetty.so" /etc/pam.d/login
fi

UNX101_2_1=$(sudo cat /etc/ssh/sshd_config | grep -x "#PermitRootLogin.*")
UNX101_2_2=$(sudo cat /etc/ssh/sshd_config | grep -x "PermitRootLogin.*")

if [ "$UNX101_2_2" == "PermitRootLogin no" ]; then
        sleep 0.1

elif [ "$UNX101_2_1" == "#PermitRootLogin yes" ]; then
        sudo sed -i''  -r -e "/#PermitRootLogin yes/a\PermitRootLogin no" /etc/ssh/sshd_config
fi

CHK_BANNER=$(sudo cat /etc/ssh/sshd_config | grep "Banner" | grep -v "#")
BANNER=$(sudo cat /etc/ssh/sshd_config | grep -x "Banner.*tail")
BANNER_LINE=$(sudo cat /etc/ssh/sshd_config | grep -n -x "#Banner.*" | awk -F ":" '{ print $1}')
BANNER_ADD="Banner /etc/motd.tail"

if [ "$CHK_BANNER" == "$BANNER_ADD" ]; then
        sleep 0
else
        CAL_BANNER_LINE=`expr $BANNER_LINE + 1`
        sudo sudo sed -i "$CAL_BANNER_LINE i $BANNER_ADD" /etc/ssh/sshd_config
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
sudo cat /etc/pam.d/login | grep "auth       required     /lib64/security/pam_securetty.so"
sudo cat /etc/ssh/sshd_config | grep -x "PermitRootLogin.*"
sudo cat /etc/ssh/sshd_config-$DATE | grep -x "#PermitRootLogin.*"
sudo cat /etc/motd.tail
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

## FILE BACKUP #
sudo cp /etc/pam.d/system-auth /etc/pam.d/system-auth-$DATE


echo "[UNX-102, UNX-103] password complexity, Account Lockout Threshold Settings"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/pam.d/system-auth-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
sudo cat /etc/pam.d/system-auth-$DATE  | grep "auth.*unlock_time=120"
sudo cat /etc/security/pwquality.conf | grep "minlen"
sudo cat /etc/pam.d/password-auth  | grep "pam_tally2.so"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

## UNX-102 Amazon Linux 1, 2 동일
# FILE BACKUP #
PW_QUALITY_FILE="/etc/security/pwquality.conf"
sudo cp $PW_QUALITY_FILE $PW_QUALITY_FILE-$DATE

SETTINGS="minlen = 8
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1"

grep -q "^minlen\s*=\s*8" $PW_QUALITY_FILE
if [ $? -ne 0 ]; then
        echo "pwquality 내 추가된 설정이 없습니다. 설정을 추가합니다."
        echo "$SETTINGS" >> $PW_QUALITY_FILE
else
        echo "pwquality 설정이 이미 존재하므로 조치를 생략합니다."
fi

## UNX-103 Amazon Linux 1, 2 분리
if [ "$OSVERSION" == "Amazon Linux 1" ]; then
        PAM_FILE="/etc/pam.d/password-auth-ac"
        ## FILE BACKUP
        sudo cp $PAM_FILE $PAM_FILE-$DATE
elif [ "$OSVERSION" == "Amazon Linux 2" ]; then
        PAM_FILE="/etc/pam.d/password-auth"
        ## FILE BACKUP
        sudo cp $PAM_FILE $PAM_FILE-$DATE
fi

# 설정 내용
AUTH_SETTING="auth        required      pam_tally2.so deny=5 unlock_time=120"
ACCOUNT_SETTING="account     required      pam_tally2.so"

# pam_tally2 설정이 있는지 확인
grep -q "^account\s*required\s*pam_tally2.so" $PAM_FILE

if [ $? -ne 0 ]; then
    echo "pam_tally2 설정이 없습니다. 설정을 추가합니다."
    sed -i "1i $AUTH_SETTING\n$ACCOUNT_SETTING" $PAM_FILE
else
    echo "pam_tally2 설정이 이미 존재합니다."
fi

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
sudo cat /etc/pam.d/system-auth | grep "auth.*unlock_time=120"
sudo cat /etc/security/pwquality.conf | tail -5
sudo cat /etc/pam.d/password-auth  | grep "pam_tally2.so"
echo "--------------------------------------------------------------------------------------------------------------------------------"

echo ""

# FILE BACKUP #
sudo cp /etc/pam.d/su /etc/pam.d/su-$DATE

echo "[UNX-105] ROOT Account SU Limit"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/pam.d/su-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/pam.d/su |grep -x "auth.*required.*use_uid"
if [ "$OSVERSION" == "Amazon Linux 1" ]; then
        ls -al /bin/su
elif [ "$OSVERSION" == "Amazon Linux 2" ]; then
        ls -al /usr/bin/su
fi
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

UNX105=$(cat /etc/pam.d/su | grep -x "auth.*required.*use_uid")
UNX105_LINE=$(cat /etc/pam.d/su | grep -x -n "#auth.*required.*use_uid" | awk -F ":" '{ print $1 }')

if [ -z "$UNX105"  ]; then
        sudo sed -i "6 i\auth            required        pam_wheel.so use_uid" /etc/pam.d/su
fi

# su 명령어 권한 설정
if [ "$OSVERSION" == "Amazon Linux 1" ]; then
        sudo chmod 4750 /bin/su
elif [ "$OSVERSION" == "Amazon Linux 2" ]; then
        sudo chmod 4750 /usr/bin/su
fi

echo ""
echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/pam.d/su |grep -x "auth.*required.*use_uid"
if [ "$OSVERSION" == "Amazon Linux 1" ]; then
        ls -al /bin/su
elif [ "$OSVERSION" == "Amazon Linux 2" ]; then
        ls -al /usr/bin/su
fi
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

## FILE BACKUP #
sudo cp /etc/login.defs /etc/login.defs-$DATE

echo "[UNX-106, UNX-107, UNX-108] Set minimum password length, MIN/MAX password period setting"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/login.defs-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/login.defs| grep "PASS_MIN_LEN" | grep -v "#"
cat /etc/login.defs | grep "PASS_MAX_DAYS" | grep -v "#"
cat /etc/login.defs | grep "PASS_MIN_DAYS" | grep -v "#"
echo ""

UNX106=$(cat /etc/login.defs | grep -x "PASS_MIN_LEN.*" | awk -F " " '{ print $2 }')
UNX106_LINE=$(cat /etc/login.defs | grep -x -n "PASS_MIN_LEN.*" | awk -F ":" '{ print $1 }')

if [ "$UNX106" -lt "8" ]; then
        sudo sed -i 's/PASS_MIN_LEN.*5/\# PASS_MIN_LEN    5/g' /etc/login.defs
        sudo sed -i "$UNX106_LINE i PASS_MIN_LEN    8" /etc/login.defs
fi

UNX107=$(cat /etc/login.defs  | grep -x "PASS_MAX_DAYS.*" | awk -F " " '{ print $2 }')
UNX108=$(cat /etc/login.defs  | grep -x "PASS_MIN_DAYS.*" | awk -F " " '{ print $2 }')

UNX107_LINE=$(cat /etc/login.defs  | grep -x -n "PASS_MAX_DAYS.*" | awk -F ":" '{ print $1 }')
UNX108_LINE=$(cat /etc/login.defs  | grep -x -n "PASS_MIN_DAYS.*" | awk -F ":" '{ print $1 }')

if [ "$UNX107" -gt "90" ]; then
        sudo sed -i 's/PASS_MAX_DAYS.*99999/\# PASS_MAX_DAYS  99999/g' /etc/login.defs
        sudo sed -i "$UNX107_LINE i PASS_MAX_DAYS   90" /etc/login.defs
fi

if [ "$UNX108" -lt "1" ]; then
        sudo sed -i 's/PASS_MIN_DAYS.*0/\# PASS_MIN_DAYS      0/g' /etc/login.defs
        sudo sed -i "$UNX108_LINE i PASS_MIN_DAYS   1" /etc/login.defs
fi

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/login.defs | grep -x "PASS_MIN_LEN.*"
cat /etc/login.defs | grep -x "PASS_MAX_DAYS.*"
cat /etc/login.defs | grep -x "PASS_MIN_DAYS.*"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

## FILE BACKUP #
sudo cp /etc/passwd /etc/passwd-$DATE

echo "[UNX-110] USER SHELL CHECK"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/passwd-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/passwd | egrep -e "sync|halt|shutdown"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

sudo usermod -s /sbin/nologin sync
sudo usermod -s /sbin/nologin halt
sudo usermod -s /sbin/nologin shutdown

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
cat /etc/passwd | egrep -e "sync|halt|shutdown"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""

echo "[UNX-207] SUID, GUID, Sticky bit setting"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
ls -al /sbin/unix_chkpwd
ls -al /usr/bin/newgrp
ls -al /usr/bin/at
echo ""

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
sudo chmod -s /sbin/unix_chkpwd
sudo chmod -s /usr/bin/at
sudo chmod -s /usr/bin/newgrp
ls -al /sbin/unix_chkpwd
ls -al /usr/bin/newgrp
ls -al /usr/bin/at
echo ""

## FILE BACKUP #
sudo cp /etc/profile /etc/profile-$DATE

echo "[UNX-111, UNX-211] TMOUT, UMASK setting"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "BACKUP FILE - /etc/profile-$DATE"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "Before Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
umask
echo "$TMOUT"
echo ""

NOW_TMOUT=$(echo $TMOUT)

if [ -n "$NOW_TMOUT"  ]; then
        echo "TMOUT: $TMOUT"
else
        sudo sh -c "sudo echo '' >> /etc/profile"
        sudo sh -c "sudo echo 'TMOUT=600' >> /etc/profile"
        sudo sh -c "sudo echo 'export TMOUT' >> /etc/profile"
        source /etc/profile
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

echo "After Value"
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "$TMOUT"
umask
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo ""