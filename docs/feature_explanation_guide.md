# Integrated Procurement and Budget Control System
## Feature Explanation Guide

### 1. Purpose of This Document
This document is a feature-by-feature explanation guide for the technical interview and video demo. It is written to help present the system clearly, confidently, and in a business-friendly way.

### 2. Feature Overview
- Department Budget Management
  This feature stores the initial budget for each department and fiscal year. It provides the baseline for budget control.
- Procurement Request Submission
  This feature allows staff to create a procurement request and submit it for review. It captures the request header information.
- Procurement Request Line Items
  This feature stores the items inside each procurement request. It supports quantity, unit price, and line-level cost details.
- Conditional Approval Workflow
  This feature routes requests based on the total amount. It keeps the approval process simple and controlled.
- Budget Check and Over-Budget Hold
  This feature checks whether there is enough remaining budget before final approval. If not, the request is blocked and moved to `OVER_BUDGET_HOLD`.
- Remaining Budget Dashboard
  This feature gives visibility into approved spend, remaining budget, and approval queues. It helps Admin and Finance monitor both spending and bottlenecks.

### 3. Feature-by-Feature Explanation
#### A. Department Budget Management
This feature is mainly used by Admin users.

It stores the department, fiscal year, and initial budget amount in the `department_budgets` table.

It supports budget control because every final approval is checked against the department’s remaining budget.

#### B. Procurement Request Submission
This feature is mainly used by Staff users.

It captures the request header in `procurement_requests`, including the request number, department, requester, status, total amount, and approval fields.

When a PR is created, it starts as a request record that can later be submitted into the approval flow.

#### C. Procurement Request Line Items
This feature uses a master-detail relationship.

`procurement_requests` is the header or master record, and `procurement_request_items` is the detail record.

Each line item stores an item name, quantity, and unit price. The line amounts contribute to the request total, where `total_amount` represents the sum of all line items.

#### D. Conditional Approval Workflow
Department Head approval always comes first.

If `total_amount < 10000`, the request follows this path: Department Head -> Budget Check -> `APPROVED`.

If `total_amount >= 10000`, the request follows this path: Department Head -> Finance Manager -> Budget Check -> `APPROVED`.

This keeps smaller requests simple while adding Finance Manager control for larger requests.

#### E. Budget Check and Over-Budget Hold
The remaining budget formula is:

`Remaining Budget = Initial Budget - SUM(total_amount of APPROVED PRs)`

The budget is checked before final approval, not at the moment the request is created.

If approving the request would make the remaining budget negative, final approval is blocked and the status becomes `OVER_BUDGET_HOLD`.

#### F. Remaining Budget Dashboard
This feature shows the key business view of the system.

It highlights the initial budget, approved spend, remaining budget, and the number of requests waiting at each approval stage.

Finance and Admin users use it to monitor budget usage and identify approval bottlenecks quickly.

### 4. How the Features Work Together
1. The department budget is set.
2. A procurement request is created.
3. Line items are added to the request.
4. The request total is calculated.
5. The request goes through the approval route.
6. The system checks the remaining budget before final approval.
7. The request is either approved or placed on hold.
8. The dashboard reflects the latest approved spend, remaining budget, and approval queues.

### 5. Key Business Logic
- `total_amount` equals the sum of the request line items.
- Remaining budget equals initial budget minus approved procurement request totals.
- Only `APPROVED` procurement requests reduce budget.
- Budget deduction happens only when a request enters `APPROVED`.

### 6. Demo Mapping
- `PR-2026-001`
  This demonstrates the `<10000` approval path. It shows a request that goes from Department Head approval to budget check and then becomes `APPROVED`.
- `PR-2026-002`
  This demonstrates the `>=10000` approval path. It shows a request that requires both Department Head approval and Finance Manager approval before the budget check.
- `PR-2026-003`
  This demonstrates the over-budget hold feature. It shows a request that passes the approval route but is blocked at final approval because it would make the remaining budget negative.
- `PR-2026-004`
  This demonstrates the pending approval state. It shows a request still waiting at `PENDING_HEAD`.

### 7. Talking Points for Interview
- “This feature handles department-level budget control by storing the initial budget for each fiscal year.”
- “This part of the system captures the procurement request header and keeps the request easy to track.”
- “This master-detail structure is important because one procurement request can contain many line items.”
- “This workflow rule is important because smaller requests stay simple, while larger requests get extra finance review.”
- “This budget check ensures the system does not approve spending that would push the department over budget.”
- “This dashboard helps Finance and Admin see both budget consumption and approval delays in one view.”

### 8. Why This Design Fits the Technical Test
This guide reflects the same deliverables already covered in the repository.

- The ERD and workflow are already documented in the README.
- The business logic and wireframes are already explained in the README.
- The POC logic is represented in `schema.sql` and supported by `seed.sql`.
- The demo scenarios in this guide match the seeded examples used in the submission.
