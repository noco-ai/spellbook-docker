FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y git build-essential \
    python3 python3-pip gcc tar wget \
    ocl-icd-opencl-dev opencl-headers clinfo \
    libclblast-dev libopenblas-dev \
    && mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

COPY . .
ENV CUDA_DOCKER_ARCH=all
ENV LLAMA_CUBLAS=1
RUN groupadd -r golem && useradd -r -m -g golem golem && mkdir /server && chown -R golem:golem /server
RUN python3 -m pip install --upgrade pip pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings starlette-context
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python
RUN echo "Installing v0.1.0 of Elemental Golem"
RUN git clone https://github.com/noco-ai/elemental-golem.git /server
RUN pip install -r /server/requirements.txt
RUN mkdir -p /server/data/loras/
WORKDIR /server
CMD ["python3", "server.py", "--server-id", "golem1", "--vault-host", 
    "http://10.23.82.2:8200", "--vault-token-file", "/vault_share/read-token", "--vault-root", "spellbook", "--shared-models", "true"]
# CMD tail -f /dev/null
# python3 server.py --server-id golem1 --vault-host http://10.23.82.2:8200 --vault-token-file /vault_share/read-token --vault-root spellbook --shared-models true
