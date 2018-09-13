NAME := linkkit_gateway
$(NAME)_SOURCES := app_entry.c

$(NAME)_COMPONENTS += network/netmgr \
                      middleware/common \
                      utility/cjson

ifeq ($(COMPILER),iar)
$(NAME)_COMPONENTS += feature.linkkit-gateway-nouota
else
$(NAME)_COMPONENTS += feature.linkkit-gateway
$(NAME)_INCLUDES   += ../../../middleware/uagent/uota/src/service
$(NAME)_COMPONENTS += middleware/uagent/uota
endif

GLOBAL_CFLAGS += -DCONFIG_DM_DEVTYPE_GATEWAY  \
                 -DMQTT_DIRECT   \

ifeq ($(LWIP),1)
$(NAME)_COMPONENTS  += protocols.net
no_with_lwip := 0
endif

ifeq ($(newapi),1)
$(NAME)_SOURCES += newapi/gateway.c
else
$(NAME)_SOURCES += linkkit_example_gateway.c
GLOBAL_CFLAGS += -DDEPRECATED_LINKKIT
endif

ifeq ($(print_heap),1)
$(NAME)_DEFINES += CONFIG_PRINT_HEAP
endif


ifneq ($(HOST_MCU_FAMILY),esp8266)
$(NAME)_COMPONENTS  += cli
GLOBAL_DEFINES += CONFIG_AOS_CLI
else
GLOBAL_DEFINES += ESP8266_CHIPSET
endif

#for test command
#GLOBAL_CFLAGS += -DLINKKIT_GATEWAY_TEST_CMD
#$(NAME)_SOURCES += simulate_subdev/testcmd.c simulate_subdev/testcmd_lock.c
#end

GLOBAL_INCLUDES += ./
