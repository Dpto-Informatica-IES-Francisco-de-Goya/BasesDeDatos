# The proper term is pseudo_replica_mode, but we use this compatibility alias
# to make the statement usable on server versions 8.0.24 and older.
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#260424 11:31:31 server id 1  end_log_pos 126 CRC32 0xe10e95fe 	Start: binlog v 4, server v 8.0.42-0ubuntu0.22.04.1 created 260424 11:31:31
BINLOG '
czjraQ8BAAAAegAAAH4AAAAAAAQAOC4wLjQyLTB1YnVudHUwLjIyLjA0LjEAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAEwANAAgAAAAABAAEAAAAYgAEGggAAAAICAgCAAAACgoKKioAEjQA
CigAAf6VDuE=
'/*!*/;
# at 126
#260424 11:31:31 server id 1  end_log_pos 157 CRC32 0xa259700a 	Previous-GTIDs
# [empty]
# at 157
#260424 11:31:44 server id 1  end_log_pos 236 CRC32 0x2cc594a9 	Anonymous_GTID	last_committed=0	sequence_number=1	rbr_only=yes	original_committed_timestamp=1777023104689959	immediate_commit_timestamp=1777023104689959	transaction_length=362
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
# original_commit_timestamp=1777023104689959 (2026-04-24 11:31:44.689959 CEST)
# immediate_commit_timestamp=1777023104689959 (2026-04-24 11:31:44.689959 CEST)
/*!80001 SET @@session.original_commit_timestamp=1777023104689959*//*!*/;
/*!80014 SET @@session.original_server_version=80042*//*!*/;
/*!80014 SET @@session.immediate_server_version=80042*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 236
#260424 11:31:44 server id 1  end_log_pos 323 CRC32 0x50f6890a 	Query	thread_id=95	exec_time=0	error_code=0
SET TIMESTAMP=1777023104/*!*/;
SET @@session.pseudo_thread_id=95/*!*/;
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
# at 323
#260424 11:31:44 server id 1  end_log_pos 416 CRC32 0xcdeda6f0 	Table_map: `logistica_global`.`almacenes` mapped to number 186
# has_generated_invisible_primary_key=0
# at 416
#260424 11:31:44 server id 1  end_log_pos 488 CRC32 0x6dcda40b 	Delete_rows: table id 186 flags: STMT_END_F

BINLOG '
gDjraRMBAAAAXQAAAKABAAAAALoAAAAAAAEAEGxvZ2lzdGljYV9nbG9iYWwACWFsbWFjZW5lcwAI
Aw8PDw8PDw8OyABYApAByADIAMgAkAH+AQEAAgP8/wDwpu3N
gDjraSABAAAASAAAAOgBAAAAALoAAAAAAAEAAgAI//DPAAAAB0FMTS0wMDELAER1cGxpY2FkYSBC
CQBCYXJjZWxvbmELpM1t
'/*!*/;
# at 488
#260424 11:31:44 server id 1  end_log_pos 519 CRC32 0x7f6b74bf 	Xid = 1535
COMMIT/*!*/;
# at 519
#260424 11:31:44 server id 1  end_log_pos 563 CRC32 0x4a9d08b1 	Rotate to binlog.000951  pos: 4
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
