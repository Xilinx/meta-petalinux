DEPENDS_append = " ffmpeg"

EXTRA_OECMAKE_append = " \
	-DENABLE_PRECOMPILED_HEADERS=OFF \
	-DBUILD_opencv_nonfree=OFF \
	-DWITH_FFMPEG=YES \
	-DBUILD_ZLIB=ON \
	"

PACKAGECONFIG_append_class-native = " \
    dnn \
    freetype \
    text \
    "
