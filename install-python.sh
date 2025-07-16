#!/bin/sh

set -eu

fuzzy_eq() {
    local input="$1"
    local pattern="$2"

    echo "${input}" | grep -i "${pattern}" > /dev/null
    return "$?"
}


ARCH="$(uname -m)"
if fuzzy_eq "${ARCH}" "arm64" || fuzzy_eq "${ARCH}" "aarch64"; then
    echo "aarch64 is currently not supported" >&2
    exit 1
elif fuzzy_eq "${ARCH}" "x86_64" || fuzzy_eq "${ARCH}" "x86-64"; then
    ARCH="x86_64"
else
    echo "Unknown architecture ${ARCH}" >&2
    exit 1
fi

OS="$(uname -o)"
if fuzzy_eq "${OS}" "linux"; then
    OS="linux"
elif fuzzy_eq "${OS}" "darwin"; then
    echo "Darwin is currently not supported" >&2
    exit 1
else
    echo "Unknown operating system ${OS}" >&2
    exit 1
fi

if python --version > /dev/null 2>&1; then
    # try python first because it is set to that is set in python environments.
    PY=python
elif python3 --version > /dev/null 2>&1; then
    # only if that is not available use python3 which is, e.g., on fedora the system-wide one.
    PY=python3
else
    echo "Error: no Python 3 interpreter found (tried 'python' and 'python3')" >&2
    exit 1
fi

if ! $PY -m pip --version > /dev/null 2>&1; then
    echo "pip module is missing. Installing it." >&2
    $PY -m ensurepip --upgrade
fi

REPO="https://github.com/tentris/tentris"
LATEST_RELEASE_PAGE="$(curl --proto https --tlsv1.2 -Ls -o /dev/null -w "%{url_effective}" "${REPO}/releases/latest")"
LATEST_RELEASE_VER="${LATEST_RELEASE_PAGE##*/}"

DOWNLOAD_URL="${REPO}/releases/download/${LATEST_RELEASE_VER}/tentris-python-${LATEST_RELEASE_VER}-beta-${ARCH}-${OS}.tar.gz"

$PY -m pip install "$DOWNLOAD_URL"
