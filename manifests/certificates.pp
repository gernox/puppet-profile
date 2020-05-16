# @summary
#   Manages certificates
#
# @param certificates
#
class profile::certificates (
  Hash $certificates = $profile::certificates,
) {
  $certificates.each |$k, $v| {
    profile::cert { $k:
      * => $v,
    }
  }
}
