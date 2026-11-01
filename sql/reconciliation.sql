-- PayFlow P2P / QA read-only SQL diagnostics
-- Dialect: PostgreSQL-compatible SQL.
-- Schema: wallet_ledger(id, request_id, user_id, type, amount, created_at).
-- DEBIT includes sender fee, CREDIT is receiver amount, REFUND restores debit.
-- These are investigation queries, NOT automatic refund instructions.
-- Finance-ops must validate canonical transfer status and provider settlement.

-- 1. Incident a91f / c47b: financial movements.
SELECT request_id,
       SUM(CASE WHEN type = 'DEBIT' THEN amount ELSE 0 END) AS total_debited,
       SUM(CASE WHEN type = 'CREDIT' THEN amount ELSE 0 END) AS total_credited,
       SUM(CASE WHEN type = 'REFUND' THEN amount ELSE 0 END) AS total_refunded,
       COUNT(*) FILTER (WHERE type = 'DEBIT') AS debit_entries,
       COUNT(*) FILTER (WHERE type = 'CREDIT') AS credit_entries,
       COUNT(*) FILTER (WHERE type = 'REFUND') AS refund_entries,
       MAX(created_at) AS last_ledger_event
FROM wallet_ledger
WHERE request_id IN ('a91f', 'c47b')
GROUP BY request_id
ORDER BY request_id;

-- 2. Candidate orphan debits older than approved settlement cut-off.
-- Supply :settlement_cutoff as a parameter. Status needs separate verification.
WITH grouped AS (
    SELECT request_id,
           SUM(CASE WHEN type = 'DEBIT' THEN amount ELSE 0 END) AS debited,
           SUM(CASE WHEN type = 'CREDIT' THEN amount ELSE 0 END) AS credited,
           SUM(CASE WHEN type = 'REFUND' THEN amount ELSE 0 END) AS refunded,
           MIN(created_at) FILTER (WHERE type = 'DEBIT') AS first_debit_at
    FROM wallet_ledger
    GROUP BY request_id
)
SELECT request_id, debited, first_debit_at
FROM grouped
WHERE debited > 0
  AND credited = 0
  AND refunded = 0
  AND first_debit_at < :settlement_cutoff
ORDER BY first_debit_at;

-- 3. Suspicious multiple debit entries under one request_id.
SELECT request_id, COUNT(*) AS debit_entries, SUM(amount) AS total_debited
FROM wallet_ledger
WHERE type = 'DEBIT'
GROUP BY request_id
HAVING COUNT(*) > 1
ORDER BY total_debited DESC;

-- 4. Credit + refund for same request can indicate settlement conflict.
SELECT request_id,
       SUM(CASE WHEN type = 'CREDIT' THEN amount ELSE 0 END) AS credited,
       SUM(CASE WHEN type = 'REFUND' THEN amount ELSE 0 END) AS refunded
FROM wallet_ledger
GROUP BY request_id
HAVING SUM(CASE WHEN type = 'CREDIT' THEN amount ELSE 0 END) > 0
   AND SUM(CASE WHEN type = 'REFUND' THEN amount ELSE 0 END) > 0;

-- request_id is NOT Idempotency-Key. To detect duplicate requests with
-- different request_ids, join transfer/API trace data once available.
