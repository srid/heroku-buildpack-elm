#!/bin/bash

set -ex

mkdir /tmp/elm
cd /tmp/elm

cabal sandbox init

if [[ ${ELM_VERSION} == "0.15" ]]; then
    ${CABAL_INSTALL} elm-compiler-0.15 elm-package-0.5 elm-make-0.1.2
    ${CABAL_INSTALL} elm-repl-0.4.1 elm-reactor-0.3.1
else
    echo "ERROR: Unsupported Elm version ${ELM_VERSION}"
    exit 2
fi

cp .cabal-sandbox/bin/* /app/bin/

