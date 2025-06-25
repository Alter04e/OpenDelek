-- OpenDelek Snowflake Setup Script
-- This script sets up the complete Snowflake environment for OpenDelek

-- ============================================================================
-- 1. Database and Schema Setup
-- ============================================================================

-- Create main database
CREATE DATABASE IF NOT EXISTS CORPORATE_DELEK_AI
    COMMENT = 'OpenDelek Corporate AI Assistant Platform Database';

USE DATABASE CORPORATE_DELEK_AI;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS CORE_SERVICES
    COMMENT = 'Core AI agent services and functions';

CREATE SCHEMA IF NOT EXISTS AGENT_WORKSPACE
    COMMENT = 'Agent execution workspace and temporary data';

CREATE SCHEMA IF NOT EXISTS AUDIT_LOGS
    COMMENT = 'Audit trails and compliance monitoring';

CREATE SCHEMA IF NOT EXISTS SECURITY
    COMMENT = 'Security policies and access control';

USE SCHEMA CORE_SERVICES;

-- ============================================================================
-- 2. Warehouse Setup
-- ============================================================================

-- Main compute warehouse for AI operations
CREATE WAREHOUSE IF NOT EXISTS DELEK_COMPUTE_WH
    WITH WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = FALSE
    COMMENT = 'Primary compute warehouse for OpenDelek operations';

-- ML/AI specific warehouse
CREATE WAREHOUSE IF NOT EXISTS DELEK_ML_WH
    WITH WAREHOUSE_SIZE = 'LARGE'
    AUTO_SUSPEND = 120
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'High-performance warehouse for ML and AI model operations';

-- ============================================================================
-- 3. Compute Pools for Container Services
-- ============================================================================

-- Browser automation compute pool
CREATE COMPUTE POOL IF NOT EXISTS DELEK_BROWSER_POOL
    MIN_NODES = 0
    MAX_NODES = 5
    INSTANCE_FAMILY = CPU_X64_S
    COMMENT = 'Compute pool for browser automation containers';

-- Document processing compute pool
CREATE COMPUTE POOL IF NOT EXISTS DELEK_DOCUMENT_POOL
    MIN_NODES = 0
    MAX_NODES = 3
    INSTANCE_FAMILY = CPU_X64_M
    COMMENT = 'Compute pool for document processing containers';

-- ============================================================================
-- 4. Core Tables
-- ============================================================================

-- Task management
CREATE TABLE IF NOT EXISTS tasks (
    task_id STRING PRIMARY KEY,
    user_id STRING NOT NULL,
    user_role STRING,
    description TEXT NOT NULL,
    status STRING DEFAULT 'pending',
    priority INTEGER DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    result VARIANT,
    error_message TEXT,
    estimated_duration INTEGER,
    actual_duration INTEGER
) COMMENT = 'Central task management and tracking';

-- Agent executions
CREATE TABLE IF NOT EXISTS agent_executions (
    execution_id STRING PRIMARY KEY,
    task_id STRING,
    agent_type STRING NOT NULL,
    user_input TEXT,
    planned_steps VARIANT,
    context VARIANT,
    status STRING DEFAULT 'pending',
    result VARIANT,
    error_message TEXT,
    performance_metrics VARIANT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    completed_at TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id)
) COMMENT = 'Detailed agent execution logs and results';

-- ============================================================================
-- 5. Role-Based Access Control
-- ============================================================================

-- Create roles
CREATE ROLE IF NOT EXISTS DELEK_ADMIN
    COMMENT = 'Full administrative access to OpenDelek';

CREATE ROLE IF NOT EXISTS DELEK_ANALYST
    COMMENT = 'Data analysis and research capabilities';

CREATE ROLE IF NOT EXISTS DELEK_USER
    COMMENT = 'Standard user access to AI assistant';

CREATE ROLE IF NOT EXISTS DELEK_VIEWER
    COMMENT = 'Read-only access to results and reports';

-- Grant database privileges
GRANT USAGE ON DATABASE CORPORATE_DELEK_AI TO ROLE DELEK_ADMIN;
GRANT USAGE ON DATABASE CORPORATE_DELEK_AI TO ROLE DELEK_ANALYST;
GRANT USAGE ON DATABASE CORPORATE_DELEK_AI TO ROLE DELEK_USER;
GRANT USAGE ON DATABASE CORPORATE_DELEK_AI TO ROLE DELEK_VIEWER;

-- Display setup completion message
SELECT 'OpenDelek Snowflake setup completed successfully!' as setup_status,
       CURRENT_TIMESTAMP() as completed_at;