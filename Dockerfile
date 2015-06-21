# This Dockerfile is merely used to generate binaries for direct use during
# buildpack runtime.

FROM heroku/cedar:14

ENV CABAL_INSTALL cabal install --disable-documentation -j
ENV PATH /root/.cabal/bin:$PATH

# Install Haskell and Cabal
RUN apt-get update && \
    apt-get -y install haskell-platform wget libncurses5-dev && \
    apt-get clean
RUN cabal update && ${CABAL_INSTALL} cabal-install

RUN mkdir -p /app/bin
ENV PATH /app/bin:$PATH

# Install wasp (for those that do not want to use spas)
ENV WARP_VERSION 3.1.0
RUN mkdir /tmp/warp \
    && cd /tmp/warp \
    && cabal sandbox init \
    && ${CABAL_INSTALL} wai-app-static-${WARP_VERSION} \
    && cp -v .cabal-sandbox/bin/* /app/bin/

# Install Elm
ADD install-elm.sh /usr/bin/
ENV ELM_VERSION master
RUN /usr/bin/install-elm.sh

# Install spas
ENV SPAS_VERSION 0.1.1.1
ENV SPAS_REPO "https://github.com/srid/spas.git"
RUN git clone ${SPAS_REPO} -b ${SPAS_VERSION} /tmp/spas
RUN cd /tmp/spas \
  && cabal sandbox init \
  && ${CABAL_INSTALL} \
  && cp .cabal-sandbox/bin/* /app/bin/

# Startup scripts for heroku
RUN mkdir -p /app/.profile.d /app/bin
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

# AWS cli
RUN apt-get -y install awscli

ADD upload-to-s3.sh /app/bin/
