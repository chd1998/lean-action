#
# MT7621 Profiles
#

DEFAULT_SOC := mt7621

KERNEL_DTB += -d21
DEVICE_VARS += UIMAGE_MAGIC ELECOM_HWNAME LINKSYS_HWNAME
IMAGE_SIZE := $(ralink_default_fw_size_32M)

# The OEM webinterface expects an kernel with initramfs which has the uImage
# header field ih_name.
# We don't want to set the header name field for the kernel include in the
# sysupgrade image as well, as this image shouldn't be accepted by the OEM
# webinterface. It will soft-brick the board.
define Build/custom-initramfs-uimage
	mkimage -A $(LINUX_KARCH) \
		-O linux -T kernel \
		-C lzma -a $(KERNEL_LOADADDR) $(if $(UIMAGE_MAGIC),-M $(UIMAGE_MAGIC),) \
		-e $(if $(KERNEL_ENTRY),$(KERNEL_ENTRY),$(KERNEL_LOADADDR)) \
		-n '$(1)' -d $@ $@.new
	mv $@.new $@
endef

define Device/phicomm_k2p
  IMAGE_SIZE := 32448k
  DEVICE_VENDOR := Phicomm
  DEVICE_MODEL := K2P
  DEVICE_ALT0_VENDOR := Phicomm
  DEVICE_ALT0_MODEL := KE 2P
  SUPPORTED_DEVICES += k2p
  DEVICE_PACKAGES := kmod-mt7615e kmod-mt7615-firmware wpad-basic
endef
TARGET_DEVICES += phicomm_k2p
