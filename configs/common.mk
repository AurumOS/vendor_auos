PRODUCT_BRAND ?= au

SUPERUSER_EMBEDDED := true

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/au/prebuilt/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/au/prebuilt/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/au/prebuilt/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

# Common dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/au/overlay/dictionaries
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

#SELinux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/au/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/au/prebuilt/common/bin/50-au.sh:system/addon.d/50-au.sh \
    vendor/au/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/au/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/au/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/au/configs/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/etc/init.d/00start:system/etc/init.d/00start \
    vendor/au/prebuilt/common/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
    vendor/au/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/au/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# aurum-specific init file
PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/etc/init.local.rc:root/init.au.rc \

# Installer
PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/bin/persist.sh:install/bin/persist.sh \
    vendor/au/prebuilt/common/etc/persist.conf:system/etc/persist.conf

PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/lib/libmicrobes_jni.so:system/lib/libmicrobes_jni.so \
    vendor/au/prebuilt/common/etc/resolv.conf:system/etc/resolv.conf

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/au/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

PRODUCT_COPY_FILES += \
    vendor/au/configs/permissions/com.au.android.xml:system/etc/permissions/com.au.android.xml

# Theme engine
include vendor/au/configs/themes_common.mk

# CMSDK
include vendor/au/configs/cmsdk_common.mk

# Required aurumOS packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    CellBroadcastReceiver \
    Development \
    LatinIME \
    LatinImeDictionaryPack \
    libemoji \
    mGerrit \
    Microbes \
    ROMControl \
    Stk

# Optional aurumOS packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# Custom CM packages
PRODUCT_PACKAGES += \
    AudioFX \
    CMWallpapers \
    CMFileManager \
    CMSettingsProvider \
    CyanogenSetupWizard \
    DataUsageProvider \
    Eleven \
    ExactCalculator \
    Launcher3 \
    LiveLockScreenService \
    LockClock \
    Trebuchet \
    WeatherProvider

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    tune2fs \
    nano \
    htop \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=3

# Common overlay
DEVICE_PACKAGE_OVERLAYS += vendor/au/overlay/common

PRODUCT_VERSION_MAJOR = 13
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0-RC0

# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

DATE = $(shell vendor/au/tools/getdate)
AU_BRANCH=mm

ifneq ($(AU_BUILD),)
    # AU_BUILD=<goo version int>/<build string>
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.goo.developerid=au \
        ro.goo.rom=au \
        ro.goo.version=$(shell echo $(AU_BUILD) | cut -d/ -f1)

    AU_VERSION=$(TARGET_PRODUCT)_$(AU_BRANCH)_$(shell echo $(AU_BUILD) | cut -d/ -f2)
else
    ifeq ($(AU_BUILDTYPE),)
        # AU_BUILDTYPE not defined
	AU_BUILDTYPE := alpha 
    endif

    AU_VERSION=$(TARGET_PRODUCT)_$(AU_BRANCH)_$(AU_BUILDTYPE)_$(DATE)
endif

AU_DISPLAY_VERSION := $(AU_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.au.version=$(AU_VERSION) \
    ro.au.branch=$(AU_BRANCH) \
    ro.au.device=$(AU_DEVICE) \
    ro.au.releasetype=$(AU_BUILDTYPE) \
    ro.modversion=$(AU_VERSION) \
    ro.au.display.version=$(AU_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
