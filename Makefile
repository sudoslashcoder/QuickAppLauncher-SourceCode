FINALPACKAGE=1
ARCHS = arm64
TARGET := iphone:clang:16.5:latest

# Rootless support
THEOS_PACKAGE_SCHEME = rootless

# Processes where the tweak should inject (informational)
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

# ---- Tweak ----
TWEAK_NAME = QuickAppLauncher
QuickAppLauncher_FILES = Tweak.xm QALOverlayWindow.m QALPreferences.m
QuickAppLauncher_CFLAGS = -fobjc-arc
QuickAppLauncher_FRAMEWORKS = UIKit Foundation CoreGraphics
QuickAppLauncher_PRIVATE_FRAMEWORKS = SpringBoardServices FrontBoardServices MobileCoreServices AppSupport


include $(THEOS_MAKE_PATH)/tweak.mk

# ---- Preferences subproject ----
SUBPROJECTS += QuickAppLauncherPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk

# NOTE: no after-install/after-remove hooks that respring the device (per request)