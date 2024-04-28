################################################################################
#
# kodi20-pvr-freebox
#
################################################################################

KODI20_PVR_FREEBOX_VERSION = 20.3.2-Nexus
KODI20_PVR_FREEBOX_SITE = $(call github,aassif,pvr.freebox,$(KODI20_PVR_FREEBOX_VERSION))
KODI20_PVR_FREEBOX_LICENSE = MIT
KODI20_PVR_FREEBOX_DEPENDENCIES = json-for-modern-cpp

THEXTECH_DEPENDENCIES = sdl2 sdl2_mixer sdl2_ttf

$(eval $(cmake-package))
