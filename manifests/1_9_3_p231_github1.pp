# Installs ruby 1.9.3-p231-github1 via ruby-build.
#
# Usage:
#
#     include ruby::1_9_3_p231_github1

class ruby::1_9_3_p231_github1 {
  ruby::definition { '1.9.3-p231-github1': }
  ruby::version    { '1.9.3-p231-github1': }
}
