FROM openjdk:slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
  && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
