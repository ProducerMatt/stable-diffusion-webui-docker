# syntax=docker/dockerfile:1

FROM alpine/git:2.36.2 as download

SHELL ["/bin/sh", "-ceuxo", "pipefail"]

RUN git clone https://github.com/CompVis/stable-diffusion.git repositories/stable-diffusion && cd repositories/stable-diffusion && git reset --hard 69ae4b35e0a0f6ee1af8bb9a5d0016ccb27e36dc

RUN git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer && cd repositories/CodeFormer && git reset --hard c5b4593074ba6214284d6acd5f1719b6c5d739af
RUN git clone https://github.com/salesforce/BLIP.git repositories/BLIP && cd repositories/BLIP && git reset --hard 48211a1594f1321b00f14c9f7a5b4813144b2fb9
RUN git clone https://github.com/deforum-art/deforum-for-automatic1111-webui repositories/deforum-for-auto && cd repositories/deforum-for-auto && git reset --hard 245f0535d3549d969707ceabc903b2b2a182d55d
#RUN git clone https://github.com/MSFTserver/pytorch3d-lite repositories/pytorch3d-lite && cd repositories/pytorch3d-lite && git reset --hard 4070975c1d6e4de7c87848a53b603f6b29711e55

RUN <<EOF
# because taming-transformers is huge
git config --global http.postBuffer 1048576000
git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers
cd repositories/taming-transformers
git reset --hard 24268930bf1dce879235a7fddd0b2355b84d7ea6
rm -rf data assets
EOF

RUN git clone https://github.com/crowsonkb/k-diffusion.git repositories/k-diffusion && cd repositories/k-diffusion && git reset --hard f4e99857772fc3a126ba886aadf795a332774878

FROM python:3.10-slim as xformers
SHELL ["/bin/bash", "-ceuxo", "pipefail"]
RUN pip install gdown
RUN gdown https://drive.google.com/uc?id=1SqwicrLx1TrG_sbbEoIF_3TUHd4EYSmw -O /wheel.whl

FROM python:3.10-slim

SHELL ["/bin/bash", "-ceuxo", "pipefail"]

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1 PIP_NO_CACHE_DIR=1

RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113

RUN apt-get update && apt install fonts-dejavu-core rsync git -y && apt-get clean


RUN <<EOF
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui
git reset --hard 1eb588cbf19924333b88beaa1ac0041904966640
pip install -r requirements_versions.txt
EOF

ENV ROOT=/stable-diffusion-webui \
  WORKDIR=/stable-diffusion-webui/repositories/stable-diffusion


COPY --from=download /git/ ${ROOT}
RUN pip install --prefer-binary --no-cache-dir -r ${ROOT}/repositories/CodeFormer/requirements.txt

# TODO: move to top
RUN apt-get install jq moreutils -y


# Note: don't update the sha of previous versions because the install will take forever
# instead, update the repo state in a later step

ARG SHA=36a0ba357ab0742c3c4a28437b68fb29a235afbe
RUN <<EOF
cd stable-diffusion-webui
git pull --rebase
git reset --hard ${SHA}
pip install --prefer-binary --no-cache-dir -r requirements_versions.txt
EOF

RUN pip install --prefer-binary --no-cache-dir opencv-python-headless \
  git+https://github.com/TencentARC/GFPGAN.git@8d2447a2d918f8eba5a4a01463fd48e45126a379 \
  git+https://github.com/openai/CLIP.git@d50d76daa670286dd6cacf3bcd80b5e4823fc8e1 \
  pyngrok

COPY --from=xformers /wheel.whl xformers-0.0.14.dev0-cp310-cp310-linux_x86_64.whl
RUN pip install xformers-0.0.14.dev0-cp310-cp310-linux_x86_64.whl

COPY . /docker
RUN <<EOF
chmod +x /docker/mount.sh && python3 /docker/info.py ${ROOT}/modules/ui.py
EOF

#RUN <<EOF
#apt-get install software-properties-common gpg wget ninja-build -y
## Warning: software-properties-common installed Python 3.9
##update-alternatives --install /usr/bin/python python /usr/bin/python3.10 100
#add-apt-repository contrib
#apt-key del 7fa2af80
#
#wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb
#dpkg -i cuda-keyring_1.0-1_all.deb
#
#apt-get update
#apt-get install cuda-nvcc-11-8 cuda-libraries-dev-11-8 -y
#EOF
#
#RUN FORCE_CUDA=1 TORCH_CUDA_ARCH_LIST="6.1" pip install "git+https://github.com/facebookresearch/pytorch3d.git@stable"
#RUN FORCE_CUDA=1 CUDA_HOME=${CUDA_PATH} pip install --prefer-binary --no-cache-dir py3d "git+https://github.com/facebookresearch/pytorch3d.git@stable"
RUN cp -r ${ROOT}/repositories/deforum-for-auto/deforum* ${ROOT}/scripts/
RUN pip install --prefer-binary --no-cache-dir -r ${ROOT}/repositories/deforum-for-auto/requirements.txt

#RUN cp ${ROOT}/repositories/pytorch3d-lite/py3d_tools.py ${ROOT}/scripts/deforum/

ENV CLI_ARGS=""
WORKDIR ${WORKDIR}
EXPOSE 7860
# run, -u to not buffer stdout / stderr
CMD /docker/mount.sh && \
  python3 -u ../../webui.py --listen --port 7860 --ckpt-dir ${ROOT}/models/Stable-diffusion ${CLI_ARGS}
