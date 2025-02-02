#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail


dir="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"


printf '\u2714 Installing "%s"\n' "victoria-logs"
$dir/victoria-logs/setup.sh

printf '\n\u2714 Installing "%s"\n' "otel-collector"
$dir/otel-collector/setup.sh

printf '\n\u2714 Installing "%s"\n' "fluent-bit"
$dir/fluent-bit/setup.sh