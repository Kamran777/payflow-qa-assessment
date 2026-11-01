# PayFlow P2P | Middle QA Engineer Take-Home Assessment

**Candidate:** Kamran Shukurzade  
**Assessment type:** Risk-based QA analysis and test design  
**Product:** PayFlow wallet-to-wallet P2P transfer (AZN)  
**API:** `POST /api/v1/transfers`  

## Submission files

| File | Description |
| --- | --- |
| [PayFlow QA Assessment (PDF)](docs/payflow_qa_Assessment.pdf) | Final 14-page assessment covering all four tasks: requirement analysis, 25 selected test cases, production incident investigation and release recommendations. |
| [Test cases (CSV)](test-cases/test_cases.csv) | Portable, filterable test-case inventory with conditions, steps, expected results, priority, design technique and execution status. |
| [Reconciliation queries (SQL)](sql/reconciliation.sql) | Read-only diagnostic queries for request-level debit, credit and refund reconciliation. |
| [Clarification register](docs/assumptions.md) | Open product decisions and provisional testing assumptions. |

## Coverage and risk-based approach

1. **Requirements:** 10 risk-ranked ambiguities/gaps, each with its business impact, a concrete PO/developer question and a provisional QA assumption.
2. **Test design:** exactly 25 cases across equivalence partitions, boundary values, decision tables, state transitions and system-level failure scenarios. Fee and daily-limit boundaries include the sender-paid commission.
3. **Incident:** UTC event chronology, distinct observed defects, root-cause hypotheses with supporting log evidence, severity/priority, a bug report and regression recommendations.
4. **Release decision:** prioritization under reduced time, API regression/integration/end-to-end automation boundaries, manual checks and a financial-safety release gate.

The primary invariant is **money conservation**: a sender's debit must eventually correspond to one legitimate receiver credit **or** a complete sender refund. Retries and concurrent requests must never cause a duplicate debit or credit.

## Execution status and open questions

**All 25 test cases are `Not Run`.** The assessment provides a test design, not evidence of tests executed against a live service. No staging environment, API credentials, wallet database, SMS/OTP provider, push gateway or mail system was supplied.

The orange **`BLOCKED`** badges mean *the expected behavior requires clarification from the Product Owner*. They do **not** mean that a test was executed and failed. Assumed rules are explicitly identified and must be confirmed before formal pass/fail assertions.

## How to review

1. Open the PDF first; it is the **authoritative final submission**.
2. Import `test-cases/test_cases.csv` into a test-management tool or spreadsheet if you want to filter cases by risk or technique.
3. Review `docs/assumptions.md` before treating tentative expectations as requirements.
4. Treat `sql/reconciliation.sql` as **investigative only**. It performs no refunds or balance changes; a financial correction requires settlement verification and authorized approval.

## Repository contents

```text
├── README.md
├── .gitignore
├── docs/
│   ├── payflow_qa_assessment.pdf
│   └── assumptions.md
├── test-cases/
│   └── test_cases.csv
└── sql/
    └── reconciliation.sql
```

This repository contains no real customer data, production credentials or runnable application tests. Incident identifiers are taken from the supplied assessment scenario.
