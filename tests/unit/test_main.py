import pytest
from unittest.mock import Mock, patch

def test_opendelek_initialization():
    """Test OpenDelek initialization."""
    with patch('main.SnowflakeConfig'):
        with patch('main.ComplianceManager'):
            with patch('main.DelekOrchestrator'):
                from main import OpenDelek

                # Should initialize without error
                delek = OpenDelek()
                assert delek is not None

def test_health_check():
    """Test system health check."""
    with patch('main.SnowflakeConfig'):
        with patch('main.ComplianceManager'):
            with patch('main.DelekOrchestrator'):
                from main import OpenDelek

                delek = OpenDelek()

                # Mock health check components
                delek.config.test_connection = Mock(return_value=True)
                delek.orchestrator.test_cortex_ai = Mock(return_value=True)
                delek.compliance_manager.health_check = Mock(return_value=True)
                delek.orchestrator.test_containers = Mock(return_value=True)

                health = delek.health_check()

                assert health['status'] == 'healthy'
                assert all(health['components'].values())