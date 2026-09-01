THEOS_PACKAGE_SCHEME=rootless
TARGET = iphone:clang:latest:11.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

# Build as dylib instead of deb package
TWEAK_NAME = GPSSpoofing
GPSSpoofing_FILES = Tweak.xm
GPSSpoofing_FRAMEWORKS = Foundation UIKit CoreLocation CoreBluetooth NetworkExtension LocalAuthentication Security
GPSSpoofing_PRIVATE_FRAMEWORKS = AppKit
GPSSpoofing_LIBRARIES = substrate
GPSSpoofing_CFLAGS = -fobjc-arc

# Dylib configuration
GPSSpoofing_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

# Build dylib only
dylib: all
	@echo "✅ Dylib built successfully!"
	@echo "Location: $(THEOS_OBJ_DIR)/GPSSpoofing.dylib"
