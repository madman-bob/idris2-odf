.PHONY: all install odf test retest clean

all: odf

install: odf
	idris2 --install odf.ipkg

odf: build/ttc/Language/ODF.ttc

build/ttc/Language/ODF.ttc: odf.ipkg ODF/* ODF/*/*
	idris2 --build odf.ipkg

test:
	make -C tests test

retest:
	make -C tests retest

clean:
	rm -rf build
