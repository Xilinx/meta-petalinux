# Adjust the requires.txt file to match the system configured versions
do_install_append() {
  (
    cd ${D}${PYTHON_SITEPACKAGES_DIR}/docker_compose-${PV}-py${PYTHON_BASEVERSION}.egg-info/
    sed -i "s+PyYAML<4,+PyYAML+g" requires.txt
    sed -i "s+jsonschema<3,+jsonschema+g" requires.txt
    sed -i "s+requests!=2.11.0,!=2.12.2,!=2.18.0,<2.20,+requests!=2.11.0,!=2.12.2,!=2.18.0,+g" requires.txt
  )
}

RDEPENDS_${PN} += "python3-fcntl"
