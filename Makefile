ARCHS = arm64
TARGET := iphone:clang:16.5:latest

# Force Theos to use these programs (optional)
export CC=/toolchain/linux/iphone/bin/ld
export CXX=/toolchain/linux/iphone/bin/ld
export LD=$(THEOS)/toolchain/linux/iphone/bin/ld

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

# ---- Tweak ----
TWEAK_NAME = QuickAppLauncher
QuickAppLauncher_FILES = Tweak.xm QALOverlayWindow.m QALPreferences.m
QuickAppLauncher_CFLAGS = -fobjc-arc
QuickAppLauncher_FRAMEWORKS = UIKit Foundation CoreGraphics
QuickAppLauncher_PRIVATE_FRAMEWORKS = SpringBoardServices FrontBoardServices MobileCoreServices AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

# ---- Subproject (Preferences Bundle) ----
SUBPROJECTS += QuickAppLauncherPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
