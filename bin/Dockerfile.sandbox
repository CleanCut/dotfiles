FROM docker/sandbox-templates:copilot

USER root

RUN apt-get update && apt-get install -y curl rustup build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN rustup install stable

# Install common tools
RUN cargo install ripgrep

USER agent
