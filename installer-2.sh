# check sudo
if [[ "$EUID" != 0 ]]; then
  sudo -k
  if false; then 
    echo "Wrong password!"
    exit 0
  fi
fi

function installAURPackage()
{
  if [[ -z $1 ]]; then
    echo "no arguments"
    return
  fi

  echo "Clonning git repo $1"
  sudo -u "$SUDO_USER" git clone $1 testbuild > /dev/null
  
  cd testbuild

  echo "Building package"
  sudo -u "$SUDO_USER" makepkg -si --noconfirm > /dev/null

  cd ../

  echo "Cleaning"
  rm -rf testbuild
}

DIR=`pwd`
FDIR="/home/$SUDO_USER/.local/share/fonts"
PDIR="/home/$SUDO_USER/.config/polybar"

function installFonts()
{
  echo "Installing fonts"
  if [[ -d "$FDIR" ]]; then
    cp -rf $DIR/data/fonts/* "$FDIR"
  else
    mkdir -p "$FDIR"
    cp -rf $DIR/data/fonts/* "$FDIR"
  fi
}

function copyPolybarConfig()
{
  installFonts

  echo "Copying polybar configs"
  mkdir -p /home/$SUDO_USER/.config/polybar
  cp -rf /home/$SUDO_USER/archlinux-installer/data/grayblocks /home/$SUDO_USER/.config/polybar/grayblocks
}

function copyI3Configs()
{
  echo "Copying custom i3 configs"
  mkdir -p /home/$SUDO_USER/Configs
  cp -rf /home/$SUDO_USER/archlinux-installer/data/Configs /home/$SUDO_USER/

  echo "Copying i3 main config"
  cp -rf /home/$SUDO_USER/archlinux-installer/data/i3-config /home/$SUDO_USER/.config/i3/config
}

function setWallpaper()
{
  echo "Copying wallpaper image"
  mkdir -p /home/$SUDO_USER/Pictures
  mkdir -p /home/$SUDO_USER/Pictures/Wallpapers
  cp -rf /home/$SUDO_USER/archlinux-installer/data/wallpaper.jpg /home/$SUDO_USER/Pictures/Wallpapers/wallpaper.jpg
  
  echo "Applying wallpaper image"
  nitrogen --save --set-zoom-fill /home/$SUDO_USER/Pictures/Wallpapers/wallpaper.jpg
}

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

# reboot to activate all onstart commands and services
echo "Rebooting"
reboot