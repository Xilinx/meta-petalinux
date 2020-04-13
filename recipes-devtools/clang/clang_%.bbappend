python() {
    if d.getVar('TARGET_ARCH').startswith('microblaze'):
        raise bb.parse.SkipRecipe("Microblaze is not supported.")
}
