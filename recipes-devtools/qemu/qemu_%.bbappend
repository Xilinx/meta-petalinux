require qemu-tpm.inc
# Disable qemu-xen settings, these have not been ported to the latest version.
#require qemu-xen.inc

# We do not want QEMU, on the target to be configured with OpenGL
PACKAGECONFIG:remove:class-target:petalinux = "virglrenderer epoxy gtk+"
