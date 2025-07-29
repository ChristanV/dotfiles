#!/bin/sh
usage=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | head -n1)
gpu_use=$(echo "$usage" | cut -d',' -f1 | xargs)

echo "󰢮 ${gpu_use}% "
