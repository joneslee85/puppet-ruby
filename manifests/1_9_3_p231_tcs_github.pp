# Installs ruby 1.9.3-p231-tcs-github blessed version from rbenv.
#
# Usage:
#
#     include ruby::1_9_3_p231_tcs_github

class ruby::1_9_3_p231_tcs_github {
  ruby::version { '1.9.3-p231-tcs-github': }
}
