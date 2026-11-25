ARCHS = arm64 arm64e
TARGET := iphone:clang:17.0:13.0
INSTALL_TARGET_PROCESSES = duanzao

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GameSpeedMod

GameSpeedMod_FILES = Tweak.xm
GameSpeedMod_FRAMEWORKS = UIKit WebKit Foundation
GameSpeedMod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
