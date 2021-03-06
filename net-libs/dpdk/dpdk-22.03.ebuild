# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs flag-o-matic linux-info linux-mod

DESCRIPTION="A set of libraries and drivers for fast packet processing"
HOMEPAGE="http://dpdk.org/"
SRC_URI="http://fast.${PN}.org/rel/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug cuda numa ssl static-libs"

DEPEND="
	numa? ( sys-process/numactl:* )
	ssl? ( dev-libs/openssl:* )
	cuda? ( dev-util/nvidia-cuda-sdk:* )
"
RDEPEND="${DEPEND}"
DEPEND="
	${DEPEND}
	!net-libs/dpdk:stable
	dev-lang/nasm
"

function ctarget() {
	CTARGET="${ARCH}"
	use amd64 && CTARGET='x86_64'
	echo $CTARGET
}

CONFIG_CHECK="~IOMMU_SUPPORT ~AMD_IOMMU ~VFIO ~VFIO_PCI ~UIO ~UIO_PDRV_GENIRQ ~UIO_DMEM_GENIRQ"
if [ "$SLOT" != "0" ] ; then
	S=${WORKDIR}/${PN}-${SLOT#0/}-${PV}
fi

pkg_setup() {
	linux-mod_pkg_setup
}

src_configure() {
	local mesonargs=(
		-Ddefault_library=$(usex static-libs static shared)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
