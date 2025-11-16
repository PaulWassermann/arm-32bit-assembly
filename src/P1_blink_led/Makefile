AS = arm-none-eabi-as
LD = arm-none-eabi-ld

BIN_DIR = bin
OBJ_DIR = obj
SRC_DIR = src

ELF  = main
SRCS = $(wildcard $(SRC_DIR)/*.s)
OBJS = $(addprefix $(OBJ_DIR)/, $(patsubst %.s,%.o,$(notdir $(SRCS))))

# Debug variables
DEBUG_DIR = debug
DEBUG_FLAGS = -g --warn --info --fatal-warnings
DEBUG_OBJS = $(addprefix $(DEBUG_DIR)/, $(OBJS))
DEBUG_TARGET = $(DEBUG_DIR)/$(BIN_DIR)/$(ELF)

# Phony targets declaration
.PHONY: all clean debug debug-session

# Debug rules
debug: $(DEBUG_TARGET)

$(DEBUG_DIR)/$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(DEBUG_DIR)/$(OBJ_DIR)
	$(AS) -g -o $@ $<

$(DEBUG_TARGET): $(DEBUG_OBJS)
	@mkdir -p $(DEBUG_DIR)/$(BIN_DIR)
	$(LD) -T stm32f303vc.ld -o $@ $^

# Shared targets
all: clean $(DEBUG_TARGET)

clean:
	rm -rf $(DEBUG_DIR) $(RELEASE_DIR)

debug-session: debug
	gdb -x conf.gdb $(DEBUG_TARGET)
