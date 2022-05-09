import shutil
import logging
import argparse
import json
import re
import os
import subprocess
from oeqa.utils.commands import runCmd, bitbake, get_bb_var, get_bb_vars

logger = logging.getLogger('devtool')

header = '# PetaLinux Auto generated Kconfig file'
kconfig_string = '''
config {0}
    bool "{1}"
    help
        Yocto version: {2}
        {3}
'''
kconfig_exthelp = '''        {0}
'''
kconfig_select = '''    select {0}
'''
kmenu_start = '''
menu "{0}"'''
kmenu_end = '''
endmenu'''

# Get the package after from this line from bitbake -s command
matched_str = "========"

# Defining dictionary elements
packages_dict = { 
    'Libraries' : {},
    'Package Groups' : {},
    'Package Groups Petalinux' : {},
    'Filesystem Packages' : {}
}

# Write to file
def write_file(string):
    with open(kconfig_outfile, 'a') as kconfig_outfile_f:
        kconfig_outfile_f.write(string)
    kconfig_outfile_f.close()

# Run the sanity for Kconfig file
def sanity_test():
    mconf_provides = "kconfig-frontends-native"
    logger.info('Running: bitbake %s' % mconf_provides)
    subprocess.check_call(["bitbake", mconf_provides])
    bb_vars = get_bb_vars(['SYSROOT_DESTDIR', 'STAGING_BINDIR_NATIVE', 'NATIVE_PACKAGE_PATH_SUFFIX'], mconf_provides) or ''
    sysroot_destdir = bb_vars['SYSROOT_DESTDIR'] or ''
    staging_bindir_native = bb_vars['STAGING_BINDIR_NATIVE'] or ''
    native_package_path_suffix = bb_vars['NATIVE_PACKAGE_PATH_SUFFIX'] or ''
    conf_path = '%s%s%s/conf' % (sysroot_destdir,staging_bindir_native,native_package_path_suffix)
    conf_cmd = '%s %s --alldefconfig' % (conf_path,kconfig_outfile)
    logger.info(conf_cmd)
    result = runCmd(conf_cmd)
    if not result.status ==  0:
        logger.error('Sanity Command failed with status: %s', result.status)
    else:
        logger.info("Sanity Command Passed with status: %s", result.status)

# Take the directory backup
def rename_dir(src_dir,dst_dir):
    if os.path.exists(src_dir):
        logger.info('Renaming %s Directory to %s' % (src_dir,dst_dir))
        shutil.move(src_dir,dst_dir)

# Format the Kconfig string and pass to write_file function
def kconfig_recipe_format(recipe_name, version, description, rdepends, packages):
    # Add start menu
    write_file(kmenu_start.format(recipe_name))

    # Add config options and replace '+' to 'PLUS'
    recipe_name = recipe_name.replace('+','PLUS')
    write_file(kconfig_string.format(recipe_name, \
                recipe_name, version, description))

    if rdepends:
        write_file(kconfig_exthelp.format("Following packages will be enabled:"))
        # Add rdepend to help section
        for rdepend in rdepends:
            rdepend = rdepend.replace('+','PLUS')
            if rdepend.startswith('${'):
                logger.warn('Skipping RDEPEND: %s for recipe "%s"' % (rdepend,recipe_name))
                continue
            elif rdepend:
                write_file(kconfig_exthelp.format(rdepend))

        # Add rdepend to select when recipe selected if --map-rdepends provided
        if map_rdepends:
            for rdepend in rdepends:
                rdepend = rdepend.replace('+','PLUS')
                if rdepend.startswith('${'):
                    continue
                elif rdepend and not rdepend.startswith('${'):
                    write_file(kconfig_select.format(rdepend))
 
    # Add config option for packages and replace '+' to 'PLUS'
    for package in packages:
        if package.startswith('${'):
            logger.warn('Skipping PACKAGE: %s for recipe "%s"' % (package,recipe_name))
        elif package and package != recipe_name:
            write_file(kconfig_string.format(package.replace('+','PLUS'),package,version,''))

    write_file(kmenu_end)

def get_exclude_pkgs(exclude_pkgs_file):
    with open(exclude_pkgs_file, 'r') as exclude_pkgs_file_f:
        exclude_pkgs = json.load(exclude_pkgs_file_f)
    exclude_pkgs_file_f.close()
    matched_recipes = ""
    full_recipes = ""
    if 'matched-recipe-files' in exclude_pkgs.keys():
        matched_recipes = exclude_pkgs['matched-recipe-files']
    if 'full-recipe-files' in exclude_pkgs.keys():
        full_recipes = exclude_pkgs['full-recipe-files']
    return matched_recipes,full_recipes

