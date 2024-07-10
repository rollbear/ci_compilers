#!/usr/bin/env bash
set -eou pipefail

export CURRENT_VERSION="$(ldd --version | head -n 1 | sed 's/^.* \([0-9].*\)$/\1/')"
MIN_VERSION=2.28

function greater_version() {
  echo -e "$1\n$2" | sort -Vr | head -n 1
}
if [ "$(greater_version $MIN_VERSION $CURRENT_VERSION)" == "${CURRENT_VERSION}" ]
then
  exit 0
fi
apt install -y --no-install-recommends gawk bison texinfo g++
git clone -b glibc-${MIN_VERSION} --depth=1 git://sourceware.org/git/glibc
lscpu
mkdir glibc/build
pushd glibc/build
../configure --disable-sanity-checks  --prefix=/opt/glibc

make -j 4
make  install
popd
if [ -e /usr/include/xlocale.h ]
then
  rm /usr/include/xlocale.h
  ln -s /usr/include/locale.h /usr/include/xlocale.h
fi

echo /opt/glibc/lib >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf

rm -rf glibc
apt remove -y gawk bison texinfo g++
apt autoremove -y
