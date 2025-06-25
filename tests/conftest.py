import pytest
import os
from unittest.mock import Mock, patch
from pathlib import Path

# Add project root to path
import sys
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

@pytest.fixture
def mock_snowflake_session():
    """Mock Snowflake session for testing."""
    session = Mock()
    session.sql.return_value.collect.return_value = [
        ("claude-sonnet-4", "Test response from Cortex AI")
    ]
    return session

@pytest.fixture 
def sample_user_context():
    """Sample user context for testing."""
    return {
        'user_id': 'test_user',
        'role': 'DELEK_USER',
        'permissions': ['read', 'analyze'],
        'department': 'IT',
        'ip_address': '192.168.1.100'
    }