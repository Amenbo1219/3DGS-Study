docker run --rm -it  \
	-v ./data/gaussian-splatting:/work \
	-p "8001:8888" \
	--shm-size="100gb" \
	--gpus device=0  \
	3dgs:1


