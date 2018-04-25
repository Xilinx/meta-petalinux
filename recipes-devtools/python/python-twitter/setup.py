#!/usr/bin/env python

import os, re, sys
from codecs import open
from setuptools import setup, find_packages

requires = []
test_requirements = ['pytest>=2.8.0', 'pytest-httpbin==0.0.7', 'pytest-cov']

with open('tweepy/__init__.py', 'r') as fd:
	version = re.search(r'^__version__\s*=\s*[\'"]([^\'"]*)[\'"]',
			fd.read(), re.MULTILINE).group(1)

if not version:
	raise RuntimeError('Cannot find version information')

setup(name="tweepy",
      version=version,
      description="Twitter library for python",
      license="MIT",
      author="Joshua Roesslein",
      author_email="tweepy@googlegroups.com",
      url="http://github.com/tweepy/tweepy",
      packages=find_packages(exclude=['tests']),
	install_requires=requires,
      keywords="twitter library",
      classifiers=[
          'Development Status :: 4 - Beta',
          'Topic :: Software Development :: Libraries',
          'License :: OSI Approved :: MIT License',
          'Operating System :: OS Independent',
          'Programming Language :: Python',
          'Programming Language :: Python :: 2',
          'Programming Language :: Python :: 2.6',
          'Programming Language :: Python :: 2.7',
          'Programming Language :: Python :: 3',
          'Programming Language :: Python :: 3.3',
          'Programming Language :: Python :: 3.4',
      ],
      zip_safe=True)
