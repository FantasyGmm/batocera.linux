################################################################################
#
# armbian firmware
#
################################################################################
# Version.: Commits on Mar 10, 2024
FIRMWARE_ARMBIAN_VERSION = 6c1532bccd4f99608d7f09a0f115214a7867fb0a
FIRMWARE_ARMBIAN_SITE = $(call github,armbian,firmware,$(FIRMWARE_ARMBIAN_VERSION))

FIRMWARE_ARMBIAN_TARGET_DIR=$(TARGET_DIR)/lib/firmware/

define FIRMWARE_ARMBIAN_INSTALL_TARGET_CMDS
	mkdir -p $(FIRMWARE_ARMBIAN_TARGET_DIR)
	cp -aRf $(@D)/* $(FIRMWARE_ARMBIAN_TARGET_DIR)/
endef

$(eval $(generic-package))
