#############################################################
#
# gogs
#
#############################################################
GOGS_VERSION = v0.6.15
GOGS_SOURCE = $(GOGS_VERSION).tar.gz
GOGS_SITE = https://github.com/gogits/gogs/archive/
GOGS_DEPENDENCIES = linux-pam host-golang

TAGS = redis memcache

ifeq ($(BR2_PACKAGE_SQLITE),y)
TAGS += sqlite
endif

define GOGS_BUILD_CMDS
	mkdir -p $(@D)/.go/src/github.com/gogits/gogs \
		&& cp -rf $(@D)/* $(@D)/.go/src/github.com/gogits/gogs \
		&& cd $(@D)/.go/src/github.com/gogits/gogs \
		&& GOROOT=$(HOST_DIR)/usr/lib/go GOPATH=$(@D)/.go $(HOST_DIR)/usr/bin/go get -tags "$(TAGS)" \
		&& GOROOT=$(HOST_DIR)/usr/lib/go GOPATH=$(@D)/.go $(HOST_DIR)/usr/bin/go build -tags "$(TAGS)"
endef

define GOGS_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/.go/src/github.com/gogits/gogs/gogs $(TARGET_DIR)/usr/share/gogs/gogs
    cp -rf $(@D)/.go/src/github.com/gogits/gogs/public $(TARGET_DIR)/usr/share/gogs
    cp -rf $(@D)/.go/src/github.com/gogits/gogs/templates $(TARGET_DIR)/usr/share/gogs
endef

$(eval $(generic-package))