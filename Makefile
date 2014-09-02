IMG_SRC:="$(HOME)/Dropbox/marcusmennemeier/Bilder Projekte 2014-09-01/"
export PATH:="$(shell npm bin)":$(PATH)


run:
	docpad run

import_images:
	rsync --delete -rt --exclude=/index $(IMG_SRC) src/files/associated-files