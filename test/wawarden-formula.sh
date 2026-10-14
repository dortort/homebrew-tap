#!/bin/sh
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
generator=$root/script/wawarden-formula
fixtures=$root/test/fixtures
sums=$fixtures/v1.2.3.SHA256SUMS
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

refuses() {
  message=$1
  shift
  if "$generator" "$@" > "$work/stdout" 2> "$work/stderr"; then
    fail "the generator accepted: $*"
  fi
  [ ! -s "$work/stdout" ] || fail "the generator printed a formula for: $*"
  grep -qF -- "$message" "$work/stderr" || fail "the generator did not report '$message' for: $*"
}

mkdir "$work/Formula"
formula=$work/Formula/wawarden.rb
"$generator" 1.2.3 "$sums" > "$formula"
diff -u "$fixtures/wawarden-1.2.3.rb" "$formula" || fail "the formula differs from test/fixtures/wawarden-1.2.3.rb"
"$generator" v1.2.3 "$sums" | diff -u "$formula" - || fail "a leading v changes the formula"
ruby -c "$formula" > /dev/null || fail "ruby -c rejects the formula"
brew style "$formula" || fail "brew style rejects the formula"

sed 's/  / */' "$sums" > "$work/binary-mode"
"$generator" 1.2.3 "$work/binary-mode" | diff -u "$formula" - || fail "binary-mode checksum lines change the formula"
awk '{ print; print "0" substr($1, 2) "  " $2 ".spdx.json" }' "$sums" > "$work/similar-names"
"$generator" 1.2.3 "$work/similar-names" | diff -u "$formula" - || fail "similar asset names change the formula"

grep -v '_linux_arm64$' "$sums" > "$work/no-linux-arm64"
sed 's/^\([0-9a-f]*\)  \(wawarden_v1.2.3_darwin_amd64\)$/\1\1  \2/' "$sums" > "$work/long-hash"
grep '_darwin_arm64$' "$sums" | sed 's/^[0-9a-f]/0/' | cat "$sums" - > "$work/duplicate"
awk '$2 ~ /_linux_amd64$/ { $1 = toupper($1) } { print $1 "  " $2 }' "$sums" > "$work/uppercase"

refuses "wawarden_v1.0.0_darwin_arm64 wawarden_v1.0.0_darwin_amd64" 1.0.0 "$fixtures/v1.0.0.SHA256SUMS"
refuses "wawarden_v1.2.3_linux_arm64" 1.2.3 "$work/no-linux-arm64"
refuses "wawarden_v1.2.3_darwin_amd64" 1.2.3 "$work/long-hash"
refuses "wawarden_v1.2.3_darwin_arm64" 1.2.3 "$work/duplicate"
refuses "wawarden_v1.2.3_linux_amd64" 1.2.3 "$work/uppercase"
refuses "wawarden_v1.2.4_darwin_arm64 wawarden_v1.2.4_darwin_amd64 wawarden_v1.2.4_linux_arm64 wawarden_v1.2.4_linux_amd64" 1.2.4 "$sums"
refuses "version must be MAJOR.MINOR.PATCH" 1.2 "$sums"
refuses "version must be MAJOR.MINOR.PATCH" 01.2.3 "$sums"
refuses "cannot read" 1.2.3 "$work/absent"
refuses "usage" 1.2.3

printf 'ok: the generator writes the expected formula and refuses incomplete checksums\n'
