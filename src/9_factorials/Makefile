ASC = arm-linux-gnueabihf-as
ASL = arm-linux-gnueabihf-ld

BIN_DIR = bin
OBJ_DIR = obj
SRC_DIR = .

ELF = main
SRCS = $(wildcard $(SRC_DIR)/*.s)
OBJS = $(addprefix $(OBJ_DIR)/, $(patsubst %.s,%.o,$(notdir $(SRCS))))

# Debug variables
DEBUG_DIR = debug
DEBUG_FLAGS = -g -D --warn --info --fatal-warnings
DEBUG_OBJS = $(addprefix $(DEBUG_DIR)/, $(OBJS))
DEBUG_TARGET = $(DEBUG_DIR)/$(BIN_DIR)/$(ELF)

# Release variables
RELEASE_DIR = release
RELEASE_FLAGS = -O --relax
RELEASE_OBJS = $(addprefix $(RELEASE_DIR)/, $(OBJS))
RELEASE_TARGET = $(RELEASE_DIR)/$(BIN_DIR)/$(ELF)

.PHONY: all clean debug release remake

# Debug rules
debug: $(DEBUG_TARGET)

$(DEBUG_DIR)/$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(DEBUG_DIR)/$(OBJ_DIR)
	$(ASC) $(DEBUG_FLAGS) -o $@ $<

$(DEBUG_TARGET): $(DEBUG_OBJS)
	@mkdir -p $(DEBUG_DIR)/$(BIN_DIR)
	$(ASL) -o $@ $^

# Release rules
release: $(RELEASE_TARGET)

$(RELEASE_DIR)/$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(RELEASE_DIR)/$(OBJ_DIR)
	$(ASC) $(DEBUG_FLAGS) -o $@ $<

$(RELEASE_TARGET): $(RELEASE_OBJS)
	@mkdir -p $(RELEASE_DIR)/$(BIN_DIR)
	$(ASL) -o $@ $^

# Shared rules
all: release

remake: clean all

clean:
	rm -rf $(DEBUG_DIR) $(RELEASE_DIR)