def plnxkconfig(args, config, basepath, workspace):

    global kconfig_outfile, map_rdepends
    kconfig_outfile = args.output
    map_rdepends = args.map_rdepends
    run_sanity = args.sanity
    exclude_pkgs_file = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'exclude_pkgs.json')
    pnlist_file = basepath + '/pnlist.json'

    # Remove kconfig output file if exists
    if os.path.exists(kconfig_outfile):
        os.remove(kconfig_outfile)
    # Remove pn-file.json
    if os.path.exists(pnlist_file):
        os.remove(pnlist_file)
    # Rename cache and tmp dir to generate pnlist.json with full recipes list
    rename_dir(basepath + '/cache',basepath + '/cache_back')
    rename_dir(basepath + '/tmp',basepath + '/tmp_back')

    # Include plnx-parse-recipes.bbclass into .conf file
    class_name = 'plnx-parse-recipes'
    postconfig = 'INHERIT:append = " %s"' % (class_name)
    logger.info('Running: bitbake -s')
    allrecipes = bitbake('-s', postconfig=postconfig)

    # Rename back old cache and tmp dir
    rename_dir(basepath + '/cache_back',basepath + '/cache')
    rename_dir(basepath + '/tmp_back',basepath + '/tmp')

    # Get the index for recipe names starting
    index = allrecipes.output.rfind(matched_str) + len(matched_str)

    # Parse the pnlist file and convert to json objects
    if os.path.exists(pnlist_file):
        with open(pnlist_file, 'r', encoding='utf-8') as file:
            pnlist = file.readlines()
        file.close()
        pnlist_str = '\n'.join(pnlist).strip().rstrip(',')
        pnlist_str = '{\n' + pnlist_str + '\n}\n'
    else:
        logger.error('PN files list file doesnot exists: %s' % pnlist_file)
        return -1
    pnlist_json = json.loads(pnlist_str)

    # Get exclude packages from json file
    matched_recipes,full_recipes = get_exclude_pkgs(exclude_pkgs_file)
    logger.warn('Skipping recipes matches suffix/prefix with %s' % matched_recipes)
    logger.warn('Skipping recipes exact matches with %s' % full_recipes)

    # Itirate each line and get the description,rdepends and packages from pnlist file
    # and store them in packages_dict variable
    count = 1
    for line in allrecipes.output[index:].splitlines():
        recipe_name = line.split(' ')[0].strip()
        if recipe_name:
            if any(re.search(mrecipe,recipe_name) for mrecipe in matched_recipes) or \
                    any(re.fullmatch(frecipe,recipe_name) for frecipe in full_recipes):
                continue
            version = line.split(':')[1].strip()
            description = ''
            rdepends = ''
            if recipe_name in pnlist_json.keys():
                description = pnlist_json[recipe_name]['description']
                rdepends = pnlist_json[recipe_name]['rdepends']
                packages = pnlist_json[recipe_name]['packages']
            else:
                logger.warn('Recipe %s Not found in %s' % (recipe_name,pnlist_file))

            if 'lib' in recipe_name and not recipe_name.startswith('packagegroup-'):
                packages_dict['Libraries'][recipe_name] = [ version, description, rdepends, packages ]
            elif recipe_name.startswith('packagegroup-') and not recipe_name.startswith('packagegroup-petalinux-'):
                packages_dict['Package Groups'][recipe_name] = [ version, description, rdepends, packages ]
            elif recipe_name.startswith('packagegroup-petalinux-'):
                packages_dict['Package Groups Petalinux'][recipe_name] = [ version, description, rdepends, packages ]
            else:
                packages_dict['Filesystem Packages'][recipe_name] = [ version, description, rdepends, packages ]
            count = count + 1
    logger.info("Total %s Packages found" % count)
    # Create menu entry for each recipe
    write_file(header)
    for key in packages_dict.keys():
        write_file(kmenu_start.format(key))
        for recipe in packages_dict[key].keys():
            version = packages_dict[key][recipe][0]
            description = packages_dict[key][recipe][1]
            rdepends = packages_dict[key][recipe][2]
            packages = packages_dict[key][recipe][3]
            kconfig_recipe_format(recipe,version, description, rdepends, packages)
        write_file(kmenu_end + '\n')

    logger.info('Created file: %s' % kconfig_outfile)
    if run_sanity:
        sanity_test()

def register_commands(subparsers, context):
    """Register devtool subcommands from this plugin"""
    parser_systest = subparsers.add_parser('gen-plnx-kconfig', help='Generate the petalinux rootfs configs ',
                        description='Generate the Kconfig file for all the recipes compatible to MACHINE with static DESCRIPTION/RDEPENDS/PACKAGES variables defined in recipe files. Example command: MACHINE=zynqmp-generic devtool gen-plnx-kconfig')
    parser_systest.add_argument('-o','--output', help='Output Kconfig file name',default='Kconfig')
    parser_systest.add_argument('-r','--map-rdepends', help='Select the rdepends when corresponding recipe enabled',action='store_true')
    parser_systest.add_argument('-s','--sanity', help='Run basic sanity for the generated Kconfig file',action='store_true')
    parser_systest.set_defaults(func=plnxkconfig, no_workspace=True)
