# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Please report bugs/suggestions on: https://github.com/anyc/steam-overlay
# or come to #gentoo-gamerlay in freenode IRC

DESCRIPTION="Meta package for Steam games"
HOMEPAGE="http://steampowered.com"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="s3tc mono testdeps video_cards_intel video_cards_fglrx video_cards_nouveau
	video_cards_nvidia video_cards_radeon"

# add USE_EXPAND="${USE_EXPAND} STEAMGAMES" to your make.conf for proper
# display of steamgames use flags
IUSE_STEAMGAMES="dwarfs unwritten_tales tf2 trine2 journey_down defenders_quest
	shatter hammerwatch"

for sgame in ${IUSE_STEAMGAMES}; do
	IUSE="${IUSE} steamgames_${sgame}"
done

RDEPEND="
		s3tc? (
			amd64? ( || (
				>=media-libs/libtxc_dxtn-1.0.1-r1[abi_x86_32]
				<media-libs/libtxc_dxtn-1.0.1-r1[multilib]
				) )
			x86? ( media-libs/libtxc_dxtn )
			)
		mono? (
			dev-lang/mono
			)
		testdeps? (
			x86? (
				dev-db/sqlite
				dev-games/ogre
				media-libs/freealut
				media-libs/freeglut
				media-libs/libtheora
				media-libs/libvorbis
				media-libs/openal
				media-libs/sdl-image
				media-libs/sdl-mixer
				media-libs/sdl-ttf
				media-libs/tiff
				net-dns/libidn
				net-misc/curl
				sys-apps/pciutils
				x11-libs/libXaw
				x11-libs/libXft
				x11-libs/libXmu
				x11-libs/libXxf86vm
				x11-misc/xclip
				)
			)
		steamgames_dwarfs? (
				x86? ( media-libs/libexif )
				amd64? ( >=media-libs/libexif-0.6.21-r1[abi_x86_32] )
			)
		steamgames_unwritten_tales? (
				x86? ( media-libs/jasper )
				amd64? ( >=media-libs/jasper-1.900.1-r6[abi_x86_32] )
			)
		steamgames_tf2? (
				video_cards_fglrx? ( >=x11-drivers/ati-drivers-12.8 )
			)
		steamgames_journey_down? (
				x86? ( media-libs/openal )
			)
		steamgames_trine2? (
				x11-apps/xwininfo
				x86? (
					|| (
						sys-libs/libselinux
						sys-libs/steam-runtime-libselinux
						)
					)
				amd64? (
						sys-libs/steam-runtime-libselinux[abi_x86_32]
					)
			)
		steamgames_defenders_quest? (
				dev-util/adobe-air-runtime
			)
		steamgames_shatter? (
				amd64? ( >=media-gfx/nvidia-cg-toolkit-3.1.0013 )
				x86? ( media-gfx/nvidia-cg-toolkit )
			)
		"
REQUIRED_USE="
		steamgames_tf2? (
				video_cards_intel? ( s3tc )
				video_cards_radeon? ( s3tc )
				video_cards_nouveau? ( s3tc )
			)
		steamgames_hammerwatch? ( mono )
		"

S=${WORKDIR}

src_install() {
	local SR_DIR="/opt/steam-runtime/"

	if use steamgames_trine2; then
		mkdir -p "${D}/${SR_DIR}/lib32/"
		ln -s /lib32/libpcre.so.1 "${D}/${SR_DIR}/lib32/libpcre.so.3"
		if use amd64; then
			mkdir -p "${D}/${SR_DIR}/lib64/"
			ln -s /lib/libpcre.so.1 "${D}/${SR_DIR}/lib64/libpcre.so.3"
		fi
	fi
}

pkg_postinst() {
	if use x86; then
		elog "If a game does not start, please enable \"testdeps\" use-flag and"
		elog "check if it fixes the issue. Please report, if and which one of the"
		elog "dependencies is required for a game, so we can mark it accordingly."
		elog ""
	fi

	if use amd64; then
		elog "If a game does not start, please take a look at the dependencies"
		elog "for the x86 architecture in this ebuild. It might be required that"
		elog "we create a multilib ebuild for x86. Please report, if and which"
		elog "one of the dependencies is required for a game, so we can mark it"
		elog "accordingly."
		elog ""
	fi
	elog "Ebuild development website: http://github.com/anyc/steam-overlay"
	elog ""
	elog "If you have problems, please also see http://wiki.gentoo.org/wiki/Steam"
}
