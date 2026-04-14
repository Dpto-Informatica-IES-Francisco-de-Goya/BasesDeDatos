# The proper term is pseudo_replica_mode, but we use this compatibility alias
# to make the statement usable on server versions 8.0.24 and older.
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#260414 13:39:06 server id 1  end_log_pos 126 CRC32 0x73c73a6b 	Start: binlog v 4, server v 8.0.43-0ubuntu0.24.04.1 created 260414 13:39:06
# at 126
#260414 13:39:06 server id 1  end_log_pos 157 CRC32 0x230955ce 	Previous-GTIDs
# [empty]
# at 157
#260414 13:52:08 server id 1  end_log_pos 236 CRC32 0x9fc92a2a 	Anonymous_GTID	last_committed=0	sequence_number=1	rbr_only=yes	original_committed_timestamp=1776167528461540	immediate_commit_timestamp=1776167528461540	transaction_length=320
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
# original_commit_timestamp=1776167528461540 (2026-04-14 13:52:08.461540 CEST)
# immediate_commit_timestamp=1776167528461540 (2026-04-14 13:52:08.461540 CEST)
/*!80001 SET @@session.original_commit_timestamp=1776167528461540*//*!*/;
/*!80014 SET @@session.original_server_version=80043*//*!*/;
/*!80014 SET @@session.immediate_server_version=80043*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 236
#260414 13:52:08 server id 1  end_log_pos 309 CRC32 0xf8acd99f 	Query	thread_id=78	exec_time=0	error_code=0
SET TIMESTAMP=1776167528/*!*/;
SET @@session.pseudo_thread_id=78/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1168113696/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8mb4 *//*!*/;
SET @@session.character_set_client=255,@@session.collation_connection=255,@@session.collation_server=255/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
/*!80011 SET @@session.default_collation_for_utf8mb4=255*//*!*/;
BEGIN
/*!*/;
# at 309
#260414 13:52:08 server id 1  end_log_pos 392 CRC32 0x07de27b9 	Table_map: `empresa_segura`.`empleados` mapped to number 155
# has_generated_invisible_primary_key=0
# at 392
#260414 13:52:08 server id 1  end_log_pos 446 CRC32 0x942661ab 	Write_rows: table id 155 flags: STMT_END_F
# at 446
#260414 13:52:08 server id 1  end_log_pos 477 CRC32 0x66c9b63e 	Xid = 1908
COMMIT/*!*/;
# at 477
#260414 13:52:28 server id 1  end_log_pos 521 CRC32 0x79680a23 	Rotate to binlog.000301  pos: 4
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
