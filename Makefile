OUT_DIR?=/tmp
LIBJPEGTURBODIR=$(OUT_DIR)/libjpegturbo
CONFIGOPTIONS=--host="$(HOST)" --build="$(TARGET)" --enable-static --disable-shared --without-arith-enc --without-arith-dec --without-java --without-turbojpeg

all: $(OUT_DIR)/lib/libjpeg.a
	@echo "cargo:rustc-flags=-l static=jpeg -L native=$(OUT_DIR)/lib"

$(OUT_DIR)/lib/libjpeg.a: $(LIBJPEGTURBODIR)/Makefile
	$(MAKE) -C $(LIBJPEGTURBODIR) install

$(LIBJPEGTURBODIR)/Makefile: $(LIBJPEGTURBODIR)/configure
	( cd $(LIBJPEGTURBODIR) && ./configure --prefix="$(OUT_DIR)" $(CONFIGOPTIONS) )

$(LIBJPEGTURBODIR)/configure: $(LIBJPEGTURBODIR)/configure.ac
	( cd $(LIBJPEGTURBODIR) && autoreconf -i ) && touch "$@"

$(LIBJPEGTURBODIR)/configure.ac:
	git clone --depth=1 https://github.com/libjpeg-turbo/libjpeg-turbo.git "$(LIBJPEGTURBODIR)"

clean:
	-rm -rf $(LIBJPEGTURBODIR)

.PHONY: all clean
