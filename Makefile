run: build
	./build/game.exe

build: main.go util.go
	rm -rf ./build && go build -o build/game.exe main.go util.go