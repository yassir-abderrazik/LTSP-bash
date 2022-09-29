#!/bin/bash
echo  "  MENU "
echo  " 1- Installation des paquets."
echo  " 2- Installation du serveur LTSP."
echo  " 3- Création des utilisateurs."
echo  " 4- Exit."
echo -n "    -->  Entrez votre choix (1-4) : "
read choix
user=`whoami`
if [ $user = root ] ; then {
wget -q --spider http://google.com 
	if [ $? -eq 0 ] ; then  { # $? : retourner à la ligne précedente 
    # 0 code shell "all ok" 
while :; do 
case $choix in 
1)  while :; do
echo -e " MENU "
echo -e " 1- TFTP."
echo -e " 2- DHCP."
echo -e " 3- NFS."
echo -e " 4- Samba.|"
echo -e " 5- DNS."
echo -e " 6- SSH."
echo -e " 7- tous las paquets."
echo -e " 8- Exit."
echo -n "   Entrez votre choix (1-8): "
	read package
	     case $package in
1)  sudo apt-get update | sudo apt-get -y install tftpd-hpa     ;;
		2)  sudo apt-get update | sudo apt-get -y install isc-dhcp-server  ;;
		3)  sudo apt-get update | sudo apt-get -y install nfs-kernel-server    ;;
		4)  sudo apt-get update | sudo apt-get -y install samba  ;;
		5)  sudo apt-get update | sudo apt-get -y install bind9  ;;
		6)  sudo apt-get update | sudo apt-get -y install openssh-server  ;;
		7)  sudo apt-get update | sudo apt-get -y install openssh-server bind9 samba nfs-kernel-server isc-dhcp-server tftpd-hpa  ;;
		8)  exit ;;
		*)  echo  " erreur "
break
	     esac
    done ;;
2)    echo "installation "  
      sudo apt-get install -y ltsp-server-standalone
     echo -n "construire l'image du serveur LTSP utilisée par les clients, choisir l'architecture de votre client 32 bits  ou 64 bits: "
      read bits
      if [ $bits = 32 ]  ; then
      ltsp-build-client --arch i386
      elif [ $bits = 64 ] ; then 
       ltsp-build-client
       else echo " Erreur "
      fi
      echo "vérification si tous les paquets sont installé "
      verification=`touch /home/verification | dpkg --list openssh-server tftpd-hpa isc-dhcp-server nfs-kernel-server > /home/verification`
      verification1=` wc  /home/verification | cut -f3 -d' ' `
      if [ $verification1 = 9 ] ; then {
      cp /etc/network/interfaces /etc/network/interfaces.backup
      cp /etc/sysctl.conf /etc/sysctl.conf.backup
cp /etc/exports /etc/exports.backup
      cp /etc/default/isc-dhcp-server  /etc/default/isc-dhcp-server.backup
      cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup
      cp /etc/default/tftpd-hpa /etc/default/tftpd-hpa.backup
      echo "net.ipv4.ip_forward=1 " > /etc/sysctl.conf
      echo "/opt/ltsp  *(rw,no_root_squash,async) " >> /etc/exports
      echo 'RUN_DAEMON="yes" ' > /etc/default/tftpd-hpa 
      echo 'TFTP_USERNAME="tftp" '  >> /etc/default/tftpd-hpa 
      echo 'TFTP_DIRECTORY="/var/lib/tftpboot" ' >> /etc/default/tftpd-hpa 
      echo 'TFTP_ADDRESS="0.0.0.0:69" ' >> /etc/default/tftpd-hpa 
      echo 'TFTP_OPTIONS="--secure" '  > /etc/default/isc-dhcp-server
      clear
      echo -n " entrez le nom de l'interface ethernet (ifconfig) : "
      read eth
      echo "auto $eth " > /etc/network/interfaces
      echo "iface $eth inet static" >> /etc/network/interfaces
      echo "address 192.168.1.1" >> /etc/network/interfaces
      echo "netmask 255.255.255.0" >> /etc/network/interfaces
      echo "network 192.168.1.0" >> /etc/network/interfaces
      echo "auto lo" >> /etc/network/interfaces
      echo "iface lo inet loopback" >> /etc/network/interfaces
      echo "INTERFACES="$eth"" >> /etc/default/tftpd-hpa
      clear
echo -n " donner le chemin  absolu du fichier dhcpd.conf(le fichier qui se trouve dans le dossier du script) :  "
      read chemin
      cp $chemin /etc/dhcp/dhcpd.conf
      echo " Redémarrage des services "
      service isc-dhcp-server restart
      service tftpd-hpa restart
service nfs-kernel-restart 
      echo " vous pouvez connecter votre client "
       break 
      }
      else echo "installer les paquets suivantes : openssh-server tftpd-hpa isc-dhcp-server nfs-kernel-server "
      fi ;;
3) echo -n " entrez le nom utilisateur : "       
read user1
adduser $user1
break
;;
4)  break ;; 
*) echo "Erreur" 
     break ;; 
esac
done }
else   echo "vous êtes offline" 
fi }
else echo " conneter en root "
