# Additional environment setting for chroot

# Add /usr/sbin and /sbin to PATH if chroot command can't be found
if ! command -v chroot >/dev/null; then
    PATH="${PATH:-/usr/bin:/bin}:/usr/sbin:/sbin"
    export PATH
fi

# Set a list of command substitutions based on PATH variable
fakechroot_chroot_env_cmd_subst=""
for fakechroot_chroot_env_d in `echo $PATH | tr ':' ' '`; do
    fakechroot_chroot_env_cmd_subst="$fakechroot_chroot_env_cmd_subst
$fakechroot_chroot_env_d/chroot=${fakechroot_bindir:-@sbindir@}/chroot.fakechroot
$fakechroot_chroot_env_d/env=${fakechroot_bindir:-@bindir@}/env.fakechroot
$fakechroot_chroot_env_d/ischroot=/bin/true
$fakechroot_chroot_env_d/ldconfig=/bin/true
$fakechroot_chroot_env_d/ldd=${fakechroot_bindir:-@bindir@}/ldd.fakechroot"
done

FAKECHROOT_CMD_SUBST="${FAKECHROOT_CMD_SUBST:+$FAKECHROOT_CMD_SUBST:}`echo \"$fakechroot_chroot_env_cmd_subst\" | tr '\012' ':'`"
export FAKECHROOT_CMD_SUBST

# Set the default list of directories excluded from being chrooted
FAKECHROOT_EXCLUDE_PATH="${FAKECHROOT_EXCLUDE_PATH:-/dev:/proc:/sys}"
export FAKECHROOT_EXCLUDE_PATH
