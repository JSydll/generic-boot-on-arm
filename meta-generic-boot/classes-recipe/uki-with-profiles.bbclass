# Extends the uki.bbclass with the ability to create additional profiles and merge them into the main UKI.
#
# Usage:
#   UKI_PROFILES = "my-profile-1 my-profile-2 ..."
#
#   UKI_PROFILE_my-profile-1[name] = "uki-profile-1"
#   UKI_PROFILE_my-profile-1[description] = "TITLE=A profile with a specific kernel cmdline ID=bootp-1"
#   UKI_PROFILE_my-profile-1[options] = " --cmdline='root=PARTUUID=AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEE rootfstype=ext4 rootwait' "
#
#   etc
#
# For available options and the syntax for the description, see https://www.freedesktop.org/software/systemd/man/latest/ukify.html#Examples
# and example 6 in particular.

inherit uki

UKI_PROFILES[doc] = ""
UKI_PROFILES ?= ""

UKIFY_BASE_CMD = "ukify build"
# As tasks are executed independently from each other, the new ukify command needs to be set on recipe level:
UKIFY_CMD = "${UKIFY_BASE_CMD} \
    ${@ ''.join([' --join-profile=%s/%s.efi' % (d.getVar('DEPLOY_DIR_IMAGE'), d.getVarFlag('UKI_PROFILE_%s' % profile, 'name') or profile) \
        for profile in d.getVar('UKI_PROFILES').split(' ')])}"

python do_uki_profiles() {
    import bb.process

    profiles = d.getVar('UKI_PROFILES')
    if not profiles:
        return

    target_arch = d.getVar('EFI_ARCH')
    deploy_dir_image = d.getVar('DEPLOY_DIR_IMAGE')
    build_cmd = "%s --efi-arch %s --stub='%s/addon%s.efi.stub'" % (d.getVar('UKIFY_BASE_CMD'), target_arch, deploy_dir_image, target_arch)

    for profile in profiles.split(' '):
        bb.debug(2, "Creating UKI profile '%s'..." % (profile))
        name = d.getVarFlag('UKI_PROFILE_%s' % profile, 'name') or profile
        description = d.getVarFlag('UKI_PROFILE_%s' % profile, 'description')
        options = d.getVarFlag('UKI_PROFILE_%s' % profile, 'options')
        if not description:
            bb.error("Missing required varflag on UKI_PROFILE_%s!" % (profile))

        cmd =  "%s --profile='%s' %s --output='%s/%s.efi'" % (build_cmd, description, options, deploy_dir_image, name)
        out, err = bb.process.run(cmd, shell=True)
        bb.debug(2, "%s\n%s" % (out, err))
    
    bb.debug(2, "ukify base command to generate UKI with set to: '%s'" % (d.getVar('UKIFY_CMD')))
}
addtask uki_profiles after do_rootfs before do_uki