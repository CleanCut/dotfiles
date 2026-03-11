FROM docker/sandbox-templates:claude-code

USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    cmake \
    curl \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libclang-dev \
    libjpeg-turbo-progs \
    libssl-dev \
    mold\
    openssl \
    pkg-config \
    rustup \
    && rm -rf /var/lib/apt/lists/*



RUN rustup install stable

# Install common tools
RUN cargo install ripgrep
RUN cargo install fd-find

USER agent
