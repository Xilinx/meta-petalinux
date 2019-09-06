#*******************************************************************************
#
# Copyright (C) 2019 Xilinx, Inc.  All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.
#
# Author: chandana kalluri <ckalluri@xilinx.com>
#
# ******************************************************************************

"""Devtool configure plugin"""

import os
import bb
import logging
import argparse
import re
import glob
from devtool import setup_tinfoil, parse_recipe, DevtoolError, standard, exec_build_env_command

logger = logging.getLogger('devtool')

def configure(args, config, basepath, workspace):
    """Entry point for the devtool 'configure' subcommand"""

    if args.component not in workspace:
           raise DevtoolError("recipe %s is not in your workspace, run devtool modify command first" % args.component)

    rd = "" 
    tinfoil = setup_tinfoil(basepath=basepath)
    try:
      rd = parse_recipe(config, tinfoil, args.component, appends=True, filter_workspace=False)
      if not rd:
         return 1

      pn =  rd.getVar('PN', True)
      if pn not in workspace:
         raise DevtoolError("Run devtool modify before calling configure for %s" %pn)

    finally:
      tinfoil.shutdown()

    exec_build_env_command(config.init_path, basepath, 'bitbake -c configure %s' % pn, watch=True) 

    return 0

def register_commands(subparsers, context):
    """register devtool subcommands from this plugin"""
    parser_configure = subparsers.add_parser('configure',help='runs configure command', description='runs configure for a specific package', group='advanced') 
    parser_configure.add_argument('component', help='compenent to alter config')
    parser_configure.set_defaults(func=configure,fixed_setup=context.fixed_setup)
