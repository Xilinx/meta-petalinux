# CentOS 7 / RHEL 7 hosts have a compiler/C++ library that is too old to
# build Chromium, and it's required configuration library.
#
# You must install at least the devtoolset-7 software collecton to build
# this component.
#
# Enable the software collection package repository on your host system:
# On CentOS, install the package centos-release-scl
# $ sudo yum install centos-release-scl
#
# On RHEL, enable the rhel-server-rhscl-7-rpms repository on your host:
# $ sudo yum-config-manager --enable rhel-server-rhscl-7-rpms
#
# Install the devtoolset-7 and required libatomic development library:
# $ sudo yum install devtoolset-7
# $ sudo yum install devtoolset-7-libatomic-devel
#
# Prior to using bitbake, devtool or petalinux, enable the devtoolset-7:
# $ scl enable devtoolset-7 bash
#
# Note: if you've previously built software prior to scl, you will
# need to remove the tmp/hosttools directory.

# This recipe requires the host to provide the "string_view" C++ header.
# gcc 7.x and newer contain the necessary version.
python() {
    import subprocess

    # Based on the code in lib/oe/utils.py:host_gcc_version
    # Following these steps ensure we're using the version of g++
    # that is referenced by TMPDIR/hosttools
    compiler = d.getVar('BUILD_CXX')
    # Get rid of ccache since it is not present when parsing.
    if compiler.startswith('ccache '):
        compiler = compiler[7:]
    try:
        env = os.environ.copy()
        env["PATH"] = d.getVar("PATH")
        output = subprocess.check_output('echo "#include <string_view>" | %s -E -x c++ -' % compiler, \
                    shell=True, env=env, stderr=subprocess.STDOUT).decode("utf-8")
        # We passed the check!
    except Exception as e:
        raise bb.parse.SkipRecipe("C++ header 'string_view' is required.  You need to install a newer libstdc++ on the host system.")
}
