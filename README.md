# OpenHlas client

A minimal, opinionated template for building desktop applications with Vala and GTK. This repository provides a simple project structure, build scripts, and examples to get you started quickly.

Features
- Vala source layout
- Meson + Ninja build files
- Basic GTK application skeleton

Requirements
- [Vala](https://docs.vala.dev/)
- [Vala compiler](https://wiki.gnome.org/Projects/Vala) (>= 0.54)
- [Meson build system](https://mesonbuild.com/)
- [Ninja](https://ninja-build.org/)
- [GTK 3](https://www.gtk.org/docs/gtk-3/) or [GTK 4](https://docs.gtk.org/gtk4/) development packages (depending on template)
 - [GLib / GIO development packages](https://developer.gnome.org/glib/) (glib-2.0)
 - [Libadwaita](https://gnome.pages.gitlab.gnome.org/libadwaita/) development package (libadwaita-1, >= 1.6)
 - Math library (libm) — usually provided by the system C library (optional)

Quick start
1. Install dependencies

    Debian/Ubuntu:
    ```sh
	sudo apt install valac meson ninja-build libgtk-3-dev
    ```

   Fedora:
   ```sh
	sudo dnf install valac meson ninja gtk4-devel
    ```
	# For GTK 3, replace gtk4-devel with gtk3-devel

2. Configure and build:
	meson setup build
	meson compile -C build

Alternative (Makefile)
If you prefer using the provided Makefile, the following targets are available:

- build: configure the meson build directory (meson setup build --prefix=/usr)
- run: build and run the application (invokes ninja then runs the built binary)
- build-run: clean, build, extract translations and run (shorthand for a full dev cycle)
- install: install the built files to the system (ninja install in build dir)
- uninstall: undo install (ninja uninstall in build dir)
- translations: generate/update POT/PO files (uses meson-generated targets)
- clean: remove the build directory

Usage example:

    make build
    make run

Development environment:

    OPENHLAS_ENV=dev make build-run

`OPENHLAS_ENV=dev` enables the in-memory mock master client. The default for the
Makefile run target is `dev`; use `OPENHLAS_ENV=production make run` to verify
the production path. Mock data is never selected for other environment values.

3. Run the application:
	./build/src/vala_application_template

Project structure
- src/ - Vala source files
- data/ - UI files, icons, resources
- meson.build - top-level build file
- README.md - this file

Development notes
- Use `meson setup --reconfigure build` after changing build options
- Use `valac --version` to check your Vala toolchain

License
Specify your preferred license in the LICENSE file. This template does not include a license by default.

Contributing
Feel free to open issues or submit pull requests to improve the template.

Enjoy building with Vala!

## Contributors

<div>
  <a href="https://github.com/OpenHlas/client/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=OpenHlas/client" />
  </a>
</div>