FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
	python3 \
	python3-dev \
	python3-venv \
	qemu-utils \
	qemu-user-static \
	sudo \
	debootstrap \
	git \
	cpio \
	xz-utils \
	zstd \
	dosfstools \
	genisoimage

RUN mkdir /ipa_builder
WORKDIR /ipa_builder

# crearte and activate venv
RUN python3 -m venv /ipa_builder/.venv
ENV VIRTUAL_ENV="/ipa_builder/.venv"
ENV PATH="/ipa_builder/.venv/bin:$PATH"

RUN pip install --upgrade \
    pip \
    setuptools \
    wheel

RUN pip install \
    diskimage-builder \
    ironic-python-agent-builder


COPY dib /ipa_builder/dib

VOLUME /scratch
WORKDIR /scratch

ENV ELEMENTS_PATH="/ipa_builder/dib:/ipa_builder/.venv/share/ironic-python-agent-builder/dib"
ENTRYPOINT ["disk-image-create"]
