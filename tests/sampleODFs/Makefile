.PHONY: all clean

all: simpleSheet.ods

simpleSheet.ods: simpleSheet/* simpleSheet/*/*
	cd simpleSheet && zip -0 -X ../simpleSheet.ods mimetype && zip -r ../simpleSheet.ods * -x mimetype

clean:
	$(RM) *.ods
