# Tests for a runtime system sanity check
#
# Note: This could potentially be moved to a testimage suite.
# -----------------------------------

import pytest

from labgrid.driver import SSHDriver

@pytest.mark.smoketest
def test_core_services_running(default_ssh: SSHDriver) -> None:
    systemd_services = ["rauc", "rauc-mark-good"]

    for service in systemd_services:
        default_ssh.run(f"systemctl status {service}")
