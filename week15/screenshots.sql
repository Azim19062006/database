-- screenshot: pgadmin-lab17-csv-etl.jpg | wal_archive_cleanup
-- Lab 17 | Executed COPY/CSV, ETL, partition and WAL cleanup checks
SELECT check_name,passed,details FROM lab17.checks
WHERE check_name IN('copy_roundtrip','copy_skip_bad_row','csv_options',
 'etl_upsert','partition_migration','wal_archive_cleanup') ORDER BY check_name;

-- screenshot: pgadmin-lab17-restores.jpg | custom_parallel_restore
-- Lab 17 | Real backup restores, table hashes and automated backup
SELECT check_name,passed,details FROM lab17.checks
WHERE check_name IN('plain_restore','custom_parallel_restore','schema_data_restore',
 'selective_restore','table_from_full_archive','daily_backup') ORDER BY check_name;

-- screenshot: pgadmin-lab17-recovery.jpg | pitr_restore
-- Lab 17 | Real local clusters: incremental backup, WAL/PITR, replication
SELECT check_name,passed,details FROM lab17.checks
WHERE check_name IN('durability_restart','physical_standby','streaming_migration',
 'incremental_restore','pitr_restore','logical_migration') ORDER BY check_name;

-- screenshot: pgadmin-lab17-pitr-targets.jpg | pitr_xid_restore
-- Lab 17 | Recovery by name, timestamp and transaction ID; tar/gzip backup
SELECT check_name,passed,details FROM lab17.checks
WHERE check_name IN('pitr_restore','pitr_time_restore','pitr_xid_restore',
 'compressed_base_backup') ORDER BY check_name;
