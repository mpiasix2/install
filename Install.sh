#!/bin/bash

# Verificar si Ansible está instalado
if ! which ansible >/dev/null; then
  echo "Instalando Ansible..."
  sudo apt install ansible -y
  # Generar claves SSH
  echo "Generando claves SSH..."
  sudo ssh-keygen
fi

# Pedir las direcciones IP y los usuarios
read -p "Introduzca la dirección IP y el usuario de la máquina fw (ejemplo: usuario@ip): " fw_info
read -p "Introduzca la dirección IP y el usuario de la máquina sec (ejemplo: usuario@ip): " sec_info

# Agregar las direcciones IP y los usuarios al archivo /etc/ansible/hosts
sudo rmdir -rf /etc/ansible
sudo mkdir /etc/ansible
sudo rm /etc/ansible/hosts
sudo touch /etc/ansible/hosts
sudo echo "" > /etc/ansible/hosts
echo "" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "[fw]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "fw ansible_host=$fw_info" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "[sec]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "sec ansible_host=$sec_info" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "[all:vars]" | sudo tee -a /etc/ansible/hosts > /dev/null
echo "ansible_python_interpreter=/usr/bin/python3" | sudo tee -a /etc/ansible/hosts > /dev/null

# Copiar clave SSH a fw y sec
echo "Copiando clave SSH a fw y sec..."
sudo ssh-copy-id $fw_info
sudo ssh-copy-id $sec_info

echo "Las direcciones IP y los usuarios se han agregado correctamente al archivo /etc/ansible/hosts junto a la clave SSH"

sudo ansible-playbook playbookmpi.yaml -K
