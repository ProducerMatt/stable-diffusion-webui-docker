#!/bin/sh

echo "THIS SCRIPT WILL DELETE ANY FILES NOT ON THE SOURCE"
rsync --delete-after -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/Models-VAEs/ ./data/StableDiffusion/
rsync --delete-after -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/Hypernetworks/ ./data/Hypernetworks/
rsync --delete-after -rtyiP /mnt/MattNAS/Machine\ Learning/Sync/Embeddings/ ./data/embeddings/
