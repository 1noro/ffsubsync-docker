# FROM debian:bookworm
FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        ffmpeg \
        python3-full \
        python3-dev \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # test \
    ffmpeg -version && python3 --version && pip3 --version

RUN python3 -m venv /pyvenv1 && \
    source /pyvenv1/bin/activate && \
    /pyvenv1/bin/pip install --upgrade setuptools && \
    /pyvenv1/bin/pip install ffsubsync && \
    ffs --version

# RUN pip install ffsubsync

RUN mkdir -p /result && \
    chmod 777 /result

# ENTRYPOINT [ "bash" ]
# CMD ["/bin/bash -c source /pyvenv1/bin/activate && ffs"]
