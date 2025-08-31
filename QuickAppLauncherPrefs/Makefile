ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = QuickAppLauncherPrefs

QuickAppLauncherPrefs_FILES = QALRootListController.m
QuickAppLauncherPrefs_FRAMEWORKS = UIKit
QuickAppLauncherPrefs_PRIVATE_FRAMEWORKS = Preferences
QuickAppLauncherPrefs_INSTALL_PATH = /Library/PreferenceBundles
QuickAppLauncherPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/QuickAppLauncherPrefs.plist$(ECHO_END)

