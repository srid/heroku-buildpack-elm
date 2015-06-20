#!/bin/bash

set -ex

mkdir /tmp/elm
cd /tmp/elm

cabal sandbox init

if [[ ${ELM_VERSION} == "0.15" ]]; then
    # Elm 0.15, per http://elm-lang.org/Install.elm
    ${CABAL_INSTALL} elm-compiler-0.15 elm-package-0.5 elm-make-0.1.2
    ${CABAL_INSTALL} elm-repl-0.4.1 elm-reactor-0.3.1
    cp -v .cabal-sandbox/bin/* /app/bin/
elif [[ ${ELM_VERSION} == "master" ]]; then
    wget -q https://raw.githubusercontent.com/elm-lang/elm-platform/master/installers/BuildFromSource.hs
    runhaskell BuildFromSource.hs master
    cp -v Elm-Platform/master/bin/* /app/bin/
else
    echo "ERROR: Unsupported Elm version ${ELM_VERSION}"
    exit 2
fi


