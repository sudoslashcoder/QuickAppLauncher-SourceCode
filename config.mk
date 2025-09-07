# Force Theos to use system toolchain instead of theos/toolchain/clang
export THEOS_PLATFORM_DEVELOPER_BIN_PATH := /usr/bin
export CC  := clang
export CXX := clang++
export LD  := ld.lld

