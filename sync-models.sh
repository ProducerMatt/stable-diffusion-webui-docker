#!/bin/sh

echo "THIS SCRIPT WILL DELETE ANY FILES NOT ON THE SOURCE"
rsync --delete-after -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/Hypernetworks/ ./data/Hypernetworks/
rsync --delete-after -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/Embeddings/ ./data/embeddings/
rsync --delete-after -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/LORA/ ./data/Lora/
rsync --delete-after -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/ControlNets/ ./data/config/auto/extensions/controlnet/models
rsync --delete-before -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/Models-VAEs/ ./data/StableDiffusion/
