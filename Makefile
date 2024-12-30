RAYLIB_PATH = C:\Users\pahas\scoop\apps\raylib-mingw\current
BINARY = main.exe
BUILD_MODE =? DEBUG
W_CONSOLE =? SHOW

SRC_DIR = src
OBJ_DIR = build
BIN_DIR = bin

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

CFLAGS = -I include -I $(RAYLIB_PATH)/include -L $(RAYLIB_PATH)/lib -lraylib -lopengl32 -lgdi32 -lwinmm
CFLAGS += -std=c99 -g -Wextra -Wall -Wno-missing-braces 

ifeq ($(W_CONSOLE),SHOW)
	CFLAGS += -Wl,--subsystem,windows
endif

ifeq ($(BUILD_MODE),DEBUG)
	CFLAGS += -g -O0
else
	CFLAGS += -s -O1
endif

run: build
	$(BIN_DIR)/$(BINARY)

build: $(OBJS) 
	gcc -o $(BIN_DIR)/$(BINARY) $(OBJS) $(CFLAGS) 

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	gcc -c $< -o $@ $(CFLAGS)

clean:
	rm $(OBJ_DIR)/* $(BIN_DIR)/$(BINARY)