# check sudo
if [[ "$EUID" != 0 ]]; then
  sudo -k
  if false; then 
    echo "Wrong password!"
    exit 0
  fi
fi

function update()
{
  echo "Syncing"
  pacman -Syy --noconfirm &> /dev/null

  echo "Updating"
  pacman -Syu --noconfirm &> /dev/null
}

function deletePackages()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  echo "Deleting $1 $2 $3 $4 $5 $6 $7 $8 $9"
  pacman -Rncsv $1 $2 $3 $4 $5 $6 $7 $8 $9 --noconfirm &> /dev/null
}

function installPackages()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  echo "Installing $1 $2 $3 $4 $5 $6 $7 $8 $9"
  pacman -S $1 $2 $3 $4 $5 $6 $7 $8 $9 --noconfirm --needed &> /dev/null
}

function launchService()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  echo "Launching service $1"
  systemctl enable $1 &> /dev/null
  systemctl start $1 &> /dev/null
}

function hideGrubLoader()
{
  echo "Modifying GRUB config"

  cp -rf /etc/default/grub /home/$SUDO_USER/temp1
  
  echo "GRUB_DEFAULT=0" >> /home/$SUDO_USER/temp1
  echo "GRUB_TIMEOUT=0" >> /home/$SUDO_USER/temp1
  echo "GRUB_DISABLE_OS_PROBER=true" >> /home/$SUDO_USER/temp1

  mv /home/$SUDO_USER/temp1 /etc/default/grub

  echo "Updating GRUB config"
  grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null
}

function launchLightDM()
{
  echo i3 > /home/$SUDO_USER/.xinitrc
  launchService lightdm &> /dev/null
}

# change grub startup time
hideGrubLoader

# update packages
update

# install packages
installPackages xorg-server xorg-xinit xclip
installPackages wget python base-devel git maim 
installPackages kitty rofi neofetch nitrogen feh
installPackages neovim lightdm lightdm-gtk-greeter
installPackages i3-gaps i3status i3blocks i3lock gtk4 galculator
installPackages ttf-hanazono ttf-sazanami ttf-font-awesome ttf-fira-code ttf-anonymous-pro
installPackages telegram-desktop nautilus

# launch display manager
launchLightDM