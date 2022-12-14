# name of your application
APPLICATION = ocaml

# If no BOARD is found in the environment, use this default:
BOARD ?= native

# This has to be the absolute path to the RIOT base directory:
RIOTBASE ?= $(CURDIR)/../RIOT

# Comment this out to disable code in RIOT that does safety checking
# which is not needed in a production environment but helps in the
# development process:
DEVELHELP ?= 1

# Change this to 0 show compiler invocation lines by default:
QUIET ?= 0

USEMODULE += stdin

all: runtime.bc.c runtimelib

runtime.bc.c: hello-world/main.ml hello-world/dune hello-world/dune-project
	cd hello-world && dune build
	rm -f runtime.bc.c
	cp _build/default/hello-world/main.bc.c ./runtime.bc.c

include $(RIOTBASE)/Makefile.include
#
ocaml/Makefile:
	sed -i -e 's/oc_cflags="/oc_cflags="$$OC_CFLAGS /g' ocaml/configure
	sed -i -e 's/ocamlc_cflags="/ocamlc_cflags="$$OCAMLC_CFLAGS /g' ocaml/configure
#
CFLAGS := $(subst \",",$(CFLAGS))
CFLAGS := $(subst ',,$(CFLAGS))
CFLAGS := $(subst -Wstrict-prototypes,,$(CFLAGS))
CFLAGS := $(subst -Werror,,$(CFLAGS))
CFLAGS := $(subst -Wold-style-definition,,$(CFLAGS))
#CFLAGS := $(subst -fdiagnostics-color,,$(CFLAGS))
#
OCAML_CFLAGS := $(CFLAGS)
OCAML_LIBS := $(LINKFLAGS)
RIOTBUILD_H_FILE := $(CURDIR)/bin/native/riotbuild/riotbuild.h
.PHONY: runtimelib
runtimelib: $(RIOTBUILD_H_FILE)
	CC="$(CC)" \
	CFLAGS="" \
	AS="$(AS)" \
	ASPP="$(CC) $(OCAML_CFLAGS) -c" \
	CPPFLAGS="$(OCAML_CFLAGS)" \
	LIBS="$(OCAML_LIBS) --entry main" \
	dune build include/ libcamlrun.a --verbose

CFLAGS += -I$(CURDIR)/include/
LINKFLAGS += -L$(CURDIR) -lcamlrun -lm