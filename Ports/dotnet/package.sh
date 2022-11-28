#!/usr/bin/env -S bash ../.port_include.sh
port=dotnet
workdir=dotnet-runtime-serenity
version=git
files="https://github.com/jakewestrip/dotnet-runtime/archive/refs/heads/serenity.tar.gz dotnet-git.tar.gz"
depends=("libicu" "zlib" "openssl")

export ROOTFS_DIR=${SERENITY_SOURCE_DIR}

build() {
    host_env
    run ./build.sh mono+libs+host+packs -os serenity -cross -c Release -gcc -rf mono
}

install() {
    cd ${workdir}/artifacts/packages/Release/Shipping
    rm -rf zip
    mkdir zip
    cd zip
    cp ../*dev.nupkg .

    for file in *.nupkg
    do
        mv "$file" "${file%.nupkg}.zip"
        unzip -o "${file%.nupkg}.zip"
    done

    cd runtimes/linux-x64
    mkdir -p /home/int16/serenity/Build/x86_64/Root/usr/dotnet/lib
    cp -r lib/* -t /home/int16/serenity/Build/x86_64/Root/usr/dotnet/lib
    cp -r native/* -t /home/int16/serenity/Build/x86_64/Root/usr/dotnet/lib

    cd ../../../../../../obj/mono/SerenityOS.x64.Release/out/lib
    cp -r * -t /home/int16/serenity/Build/x86_64/Root/usr/dotnet/lib

    cd ..
    mkdir -p /home/int16/serenity/Build/x86_64/Root/usr/dotnet/bin
    cp bin/mono-sgen /home/int16/serenity/Build/x86_64/Root/usr/dotnet/bin/mono
    cp -r include -t /home/int16/serenity/Build/x86_64/Root/usr/dotnet
}