#!/bin/bash

LOG_FILE="./logs/dpdk_$(date +%Y%m%d_%H%M%S).log"

echo "Timestamp: $(date)" | tee -a "$LOG_FILE"

./dpdk-24.03/build/examples/dpdk-rxtx_callbacks --no-huge --vdev=net_ring0\
     --vdev=net_ring1 -l 0-1 -m 512 2>&1 | tee -a "$LOG_FILE"
