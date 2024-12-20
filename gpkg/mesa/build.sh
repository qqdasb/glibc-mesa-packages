TERMUX_PKG_HOMEPAGE="https://www.mesa3d.org"
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux-pacman"
TERMUX_PKG_VERSION="24.5.0-dev"
TERMUX_PKG_SRCURL=git+https://gitlab.freedesktop.org/mesa/mesa.git
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_DEPENDS="libglvnd-glibc, gcc-libs-glibc, libdrm-glibc, libllvm-glibc, libexpat-glibc, zlib-glibc, zstd-glibc, libx11-glibc, libxcb-glibc, libxext-glibc, libxfixes-glibc, libxshmfence-glibc, libxxf86vm-glibc, libwayland-glibc, libvdpau-glibc, libomxil-bellagio-glibc, libva-glibc, libxml2-glibc, libelf-glibc, libbz2-glibc, libclc-glibc"
TERMUX_PKG_SUGGESTS="mesa-dev-glibc"
TERMUX_PKG_BUILD_DEPENDS="llvm-glibc, libwayland-protocols-glibc (<= 1.38), xorgproto-glibc, glslang-glibc, libwayland-glibc, libpng-glibc"
TERMUX_PKG_PYTHON_COMMON_DEPS="mako, setuptools, pyyaml"
# disabling libunwind, microsoft-clc and valgrind will improve performance

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-D android-libbacktrace=disabled
-D egl=enabled
-D gallium-opencl=icd
-D gallium-drivers=freedreno,swrast,virgl,zink
-D gallium-extra-hud=true
-D gallium-nine=true
-D gallium-va=enabled
-D gallium-vdpau=enabled
-D gallium-xa=disabled
-D gbm=enabled
-D gles1=enabled
-D gles2=enabled
-D glvnd=enabled
-D glx=dri
-D intel-clc=system
-D libunwind=disabled
-D llvm=enabled
-D microsoft-clc=disabled
-D osmesa=true
-D platforms=x11,wayland
-D shared-glapi=enabled
-D valgrind=disabled
-D vulkan-layers=device-select,overlay,screenshot
"

termux_step_pre_configure() {
	case $TERMUX_ARCH in
		arm|aarch64) TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvulkan-drivers=swrast,freedreno,virtio -Dfreedreno-kmds=msm,kgsl,virtio,wsl";;
		*) TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvulkan-drivers=swrast";;
	esac
	export MESON_PACKAGE_CACHE_DIR="${TERMUX_PKG_SRCDIR}"
	export LLVM_CONFIG=$TERMUX_PREFIX/bin/llvm-config

	echo "${TERMUX_PKG_VERSION}.termux-glibc-${TERMUX_PKG_REVISION:=0}" > ${TERMUX_PKG_SRCDIR}/VERSION
	rm ${TERMUX_PKG_SRCDIR}/subprojects/lua.wrap
	#sed -i "s|\"/dev/|\"${TERMUX_PREFIX}/dev/|g" $(grep -s -r -l '"/dev/')
}
