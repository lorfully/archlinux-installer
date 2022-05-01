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

function installAURPackage()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  sudo git clone $1 build
  cd build
  makepkg -si --noconfirm
  cd ../
  sudo rm -rf build
}

function launchService()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  sudo systemctl enable $1
  sudo systemctl start $1
}

function hideGrubLoader()
{
  sudo cp /etc/default/grub ~/temp1
  
  sudo echo "GRUB_DEFAULT=0" >> ~/temp1
  sudo echo "GRUB_TIMEOUT=0" >> ~/temp1
  sudo echo "GRUB_DISABLE_OS_PROBER=true" >> ~/temp1

  sudo mv ~/temp1 /etc/default/grub

  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

function copyPolybarConfig()
{
  sudo mkdir $HOME/.configs/polybar
  sudo cp -rf ./data/grayblocks ~/.configs/polybar
}

function copyI3Configs()
{
  sudo mkdir ~/Configs
  sudo cp -rf ./data/Configs ~/
  sudo cp ./data/i3-config ~/.configs/i3/config
}

function setWallpaper()
{
  sudo mkdir ~/Pictures
  sudo mkdir ~/Pictures/Wallpapers
  sudo cp ./data/wallpaper.jpg ~/Pictures/Wallpapers/wallpaper.jpg
  sudo nitrogen --set-zoom-fill ~/Pictures/Wallpapers/wallpaper.jpg
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
installPackages wget python base-devel git maim 
installPackages kitty rofi neofetch nitrogen feh
installPackages neovim lightdm lightdm-gtk-greeter
installPackages i3-gaps i3blocks i3lock gtk4 galculator
installPackages ttf-hanazono ttf-sazanami ttf-font-awesome ttf-fira-code ttf-anonymous-pro
installPackages telegram-desktop nautilus

# setup display and window manager
sudo echo i3 > ~/.xinitrc
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

# sudo reboot