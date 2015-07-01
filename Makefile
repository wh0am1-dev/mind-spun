default: build run

clean:
	rm game.love

build:
	zip -r game.love *

run:
	~/Software/gamedev/love/love.app/Contents/MacOS/love game.love
