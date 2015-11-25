################################################################################
#
# GOLANG
#
################################################################################

GOLANG_VERSION = 1.4.2
GOLANG_SOURCE = go$(GOLANG_VERSION).src.tar.gz
GOLANG_SITE = https://storage.googleapis.com/golang
GOLANG_LICENSE =
GOLANG_LICENSE_FILES = LICENSE

GOLANG = $(HOST_DIR)/usr/bin/go
GOLANGFMT = $(HOST_DIR)/usr/bin/gofmt

GOLANG_ENV = \
	CC_FOR_TARGET="$(TARGET_CC)" \
	LD_FOR_TARGET="$(TARGET_LD)" \
	GOOS=linux
GOLANG_ARCH =

ifeq ($(BR2_i386),y)
GOLANG_ARCH = 386
ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
GOLANG_ENV += GO386=sse2
else
GOLANG_ENV += GO386=387
endif
endif # i386

ifeq ($(BR2_x86_64),y)
GOLANG_ARCH = amd64
endif # x86_64

# For ARM, the selection of the instruciton set is a bit unusual,
# and is decided on whether the CPU has an FPU, and which one.
ifeq ($(BR2_arm),y)
GOLANG_ARCH = arm
ifeq ($(BR2_ARM_CPU_HAS_VFPV3),y)
GOLANG_ENV += GOARM=7
else ifeq ($(BR2_ARM_CPU_HAS_VFPV2),y)
GOLANG_ENV += GOARM=6
else
GOLANG_ENV += GOARM=5
endif
endif # arm

GOLANG_ENV += GOARCH=$(GOLANG_ARCH)

define GOLANG_BUILD_CMDS
	cd $(@D)/src/; \
	$(GOLANG_ENV) GOROOT_FINAL="/usr/lib/go" GO_NO_HOST=1 \
	./make.bash --no-banner
endef

# We must install both the src/ and include/ subdirs because they
# contain the go "runtime".
define GOLANG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/linux_$(GOLANG_ARCH)/go $(TARGET_DIR)/usr/bin/go
	$(INSTALL) -D -m 0755 $(@D)/bin/linux_$(GOLANG_ARCH)/gofmt $(TARGET_DIR)/usr/bin/gofmt
	rm -rf $(TARGET_DIR)/usr/lib/go/
	mkdir -p $(TARGET_DIR)/usr/lib/go/
	cp -a $(@D)/src $(TARGET_DIR)/usr/lib/go/
	cp -a $(@D)/include $(TARGET_DIR)/usr/lib/go/
	cp -a $(@D)/pkg $(TARGET_DIR)/usr/lib/go/
endef

HOST_GOLANG_DEPENDENCIES += toolchain

define HOST_GOLANG_BUILD_CMDS
	cd $(@D)/src/ ; \
	$(GOLANG_ENV) GOROOT_FINAL="$(HOST_DIR)/usr/lib/go" GO_NO_TARGET=1 \
	./make.bash --no-banner
endef

# We must install both the src/ and include/ subdirs because they
# contain the go "runtime"
define HOST_GOLANG_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/host/go $(HOST_DIR)/usr/bin/go
	$(INSTALL) -D -m 0755 $(@D)/bin/host/gofmt $(HOST_DIR)/usr/bin/gofmt
	rm -rf $(HOST_DIR)/usr/lib/go/
	mkdir -p $(HOST_DIR)/usr/lib/go/
	cp -a $(@D)/src $(HOST_DIR)/usr/lib/go/
	cp -a $(@D)/include $(HOST_DIR)/usr/lib/go/
	cp -a $(@D)/pkg $(HOST_DIR)/usr/lib/go/
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
