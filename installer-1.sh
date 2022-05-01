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
  pacman -Syy --noconfirm
  pacman -Syu --noconfirm
}

function deletePackages()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  pacman -Rncsv $1 $2 $3 $4 $5 $6 $7 $8 $9 --noconfirm
}

function installPackages()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  pacman -S $1 $2 $3 $4 $5 $6 $7 $8 $9 --noconfirm --needed
}

function launchService()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  systemctl enable $1
  systemctl start $1
}

function hideGrubLoader()
{
  cp -rf /etc/default/grub /home/$SUDO_USER/temp1
  
  echo "GRUB_DEFAULT=0" >> /home/$SUDO_USER/temp1
  echo "GRUB_TIMEOUT=0" >> /home/$SUDO_USER/temp1
  echo "GRUB_DISABLE_OS_PROBER=true" >> /home/$SUDO_USER/temp1

  mv /home/$SUDO_USER/temp1 /etc/default/grub

  grub-mkconfig -o /boot/grub/grub.cfg
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
installPackages i3-gaps i3blocks i3lock gtk4 galculator
installPackages ttf-hanazono ttf-sazanami ttf-font-awesome ttf-fira-code ttf-anonymous-pro
installPackages telegram-desktop nautilus

# setup display and window manager
echo i3 > /home/$SUDO_USER/.xinitrc
launchService lightdm