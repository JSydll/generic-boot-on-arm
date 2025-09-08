# Tests for installing the current software
#
# -----------------------------------

import pytest

import environment.update as update

from environment.software_version import SoftwareVersion

# All tests in this module are related to the update feature.
pytestmark = pytest.mark.update

@pytest.mark.smoketest
@pytest.mark.parametrize('version_to_install',
        [SoftwareVersion.latest]
    )
def test_update_from_latest_succeeds(update_latest: update.UpdateFlow, version_to_install: SoftwareVersion) -> None:
    """
    Test that the happy path update from latest to the specified version succeeds.
    """
    update_latest.execute_all_steps(version_to_install)