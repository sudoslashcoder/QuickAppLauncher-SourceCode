ARCHS = arm64
TARGET = iphone:clang:16.5:latest
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuickAppLauncher
QuickAppLauncher_FILES = Tweak.x
QuickAppLauncher_CFLAGS = -fobjc-arc
QuickAppLauncher_LDFLAGS = -Wno-unused-command-line-argument

include $(THEOS)/makefiles/instance/tweak.mk

