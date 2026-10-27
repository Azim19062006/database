-- screenshot: pgadmin-lab16-transactions.jpg | savepoint_constraint
-- Lab 16 | COMMIT, ROLLBACK, consistency and SAVEPOINT checks
SELECT check_name,passed,details FROM lab16.checks
WHERE check_name IN('commit_transfer','rollback_transfer','consistent_total',
 'savepoint_order','savepoint_constraint','atomic_order_failure') ORDER BY check_name;

-- screenshot: pgadmin-lab16-isolation.jpg | serializable_conflict
-- Lab 16 | Actual concurrent psql sessions: MVCC, locks and 40001
SELECT check_name,passed,details FROM lab16.checks
WHERE check_name IN('no_dirty_read','read_committed','repeatable_read',
 'serializable_conflict','lock_observed','durability_reconnect') ORDER BY check_name;
