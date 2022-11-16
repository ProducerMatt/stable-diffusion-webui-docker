#!/bin/sh

BOOKMARK=$(pwd)
fd -u -td -d 1 . data/config/auto/extensions -x sh -c "echo Entering '{}'; cd '{}' ; git pull --quiet --recurse-submodules --autostash; git gc --aggressive --prune=now"\;
fd -u -td -d 1 . data/config/auto/scripts.git -x sh -c "echo Entering '{}'; cd '{}' ; git pull --quiet --recurse-submodules --autostash; git gc --aggressive --prune=now"\;

export SCRIPTSDIR="$(realpath "$HOME/stable-diffusion-webui-docker/data/config/auto/scripts")"
rm -rf $SCRIPTSDIR || exit
mkdir $SCRIPTSDIR ||exit

pushd data/config/auto/scripts.git/SD-Chad || exit
cp ./chad_scorer.py $SCRIPTSDIR || exit
cp ./*.pth $SCRIPTSDIR || exit
popd
pushd data/config/auto/scripts.git/SD-latent-mirroring/scripts || exit
cp ./latent_mirroring.py $SCRIPTSDIR || exit
popd
pushd data/config/auto/scripts.git/StylePile.git || exit
cp -r ./StylePile* $SCRIPTSDIR || exit
popd
pushd data/config/auto/scripts.git/external-masking || exit
cp -r ./external_masking.py $SCRIPTSDIR || exit
popd
pushd data/config/auto/scripts.git/test_my_prompt || exit
cp -r test_my_prompt_custom_script.py $SCRIPTSDIR || exit
popd

cd $BOOKMARK || exit
