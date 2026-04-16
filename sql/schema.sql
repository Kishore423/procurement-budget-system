-- Integrated Procurement and Budget Control System
-- Schema aligned to README.md

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    department_id INTEGER NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(30) NOT NULL,
    CONSTRAINT fk_users_department FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT chk_users_role CHECK (role IN ('ADMIN', 'STAFF', 'DEPARTMENT_HEAD', 'FINANCE'))
);

CREATE TABLE department_budgets (
    budget_id INTEGER PRIMARY KEY,
    department_id INTEGER NOT NULL,
    fiscal_year INTEGER NOT NULL,
    initial_budget DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_budgets_department FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT uq_department_budget UNIQUE (department_id, fiscal_year),
    CONSTRAINT chk_initial_budget CHECK (initial_budget >= 0)
);

CREATE TABLE procurement_requests (
    pr_id INTEGER PRIMARY KEY,
    pr_number VARCHAR(20) NOT NULL UNIQUE,
    department_id INTEGER NOT NULL,
    requester_id INTEGER NOT NULL,
    status VARCHAR(30) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    head_approved_by INTEGER NULL,
    head_approved_at TIMESTAMP NULL,
    finance_approved_by INTEGER NULL,
    finance_approved_at TIMESTAMP NULL,
    submitted_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_pr_department FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT fk_pr_requester FOREIGN KEY (requester_id)
        REFERENCES users(user_id),
    CONSTRAINT fk_pr_head_approver FOREIGN KEY (head_approved_by)
        REFERENCES users(user_id),
    CONSTRAINT fk_pr_finance_approver FOREIGN KEY (finance_approved_by)
        REFERENCES users(user_id),
    CONSTRAINT chk_pr_status CHECK (status IN ('DRAFT', 'PENDING_HEAD', 'PENDING_FINANCE', 'OVER_BUDGET_HOLD', 'APPROVED', 'REJECTED')),
    CONSTRAINT chk_pr_total_amount CHECK (total_amount >= 0)
);

CREATE TABLE procurement_request_items (
    item_id INTEGER PRIMARY KEY,
    pr_id INTEGER NOT NULL,
    item_name VARCHAR(150) NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_pr_items_request FOREIGN KEY (pr_id)
        REFERENCES procurement_requests(pr_id),
    CONSTRAINT chk_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_item_unit_price CHECK (unit_price >= 0)
);

-- Remaining budget is a calculated value:
-- remaining_budget = initial_budget - sum(total_amount for APPROVED requests).
