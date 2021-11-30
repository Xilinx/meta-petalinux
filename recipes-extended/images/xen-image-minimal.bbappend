inherit extrausers autologin
IMAGE_INSTALL:remove = "packagegroup-core-ssh-openssh"
IMAGE_FEATURES += "ssh-server-dropbear"
