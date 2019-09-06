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
# ******************************************************************************

import os
import subprocess
import logging
import glob
import shutil
import errno
import sys
import tempfile
import re
from devtool import exec_build_env_command, setup_tinfoil, parse_recipe, DevtoolError

logger = logging.getLogger('devtool')

def plnx_sdk_update(args, config, basepath, workspace):
    """Entry point for devtool plnx-sdk-update command"""
    updateserver = ''.join(args.updateserver)
    if not updateserver:
        updateserver = config.get('SDK', 'updateserver', '')
    logger.debug("updateserver: %s" % updateserver)

    sys.path.insert(0, os.path.join(basepath, 'layers/core/scripts/lib/devtool'))
    from sdk import check_manifest, generate_update_dict, get_sstate_objects, install_sstate_objects

    # Make sure we are using sdk-update from within SDK
    logger.debug("basepath = %s" % basepath)
    old_locked_sig_file_path = os.path.join(basepath, 'conf/locked-sigs.inc')
    if not os.path.exists(old_locked_sig_file_path):
        logger.error("Not using devtool's sdk-update command from within an extensible SDK. Please specify correct basepath via --basepath option")
        return -1
    else:
        logger.debug("Found conf/locked-sigs.inc in %s" % basepath)

    layers_dir = os.path.join(basepath, 'layers')
    conf_dir = os.path.join(basepath, 'conf')

    # Fetch manifest from server
    tmpmanifest = os.path.join(updateserver, 'conf/sdk-conf-manifest')
    changedfiles = check_manifest(tmpmanifest, basepath)
    if not changedfiles:
        logger.info("Already up-to-date")
        return 0

    #fetch sstate-cache
    new_locked_sig_file_path = os.path.join(updateserver, 'conf/locked-sigs.inc')
    if not os.path.exists(new_locked_sig_file_path):
        logger.error("%s doesn't exist or is not an extensible SDK" % updateserver)
        return -1
    else:
        logger.debug("Found conf/locked-sigs.inc in %s" % updateserver)
    update_dict = generate_update_dict(new_locked_sig_file_path, old_locked_sig_file_path)
    logger.debug("update_dict = %s" % update_dict)
    newsdk_path = updateserver
    sstate_dir = os.path.join(newsdk_path, 'sstate-cache')
    if not os.path.exists(sstate_dir):
        logger.error("sstate-cache directory not found under %s" % newsdk_path)
        return 1
    sstate_objects = get_sstate_objects(update_dict, sstate_dir)
    logger.debug("sstate_objects = %s" % sstate_objects)
    if len(sstate_objects) == 0:
        logger.info("No need to update.")

    logger.info("Installing sstate objects into %s", basepath)
    install_sstate_objects(sstate_objects, updateserver.rstrip('/'), basepath)

    # Check if UNINATIVE_CHECKSUM changed
    uninative = False
    if 'conf/local.conf' in changedfiles:
        def read_uninative_checksums(fn):
            chksumitems = []
            with open(fn, 'r') as f:
                for line in f:
                    if line.startswith('UNINATIVE_CHECKSUM'):
                        splitline = re.split(r'[\[\]"\']', line)
                        if len(splitline) > 3:
                            chksumitems.append((splitline[1], splitline[3]))
            return chksumitems

        oldsums = read_uninative_checksums(os.path.join(basepath, 'conf/local.conf'))
        newsums = read_uninative_checksums(os.path.join(updateserver, 'conf/local.conf'))
        if oldsums != newsums:
            uninative = True

    if uninative:
        shutil.rmtree(os.path.join(basepath, 'downloads', 'uninative'))
        shutil.move(os.path.join(updateserver, 'downloads', 'uninative'), os.path.join(basepath, 'downloads'))

    logger.info("Updating configuration files")
    new_conf_dir = os.path.join(updateserver, 'conf')
    shutil.rmtree(conf_dir)
    shutil.copytree(new_conf_dir, conf_dir)

    logger.info("Updating layers")
    new_layers_dir = os.path.join(updateserver, 'layers')
    shutil.rmtree(layers_dir)
    ret = subprocess.call("cp -a %s %s" % (new_layers_dir, layers_dir), shell=True)
    if ret != 0:
        logger.error("Copying %s to %s failed" % (new_layers_dir, layers_dir))
        return ret

def register_commands(subparsers, context):
    """Register devtool subcommands from the sdk plugin"""
    if context.fixed_setup:
        parser_plnx_sdk_update = subparsers.add_parser('plnx-sdk-update',
                                           help='Update file based SDK components',
                                           description='Updates installed SDK components from a local file path',
                                           group='sdk')
        updateserver = context.config.get('SDK', 'updateserver', '')
        parser_plnx_sdk_update.add_argument('updateserver', help='The update server to fetch latest SDK components from (default %s)' % updateserver, nargs='+')
        parser_plnx_sdk_update.add_argument('--skip-prepare', action="store_true", help='Skip re-preparing the build system after updating (for debugging only)')
        parser_plnx_sdk_update.set_defaults(func=plnx_sdk_update)
