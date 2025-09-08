FROM docker.io/labgrid/client

# Always use the newest QEMU packages
RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/bookworm-backports.list && \
    apt update && \
    apt -t bookworm-backports install -y qemu-system-arm qemu-system-aarch64

# Plugins for parallelization
RUN pip install --break-system-packages pytest-xdist[psutil]