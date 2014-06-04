~/Dropbox/FuckThisJam2014/builds:
	mkdir -p ~/Dropbox/FuckThisJam2014/builds

~/Dropbox/FuckThisJam2014/builds/ftj14.love: ~/Dropbox/FuckThisJam2014/builds ../build/ftj14.love
	cp ../build/ftj14.love ~/Dropbox/FuckThisJam2014/builds/

../build/ftj14.love: main.lua
	zip -r ../build/ftj14.love *

run: ~/Dropbox/FuckThisJam2014/builds/ftj14.love
	love ~/Dropbox/FuckThisJam2014/builds/ftj14.love

clean:
	rm ~/Dropbox/FuckThisJam2014/builds/ftj14.love
	rm ../build/ftj14.love
