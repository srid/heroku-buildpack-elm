# This Dockerfile is merely used to generate binaries for direct use during
# buildpack runtime.

FROM heroku/cedar

# ENV PATH /root/.cabal/bin:$PATH
ENV PATH /app/bin:$PATH
RUN echo 'deb http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main '|tee /etc/apt/sources.list.d/haskell.list
RUN apt-get update
WORKDIR /tmp

# Install Haskell
ENV GHC_VERSION 7.10.3
ENV CABAL_VERSION 1.24
RUN apt-get install -y --force-yes ghc-${GHC_VERSION}
RUN apt-get install -y --force-yes cabal-install-${CABAL_VERSION}
ENV PATH /opt/ghc/${GHC_VERSION}/bin:/opt/cabal/${CABAL_VERSION}/bin:$PATH

# Install Elm
ENV ELM_VERSION 0.17
# Required for Elm to compile properly
ENV LANG en_US.utf8

RUN curl -LO https://raw.githubusercontent.com/elm-lang/elm-platform/master/installers/BuildFromSource.hs
RUN runhaskell BuildFromSource.hs ${ELM_VERSION}
RUN mkdir -p /app/.profile.d /app/bin
RUN cp Elm-Platform/${ELM_VERSION}/.cabal-sandbox/bin/* /app/bin/

# Startup scripts for heroku
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

# AWS upload script
RUN apt-get -y install python-pip
RUN pip install awscli
ADD upload-to-s3.sh /app/bin/
