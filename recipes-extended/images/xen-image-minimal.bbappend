inherit extrausers autologin
IMAGE_INSTALL_remove = "packagegroup-core-ssh-openssh"
IMAGE_FEATURES += "ssh-server-dropbear"
