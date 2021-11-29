.PHONY: all clean

zipODF = cd $(1) && zip -0 -X ../$(1).$(2) mimetype && zip -r ../$(1).$(2) * -x mimetype

all: simpleSheet.ods templateDoc.odt

simpleSheet.ods: simpleSheet/* simpleSheet/*/*
	$(call zipODF,simpleSheet,ods)

templateDoc.odt: templateDoc/* templateDoc/*/*
	$(call zipODF,templateDoc,odt)

clean:
	$(RM) *.ods
