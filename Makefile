default: build run

clean:
	rm Mind-Spun.love

build:
	zip -r Mind-Spun.love *

run:
	~/Software/gamedev/love/love.app/Contents/MacOS/love Mind-Spun.love
