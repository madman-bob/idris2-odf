.PHONY: test retest samples clean

INTERACTIVE ?= --interactive
threads ?= $(shell (nproc || sysctl -n hw.ncpu) 2>/dev/null || echo 1)

test: build/exec/odf-tests samples
	./build/exec/odf-tests idris2 $(INTERACTIVE) --timing --failure-file failures --threads $(threads) --only $(only)

retest: build/exec/odf-tests samples
	./build/exec/odf-tests idris2 $(INTERACTIVE) --timing --failure-file failures --threads $(threads) --only-file failures --only $(only)

build/exec/odf-tests: odf-tests.ipkg ODFTests.idr
	idris2 --build odf-tests.ipkg

samples:
	make -C sampleODFs all

clean:
	$(RM) failures
	$(RM) -r build
	@find . -type f -name 'output' -exec rm -rf {} \;
	make -C samples clean
