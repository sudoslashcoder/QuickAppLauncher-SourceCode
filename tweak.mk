include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuickAppLauncher
QuickAppLauncher_FILES = Tweak.x
QuickAppLauncher_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

