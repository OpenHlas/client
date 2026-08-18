
build:
	meson setup build --prefix=/usr
install: 
	cd build && ninja && ninja install
uninstall: 
	cd build && ninja uninstall

gen-potfiles:
	@echo "# This file is generated automatic" > po/POTFILES
	@find data -name "*.in" -not -path "*/build/*" >> po/POTFILES
	@find src -name "*.vala" -not -path "*/build/*" >> po/POTFILES

translations: 
	@NAME=$$(grep -oP "project\('\K[^']+" meson.build); \
	cd build && ninja $$NAME-pot && ninja $$NAME-update-po

run: 
	cd build && ninja
	GSETTINGS_BACKEND=keyfile TEXTDOMAINDIR=build/po LANGUAGE=$${LANGUAGE:-en} OPENHLAS_ENV=$${OPENHLAS_ENV:-dev} ./build/src/$$(grep -oP "project\('\K[^']+" meson.build | tr '[:upper:]' '[:lower:]' | awk -F. '{print $$NF}')

build-run: gen-potfiles clean build translations run

clean: 
	rm -rf build