LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
VNC_PATH := /home/ubuntu/droid-VNC-server/system-lib
LOCAL_MODULE := libgui-prebuilt
LOCAL_SRC_FILES := $(VNC_PATH)/libgui.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
VNC_PATH := /home/ubuntu/droid-VNC-server/system-lib
LOCAL_MODULE := libui-prebuilt
LOCAL_SRC_FILES := $(VNC_PATH)/libui.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
VNC_PATH := /home/ubuntu/droid-VNC-server/system-lib
LOCAL_MODULE := libbinder-prebuilt
LOCAL_SRC_FILES := $(VNC_PATH)/libbinder.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
VNC_PATH := /home/ubuntu/droid-VNC-server/system-lib
LOCAL_MODULE := libcutils-prebuilt
LOCAL_SRC_FILES := $(VNC_PATH)/libcutils.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
VNC_PATH := /home/ubuntu/droid-VNC-server/system-lib
LOCAL_MODULE := libutils-prebuilt
LOCAL_SRC_FILES := $(VNC_PATH)/libutils.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
VNC_PATH := /home/ubuntu/droid-VNC-server/system-lib
LOCAL_MODULE := libc-prebuilt
LOCAL_SRC_FILES := $(VNC_PATH)/libc.so
include $(PREBUILT_SHARED_LIBRARY)


include $(CLEAR_VARS)

LOCAL_SRC_FILES = \
									flinger.cpp

#LOCAL_CFLAGS += -DPLATFORM_SDK_VERSION=$(PLATFORM_SDK_VERSION)

LOCAL_C_INCLUDES +=	\
										$(LOCAL_PATH) \
										$(LOCAL_PATH)/..

LOCAL_PRELINK_MODULE:=false #override prelink map
LOCAL_MODULE:= libdvnc_flinger_sdk$(PLATFORM_SDK_VERSION)
LOCAL_MODULE_TAGS:= optional
LOCAL_MODULE_PATH := $(LOCAL_PATH)/../libs/$(TARGET_CPU_ABI)

#ifeq ($(PLATFORM_SDK_VERSION),9)
#LOCAL_SHARED_LIBRARIES := libsurfaceflinger_client libui libbinder libutils  libcutils #libcrypto libssl libhardware
#else ifeq ($(PLATFORM_SDK_VERSION),10)
#LOCAL_SHARED_LIBRARIES := libsurfaceflinger_client libui libbinder libutils  libcutils #libcrypto libssl libhardware
#else ifeq ($(PLATFORM_SDK_VERSION),14)
#LOCAL_SHARED_LIBRARIES := libgui libui libbinder libcutils
#else ifeq ($(PLATFORM_SDK_VERSION),15)
#LOCAL_SHARED_LIBRARIES := libgui libui libbinder libcutils
#else
#add here more sdk versions
LOCAL_SHARED_LIBRARIES := libgui-prebuilt libui-prebuilt libbinder-prebuilt libcutils-prebuilt libutils-prebuilt libc-prebuilt
#endif

include $(BUILD_SHARED_LIBRARY)
