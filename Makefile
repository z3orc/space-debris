run:
	zig build run

build:
	zig build --release=safe

release:
	git checkout release && git pull && git rebase main && git push && git checkout main
