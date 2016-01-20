# This Dockerfile is merely used to generate binaries for direct use during
# buildpack runtime.

FROM heroku/cedar

ENV CABAL_INSTALL cabal install --disable-documentation -j
ENV PATH /root/.cabal/bin:$PATH

# Install Haskell and Cabal
RUN apt-get update && \
    apt-get -y install haskell-platform wget libncurses5-dev && \
    apt-get clean

WORKDIR /tmp

# Download and install newer, Elm 0.16-compatible Haskell Platform
RUN wget "https://haskell.org/platform/download/7.10.3/haskell-platform-7.10.3-unknown-posix-x86_64.tar.gz"
RUN tar xfz "./haskell-platform-7.10.3-unknown-posix-x86_64.tar.gz"
RUN "./install-haskell-platform.sh"

RUN cabal update && ${CABAL_INSTALL} cabal-install

RUN mkdir -p /app/bin
ENV PATH /app/bin:$PATH
# Required for Elm to compile properly
ENV LANG en_US.utf8

# Install Elm
ENV ELM_VERSION 0.16

RUN curl https://raw.githubusercontent.com/elm-lang/elm-platform/master/installers/BuildFromSource.hs > BuildFromSource.hs
RUN runhaskell BuildFromSource.hs ${ELM_VERSION}
RUN cp Elm-Platform/${ELM_VERSION}/.cabal-sandbox/bin/* /app/bin/

# Startup scripts for heroku
RUN mkdir -p /app/.profile.d /app/bin
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

# AWS cli
RUN apt-get -y install awscli

ADD upload-to-s3.sh /app/bin/
