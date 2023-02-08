#!/usr/bin/env bash

# See the README.md for details of how this script works

set -euo pipefail
IFS=$'\n\t'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

generate() {
  awk '
    BEGIN {
      print "# DO NOT MANUALLY EDIT; Run ./scripts/update-asdf-version-variables.sh to update this";
      print "variables:"
    }
    /^[^# ]/ {
      if ($1 != "" && $2 != "system") {
        gsub("-", "_", $1);
        print "  GL_ASDF_" toupper($1) "_VERSION: \"" $2 "\""
      }
    }
    ' "${ROOT_DIR}/.tool-versions"
}

generate >"${ROOT_DIR}/.gitlab-ci-asdf-versions.yml"
