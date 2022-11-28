ARG release=16.04

FROM ubuntu:$release as builder

ARG llvm=6.0
ARG threads=4

ENV DEBIAN_FRONTEND noninteractive
ENV CI 1 # skip CUDA tests

RUN apt-get update -qq && \
    apt-get install -qq build-essential cmake git llvm-$llvm-dev libclang-$llvm-dev clang-$llvm libedit-dev libncurses5-dev zlib1g-dev libpfm4-dev
COPY . /terra

RUN cd /terra/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/install .. && \
    make install -j$threads
RUN clang++-6.0 /terra/mayhem/fuzz_treadnumber.cpp -fsanitize=fuzzer,address -I /terra/src/ -L /install/lib/ -lterra -o /fuzz

FROM ubuntu:$release as package
RUN apt-get update -qq && \
    apt-get install -qq libedit-dev libffi-dev libtinfo-dev
COPY --from=builder /install /install
COPY --from=builder /fuzz /fuzz_treadnumber
ENV LD_LIBRARY_PATH=/install/lib
