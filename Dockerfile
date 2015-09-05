# This Dockerfile is merely used to generate binaries for direct use during
# buildpack runtime.

FROM heroku/cedar

ENV CABAL_INSTALL cabal install --disable-documentation -j
ENV PATH /root/.cabal/bin:$PATH

# Install Haskell and Cabal
RUN apt-get update && \
    apt-get -y install haskell-platform wget libncurses5-dev && \
    apt-get clean
RUN cabal update && ${CABAL_INSTALL} cabal-install

RUN mkdir -p /app/bin
ENV PATH /app/bin:$PATH

# Install Elm
ENV ELM_VERSION 0.15.1
RUN cd /tmp \
  && curl https://raw.githubusercontent.com/elm-lang/elm-platform/master/installers/BuildFromSource.hs > BuildFromSource.hs \
  && runhaskell BuildFromSource.hs ${ELM_VERSION} \
  && cp Elm-Platform/${ELM_VERSION}/bin/* /app/bin/

# Startup scripts for heroku
RUN mkdir -p /app/.profile.d /app/bin
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

# AWS cli
RUN apt-get -y install awscli

ADD upload-to-s3.sh /app/bin/
