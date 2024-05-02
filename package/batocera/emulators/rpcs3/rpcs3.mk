################################################################################
#
# rpcs3
#
################################################################################
# Version: 0.0.31-16388 - Commits on Apr 27, 2024
RPCS3_VERSION = v0.0.32
RPCS3_SITE = https://github.com/RPCS3/rpcs3.git
RPCS3_SITE_METHOD=git
RPCS3_GIT_SUBMODULES=YES
RPCS3_LICENSE = GPLv2
RPCS3_DEPENDENCIES += alsa-lib batocera-llvm faudio ffmpeg libevdev libxml2
RPCS3_DEPENDENCIES += libgl libglew libglu libpng libusb mesa3d ncurses openal rtmpdump
RPCS3_DEPENDENCIES += qt6base qt6declarative qt6multimedia qt6svg wolfssl

RPCS3_SUPPORTS_IN_SOURCE_BUILD = NO

RPCS3_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
RPCS3_CONF_OPTS += -DCMAKE_INSTALL_PREFIX=/usr
RPCS3_CONF_OPTS += -DCMAKE_CROSSCOMPILING=ON
RPCS3_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
RPCS3_CONF_OPTS += -DUSE_NATIVE_INSTRUCTIONS=OFF
RPCS3_CONF_OPTS += -DLLVM_DIR=$(STAGING_DIR)/usr/lib/cmake/llvm/
RPCS3_CONF_OPTS += -DUSE_PRECOMPILED_HEADERS=OFF
RPCS3_CONF_OPTS += -DSTATIC_LINK_LLVM=OFF
RPCS3_CONF_OPTS += -DUSE_SYSTEM_FFMPEG=OFF
RPCS3_CONF_OPTS += -DUSE_SYSTEM_CURL=ON
RPCS3_CONF_OPTS += -DUSE_SYSTEM_LIBUSB=ON
RPCS3_CONF_OPTS += -DUSE_LIBEVDEV=ON
RPCS3_CONF_OPTS += -Wno-dev -Wno-deprecated
# this is ugly, but necessary... for now...
ifeq ($(BR2_x86_64),y)
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_AVCODEC=../3rdparty/ffmpeg/lib/linux/ubuntu-22.04/x86_64/libavcodec.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_AVFORMAT=../3rdparty/ffmpeg/lib/linux/ubuntu-22.04/x86_64/libavformat.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_AVUTIL=../3rdparty/ffmpeg/lib/linux/ubuntu-22.04/x86_64/libavutil.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_SWSCALE=../3rdparty/ffmpeg/lib/linux/ubuntu-22.04/x86_64/libswscale.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_SWRESAMPLE=../3rdparty/ffmpeg/lib/linux/ubuntu-22.04/x86_64/libswresample.a
endif
ifeq ($(BR2_aarch64),y)
    RPCS3_CONF_OPTS += -DUSE_SYSTEM_SDL=ON -DUSE_SYSTEM_FAUDIO=ON
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_AVCODEC=$(STAGING_DIR)/usr/lib/libavcodec.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_AVFORMAT=$(STAGING_DIR)/usr/lib/libavformat.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_AVUTIL=$(STAGING_DIR)/usr/lib/libavutil.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_SWSCALE=$(STAGING_DIR)/usr/lib/libswscale.a
	RPCS3_CONF_OPTS += -DFFMPEG_LIB_SWRESAMPLE=$(STAGING_DIR)/usr/lib/libswresample.a
else
	RPCS3_CONF_OPTS += -DUSE_SYSTEM_FAUDIO=OFF
endif

RPCS3_CONF_ENV = LIBS="-ncurses -ltinfo"

ifeq ($(BR2_PACKAGE_SDL2),y)
    RPCS3_CONF_OPTS += -DUSE_SDL=ON
	RPCS3_DEPENDENCIES += sdl2
else
    RPCS3_CONF_OPTS += -DUSE_SDL=OFF
endif
ifeq ($(BR2_PACKAGE_VULKAN_HEADERS)$(BR2_PACKAGE_VULKAN_LOADER),yy)
    RPCS3_CONF_OPTS += -DUSE_VULKAN=ON
	RPCS3_DEPENDENCIES += vulkan-headers vulkan-loader slang-shaders
else
    RPCS3_CONF_OPTS += -DUSE_VULKAN=OFF
endif

define RPCS3_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D)/buildroot-build
endef

define RPCS3_INSTALL_EVMAPY
	mkdir -p $(TARGET_DIR)/usr/share/evmapy
	$(INSTALL) -D -m 0644 \
	    $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/emulators/rpcs3/evmapy.keys \
	    $(TARGET_DIR)/usr/share/evmapy/ps3.keys
endef

RPCS3_POST_INSTALL_TARGET_HOOKS = RPCS3_INSTALL_EVMAPY

$(eval $(cmake-package))
