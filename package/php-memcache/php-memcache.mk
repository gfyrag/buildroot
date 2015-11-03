################################################################################
#
# php-memcache
#
################################################################################

PHP_MEMCACHE_VERSION = 2.2.7
PHP_MEMCACHE_SOURCE = memcache-$(PHP_MEMCACHE_VERSION).tgz
PHP_MEMCACHE_SITE = http://pecl.php.net/get
PHP_MEMCACHE_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config --with-zlib-dir=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_MEMCACHE_DEPENDENCIES = php host-autoconf
PHP_MEMCACHE_LICENSE = PHP
PHP_MEMCACHE_LICENSE_FILES = LICENSE

define PHP_MEMCACHE_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_MEMCACHE_PRE_CONFIGURE_HOOKS += PHP_MEMCACHE_PHPIZE

$(eval $(autotools-package))