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

function installAURPackage()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  sudo -u "$SUDO_USER" git clone $1 testbuild
  cd testbuild
  sudo -u "$SUDO_USER" makepkg -si --noconfirm
  cd ../
  rm -rf testbuild
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
  cp /etc/default/grub /home/$SUDO_USER/temp1
  
  echo "GRUB_DEFAULT=0" >> /home/$SUDO_USER/temp1
  echo "GRUB_TIMEOUT=0" >> /home/$SUDO_USER/temp1
  echo "GRUB_DISABLE_OS_PROBER=true" >> /home/$SUDO_USER/temp1

  mv /home/$SUDO_USER/temp1 /etc/default/grub

  grub-mkconfig -o /boot/grub/grub.cfg
}

function copyPolybarConfig()
{
  mkdir -p /home/$SUDO_USER/.configs/polybar
  cp -rf /home/$SUDO_USER/archlinux-installer/data/grayblocks /home/$SUDO_USER/.configs/polybar
}

function copyI3Configs()
{
  mkdir -p /home/$SUDO_USER/Configs
  cp -rf /home/$SUDO_USER/archlinux-installer/data/Configs /home/$SUDO_USER/
  cp /home/$SUDO_USER/archlinux-installer/data/i3-config /home/$SUDO_USER/.configs/i3/config
}

function setWallpaper()
{
  mkdir -p /home/$SUDO_USER/Pictures
  mkdir -p /home/$SUDO_USER/Pictures/Wallpapers
  cp /home/$SUDO_USER/archlinux-installer/data/wallpaper.jpg /home/$SUDO_USER/Pictures/Wallpapers/wallpaper.jpg
  nitrogen --set-zoom-fill /home/$SUDO_USER/Pictures/Wallpapers/wallpaper.jpg
}

# check sudo
if [[ "$EUID" != 0 ]]; then
  -k
  if false; then 
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
installPackages wget python base-devel git maim 
installPackages kitty rofi neofetch nitrogen feh
installPackages neovim lightdm lightdm-gtk-greeter
installPackages i3-gaps i3blocks i3lock gtk4 galculator
installPackages ttf-hanazono ttf-sazanami ttf-font-awesome ttf-fira-code ttf-anonymous-pro
installPackages telegram-desktop nautilus

# setup display and window manager
echo i3 > /home/$SUDO_USER/.xinitrc
launchService lightdm

# install AUR packages
installAURPackage https://aur.archlinux.org/waterfox-g4-bin.git
installAURPackage https://aur.archlinux.org/visual-studio-code-bin.git
installAURPackage https://aur.archlinux.org/ttf-ms-fonts.git
installAURPackage https://aur.archlinux.org/ttf-iosevka.git
installAURPackage https://aur.archlinux.org/ttf-icomoon-feather.git
installAURPackage https://aur.archlinux.org/polybar.git

# settings
copyPolybarConfig
copyI3Configs
setWallpaper

# reboot