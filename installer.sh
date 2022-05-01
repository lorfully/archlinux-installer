function update()
{
  sudo pacman -Syy --noconfirm
  sudo pacman -Syu --noconfirm
}

function deletePackages()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  sudo pacman -Rncsv $1 $2 $3 $4 $5 $6 $7 $8 $9 --noconfirm
}

function installPackages()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  sudo pacman -S $1 $2 $3 $4 $5 $6 $7 $8 $9 --noconfirm
}

function launchService()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  sudo systemctl enable $1 --noconfirm
  sudo systemctl start $1 --noconfirm
}

function hideGrubLoader()
{
  grubPath = /etc/default/grub
  
  sudo cp grubPath ~/temp1
  
  sudo echo "GRUB_DEFAULT=0" >> ~/temp1
  sudo echo "GRUB_TIMEOUT=0" >> ~/temp1
  sudo echo "GRUB_DISABLE_OS_PROBER=true" >> ~/temp1

  sudo mv ~/temp1 grubPath

  sudo grub-mkconfig -o /boot/grub/grub.cfg --noconfirm
}

# check sudo
if [[ "$EUID" != 0 ]]; then
  sudo -k
  if sudo false; then 
    echo "Wrong password!"
    exit 0
  fi
fi

# change grub startup time
hideGrubLoader

# update packages
update

# install packages
installPackages xorg-server xorg-xinit xclip
installPackages wget python base-devel git
installPackages kitty rofi neofetch nitrogen feh
installPackages neovim lightdm lightdm-gtk-greeter
installPackages i3-gaps i3blocks i3lock gtk4

# setup display and window manager
sudo echo i3 >> ~/.xinitrc
launchService lightdm