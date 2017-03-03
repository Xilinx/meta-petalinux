FILESEXTRAPATHS_prepend := "${THISDIR}/gstreamer1.0-omx:"

SRC_URI_append_zynqmp = " \
    file://0001-Use-nvidia-gstomx-templates-as-ref-for-hevc.patch \
    file://0002-configure-Create-base-for-zynqultrascaleplus-devices.patch \
    file://0003-gstomx.conf-Add-omx-elements.patch \
    file://0004-Add-missing-requirement-for-h265-encoder-element.patch \
    file://0005-Fix-Invalid-type-error-for-h265enc.patch \
    file://0006-Link-omxh265dec-with-gst-omx.patch \
    file://0007-Add-support-for-hw-related-properties-of-OMX-IL.patch \
    file://0008-Remove-memcopy-from-Input-of-gst-omx.patch \
    file://0009-Add-Gstreamer-property-in-Encoder-for-stride.patch \
    file://0010-Handling-for-dynamic-numbers-of-input-buffers.patch \
    file://0011-Add-DMA-import-support-in-gst-omx-encoder.patch \
    file://0012-encoder-Update-OMX-statehandling.patch \
    file://0013-omxbufpool-Add-support-for-DMA-memory-in-bufpool.patch \
    file://0014-omxbufpool-Add-video-metadata-to-DMA-buffer.patch \
    file://0015-Fix-frame-missing-issue-added-ip-mode-property.patch \
    file://0016-Support-for-setting-version-of-component.patch \
    file://0017-Add-event-for-transcode-usecase.patch \
    file://0018-Fix-transcode-usecase-with-dma-mode.patch \
    file://0019-Handling-ref-count-for-DMABuf.patch \
    file://0020-omxvideodec-Measure-performance.patch \
    file://0021-Handling-ref-count-in-zero-copy-mode.patch \
    file://0022-Fixing-some-errors-related-to-unref.patch \
    file://0023-omxvideodec-Added-ip-mode-and-op-mode-property.patch \
    file://0024-Link-allocator-lib-to-libgstomx.so.patch \
"

GSTREAMER_1_0_OMX_TARGET_zynqmp = "zynqultrascaleplus"
GSTREAMER_1_0_OMX_CORE_NAME_zynqmp = "${libdir}/libOMX.allegro.core.so"
