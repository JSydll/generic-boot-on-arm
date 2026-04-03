---
name: python-testing
description: Python testing best practices with pytest. Covers unit, integration, async tests, mocking, fixtures.
---

# Python Testing

Modern Python testing with the pytest ecosystem.

## Tooling

Run the test with `test-run-pytest` and some of the following options

- no arguments: run all tests
- `--cov --cov-report=term-missing`: with coverage
- `-m "not slow"` or `-m integration`: by marker
- `-v -s`: with verbose output
- `-x`: to stop on first failure
- `--lf`: to only run last failed
- `-n auto`: to run parallel tests

**NEVER use** `unittest` style or `mock` standalone - use native pytest and pytest-mock instead.

## Best Practices

- One assertion per test (usually)
- USE descriptive test names: `test_<what>_<condition>_<expected>`
- USE fixtures for setup/teardown
- Test edge cases: empty, None, negative, boundary values
- Test error paths, not just happy paths
- Keep tests fast (mock external services)
- Use `pytest.raises` for exception testing

- AVOID testing implementation details
- AVOID `time.sleep()` in tests
- AVOID sharing state between tests
- AVOID testing private methods directly
- AVOID writing tests that depend on execution order
- Mock everything (some integration is good)

## Example Patterns

### Basic Test

```python
# tests/unit/test_calculator.py
import pytest
from mypackage.calculator import add, divide

def test_add_positive_numbers():
    assert add(2, 3) == 5

def test_add_negative_numbers():
    assert add(-1, -1) == -2

def test_divide_by_zero_raises():
    with pytest.raises(ZeroDivisionError):
        divide(1, 0)
```

### Parametrized Tests

```python
import pytest

@pytest.mark.parametrize("input,expected", [
    ("hello", "HELLO"),
    ("World", "WORLD"),
    ("", ""),
    ("123", "123"),
])
def test_uppercase(input, expected):
    assert input.upper() == expected


@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
])
def test_add(a, b, expected):
    assert add(a, b) == expected
```

### Fixtures

```python
# tests/conftest.py
import pytest
from mypackage.database import Database

@pytest.fixture
def sample_user():
    """Simple data fixture."""
    return {"id": 1, "name": "Test User", "email": "test@example.com"}


@pytest.fixture
def db():
    """Setup/teardown fixture."""
    database = Database(":memory:")
    database.connect()
    yield database
    database.disconnect()


@pytest.fixture(scope="module")
def expensive_resource():
    """Shared across module (use sparingly)."""
    resource = create_expensive_resource()
    yield resource
    resource.cleanup()
```

### Async Tests

```python
import pytest
from mypackage.api import fetch_user

# With asyncio_mode = "auto", no decorator needed
async def test_fetch_user():
    user = await fetch_user(1)
    assert user["id"] == 1


# Async fixture
@pytest.fixture
async def async_client():
    async with AsyncClient() as client:
        yield client


async def test_with_async_client(async_client):
    response = await async_client.get("/users")
    assert response.status_code == 200
```

### Mocking

```python
from unittest.mock import AsyncMock
import pytest

def test_send_email(mocker):
    """Mock external service."""
    mock_send = mocker.patch("mypackage.email.send_email")
    mock_send.return_value = True

    result = notify_user("test@example.com", "Hello")

    assert result is True
    mock_send.assert_called_once_with("test@example.com", "Hello")


async def test_external_api(mocker):
    """Mock async function."""
    mock_fetch = mocker.patch(
        "mypackage.client.fetch_data",
        new_callable=AsyncMock,
        return_value={"data": "mocked"}
    )

    result = await process_data()

    assert result["data"] == "mocked"
    mock_fetch.assert_awaited_once()
```

### Exception Testing

```python
import pytest
from mypackage.validator import validate_email

def test_invalid_email_raises():
    with pytest.raises(ValueError) as exc_info:
        validate_email("not-an-email")

    assert "Invalid email format" in str(exc_info.value)


def test_specific_exception_attributes():
    with pytest.raises(ValidationError) as exc_info:
        validate_input({"bad": "data"})

    assert exc_info.value.field == "email"
    assert exc_info.value.code == "required"
```

### Markers

```python
import pytest

@pytest.mark.slow
def test_complex_calculation():
    """Run with: pytest -m slow"""
    result = heavy_computation()
    assert result is not None


@pytest.mark.integration
async def test_database_connection():
    """Run with: pytest -m integration"""
    async with get_connection() as conn:
        assert await conn.ping()


@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    pass


@pytest.mark.skipif(sys.platform == "win32", reason="Unix only")
def test_unix_specific():
    pass
```