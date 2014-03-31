
PACKAGE_INCLUDES = "WELCOME.pdf,bioBakeryWallpaper.png,bioBakeryWallpaper.pptx"

all: gui

gui: 
	cd biobakery-gui
	vagrant up
	vagrant halt
	cd -

dist: bioBakery.box
	mv -v biobakery-gui/bioBakery.box biobakery_dist/
	zip -r bioBakery_`date '+%F'`.zip biobakery_dist/

bioBakery.box:
	cd biobakery-gui
	vagrant halt
	vagrant package --include $(PACKAGE_INCLUDES) --ouput bioBakery.box
	cd -
