FROM docker.io/zcloudws/meteor-build:3.0-alpha.6 as builder

WORKDIR /build/source
USER root

RUN chown zcloud:zcloud -R /build

USER zcloud:zcloud
COPY --chown=zcloud:zcloud . /build/source

ENV METEOR_DISABLE_OPTIMISTIC_CACHING=1

WORKDIR /build/source

RUN meteor npm --no-audit install
RUN meteor build --directory ../app-build

FROM zcloudws/meteor-node-mongodb-runtime:3.0-alpha.6
COPY --from=builder /build/app-build/bundle /home/zcloud/app

RUN cd /home/zcloud/app/programs/server && npm --no-audit install

WORKDIR /home/zcloud/app

ENV NO_NPM_INSTALL=1

ENTRYPOINT ["/scripts/startup.sh"]

