mkdir -p .docker-conan2
podman run -p 5000:5000 -v .:/code -v .docker-conan2:/root/.conan2 -it lqr471814/urc-control-systems-2024
