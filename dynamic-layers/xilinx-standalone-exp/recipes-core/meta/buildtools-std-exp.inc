FILESEXTRAPATHS:append := ":${META_XILINX_STANDALONE_EXP_PATH}/recipes-core/meta/files"

SRC_URI += " \
    file://dt-processor.sh \
    file://README-setup \
"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

TOOLCHAIN_HOST_TASK += "\
    nativesdk-xilinx-lops \
    nativesdk-esw-conf \
    "

create_sdk_files:append () {
        install -m 0644 ${WORKDIR}/README-setup ${SDK_OUTPUT}/${SDKPATH}/.
        install -m 0755 ${WORKDIR}/dt-processor.sh ${SDK_OUTPUT}/${SDKPATH}/.
}
