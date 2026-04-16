-- Seed data aligned to README.md
-- Example: IT initial budget = 50000.00
-- Example: IT approved spend = 17000.00
-- Example: IT remaining budget = 33000.00

INSERT INTO departments (department_id, department_name) VALUES
    (1, 'Information Technology'),
    (2, 'Finance'),
    (3, 'Operations');

INSERT INTO users (user_id, department_id, full_name, role) VALUES
    (1, 2, 'Ava Admin', 'ADMIN'),
    (2, 1, 'Ian Staff', 'STAFF'),
    (3, 1, 'Helen Head', 'DEPARTMENT_HEAD'),
    (4, 2, 'Farah Finance', 'FINANCE'),
    (5, 3, 'Olivia Staff', 'STAFF'),
    (6, 3, 'Omar Head', 'DEPARTMENT_HEAD');

INSERT INTO department_budgets (budget_id, department_id, fiscal_year, initial_budget) VALUES
    (1, 1, 2026, 50000.00),
    (2, 2, 2026, 80000.00),
    (3, 3, 2026, 30000.00);

INSERT INTO procurement_requests (
    pr_id,
    pr_number,
    department_id,
    requester_id,
    status,
    total_amount,
    head_approved_by,
    head_approved_at,
    finance_approved_by,
    finance_approved_at,
    submitted_at
) VALUES
    (1, 'PR-2026-001', 1, 2, 'APPROVED', 4500.00, 3, '2026-04-01 10:00:00', NULL, NULL, '2026-03-31 09:00:00'),
    (2, 'PR-2026-002', 1, 2, 'APPROVED', 12500.00, 3, '2026-04-03 11:00:00', 4, '2026-04-04 15:00:00', '2026-04-02 14:30:00'),
    (3, 'PR-2026-003', 1, 2, 'OVER_BUDGET_HOLD', 40000.00, 3, '2026-04-08 09:15:00', 4, '2026-04-08 16:30:00', '2026-04-07 13:00:00'),
    (4, 'PR-2026-004', 3, 5, 'PENDING_HEAD', 2200.00, NULL, NULL, NULL, NULL, '2026-04-10 08:45:00');

INSERT INTO procurement_request_items (item_id, pr_id, item_name, quantity, unit_price) VALUES
    (1, 1, 'Laptop Dock', 10, 250.00),
    (2, 1, 'Wireless Keyboard', 20, 100.00),
    (3, 2, 'Workstation', 5, 2200.00),
    (4, 2, 'UPS Unit', 5, 300.00),
    (5, 3, 'Development Laptop', 20, 1800.00),
    (6, 3, 'Software License', 10, 400.00),
    (7, 4, 'Office Chair', 4, 300.00),
    (8, 4, 'Whiteboard', 2, 500.00);
