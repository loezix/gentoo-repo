# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
inherit gnome.org gnome2-utils meson python-any-r1 readme.gentoo-r1 xdg

DESCRIPTION="A minimal terminal for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/console"

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug +gnome-shell +nautilus vanilla"
SRC_URI="https://download.gnome.org/sources/gnome-console/42/gnome-console-42.beta.tar.xz"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

# FIXME: automagic dependency on gtk+[X], just transitive but needs proper control, bug 624960
RDEPEND="
	>=dev-libs/glib-2.52:2
	>=x11-libs/gtk+-3.22.27:3
	>=x11-libs/vte-0.68.0:2.91
	>=dev-libs/libpcre2-10
	>=gnome-base/dconf-0.14
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/util-linux
	gnome-shell? ( gnome-base/gnome-shell )
	nautilus? ( >=gnome-base/nautilus-3.28.0 )
"
DEPEND="${RDEPEND}"
# itstool required for help/* with non-en LINGUAS, see bug #549358
# xmllint required for glib-compile-resources, see bug #549304
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	dev-lang/sassc
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DOC_CONTENTS="To get previous working directory inherited in new opened tab, or
	notifications of long-running commands finishing, you will need
	to add the following line to your ~/.bashrc:\n
	. /etc/profile.d/vte-2.91.sh"

src_unpack() {
	default
	mv ${WORKDIR}/gnome-console-42.beta ${WORKDIR}/${P}
}

src_prepare() {
	default
}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}