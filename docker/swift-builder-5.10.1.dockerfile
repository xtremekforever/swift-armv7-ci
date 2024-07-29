FROM swift:5.10.1-jammy

COPY install-dependencies.sh .
RUN ./install-dependencies.sh && rm *.sh

ARG USER=builduser
ARG UID=1000
RUN useradd ${USER} -u ${UID}
