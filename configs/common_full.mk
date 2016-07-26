# Inherit common Au stuff
$(call inherit-product, vendor/au/configs/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

PRODUCT_SIZE := full

# Include CM audio files
include vendor/au/configs/cm_audio.mk

# Include Au LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/au/overlay/dictionaries

# Optional Au packages
PRODUCT_PACKAGES += \
    CMSettingsProvider \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    PhotoPhase \
    PhotoTable \
    Screencast \
    SoundRecorder

PRODUCT_PACKAGES += \
    VideoEditor \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer

# Extra tools in Au
PRODUCT_PACKAGES += \
    7z \
    lib7z \
    bash \
    bzip2 \
    curl \
    powertop \
    unrar \
    unzip \
    vim \
    wget \
    zip
