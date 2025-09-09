ARCHS = arm64
TARGET := iphone:clang:16.5:latest

# Rootless support
THEOS_PACKAGE_SCHEME = rootless

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuickAppLauncher
QuickAppLauncher_FILES = Tweak.xm QALOverlayWindow.m QALPreferences.m
QuickAppLauncher_CFLAGS = -fobjc-arc
QuickAppLauncher_FRAMEWORKS = UIKit Foundation CoreGraphics
QuickAppLauncher_PRIVATE_FRAMEWORKS = SpringBoardServices FrontBoardServices MobileCoreServices AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += QuickAppLauncherPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk

# ? Auto respring after install
after-install::
	install.exec "killall -9 SpringBoard"