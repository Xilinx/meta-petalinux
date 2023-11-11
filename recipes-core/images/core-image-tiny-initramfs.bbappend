# BSPs use IMAGE_FSTYPES:<machine override> which would override
# an assignment to IMAGE_FSTYPES so we need anon python
IMAGE_FSTYPES:forcevariable = "${INITRAMFS_FSTYPES}"
python () {
    d.setVar("IMAGE_FSTYPES", d.getVar("INITRAMFS_FSTYPES"))
}
