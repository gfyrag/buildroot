################################################################################
#
# php-apcu
#
################################################################################

PHP_APCU_VERSION = 4.0.7
PHP_APCU_SOURCE = apcu-$(PHP_APCU_VERSION).tgz
PHP_APCU_SITE = http://pecl.php.net/get
PHP_APCU_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config
# phpize does the autoconf magic
PHP_APCU_DEPENDENCIES = php host-autoconf
PHP_APCU_LICENSE = PHP
PHP_APCU_LICENSE_FILES = LICENSE

define PHP_APCU_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_APCU_PRE_CONFIGURE_HOOKS += PHP_APCU_PHPIZE

$(eval $(autotools-package))