SUMMARY = "ASGI specs, helper code, and adapters"
DESCRIPTION = "ASGI is a standard for Python asynchronous web apps and servers to communicate with \
    each other, and positioned as an asynchronous successor to WSGI."
HOMEPAGE = "https://github.com/django/asgiref/"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;;md5=f09eb47206614a4954c51db8a94840fa"

SRC_URI[md5sum] = "ab971d5e7c4517c5c31d539022d529c9"
SRC_URI[sha256sum] = "7162a3cb30ab0609f1a4c95938fd73e8604f63bdba516a7f7d64b83ff09478f0"

PYPI_PACKAGE = "asgiref"
inherit pypi setuptools3
