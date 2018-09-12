# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "COINMumpsBuilder"
version = v"1.6.0"

# Collection of sources required to build COINMumpsBuilder
sources = [
    "https://github.com/coin-or-tools/ThirdParty-Mumps/archive/releases/1.6.0.tar.gz" =>
    "3f2bb7d13333e85a29cd2dadc78a38bbf469bc3920c4c0933a90b7d8b8dc798a",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd $WORKSPACE/srcdir
cd ThirdParty-Mumps-releases-1.6.0/
./get.Mumps 
update_configure_scripts
mkdir build
cd build/
../configure --prefix=$prefix --with-pic --disable-pkg-config --with-blas="$prefix/lib/libcoinblas.a -lgfortran" --host=${target} --enable-shared --enable-static --enable-dependency-linking lt_cv_deplibs_check_method=pass_all --with-metis-lib="-L${prefix}/lib -lcoinmetis" --with-metis-incdir="$prefix/include/coin/ThirdParty" 
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcoinmumps", :libcoinmumps)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/juan-pablo-vielma/COINMetisBuilder/releases/download/v1.3.5/build_COINMetisBuilder.v1.3.5.jl",
    "https://github.com/juan-pablo-vielma/COINBLASBuilder/releases/download/v1.4.6/build_COINBLASBuilder.v1.4.6.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

