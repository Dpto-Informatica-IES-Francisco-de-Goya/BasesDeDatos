# The proper term is pseudo_replica_mode, but we use this compatibility alias
# to make the statement usable on server versions 8.0.24 and older.
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#260505 13:05:42 server id 1  end_log_pos 126 CRC32 0x096894d3 	Start: binlog v 4, server v 8.0.43-0ubuntu0.24.04.1 created 260505 13:05:42
BINLOG '
Bs/5aQ8BAAAAegAAAH4AAAAAAAQAOC4wLjQzLTB1YnVudHUwLjI0LjA0LjEAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAEwANAAgAAAAABAAEAAAAYgAEGggAAAAICAgCAAAACgoKKioAEjQA
CigAAdOUaAk=
'/*!*/;
# at 126
#260505 13:05:42 server id 1  end_log_pos 157 CRC32 0x4e80681c 	Previous-GTIDs
# [empty]
# at 157
#260505 13:05:56 server id 1  end_log_pos 236 CRC32 0x9d5fd4e1 	Anonymous_GTID	last_committed=0	sequence_number=1	rbr_only=yes	original_committed_timestamp=1777979156758871	immediate_commit_timestamp=1777979156758871	transaction_length=347
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
# original_commit_timestamp=1777979156758871 (2026-05-05 13:05:56.758871 CEST)
# immediate_commit_timestamp=1777979156758871 (2026-05-05 13:05:56.758871 CEST)
/*!80001 SET @@session.original_commit_timestamp=1777979156758871*//*!*/;
/*!80014 SET @@session.original_server_version=80043*//*!*/;
/*!80014 SET @@session.immediate_server_version=80043*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 236
#260505 13:05:56 server id 1  end_log_pos 323 CRC32 0xaa3551ca 	Query	thread_id=53	exec_time=0	error_code=0
SET TIMESTAMP=1777979156/*!*/;
SET @@session.pseudo_thread_id=53/*!*/;
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
#260505 13:05:56 server id 1  end_log_pos 421 CRC32 0xfd7b0848 	Table_map: `logistica_global`.`clientes` mapped to number 184
# has_generated_invisible_primary_key=0
# at 421
#260505 13:05:56 server id 1  end_log_pos 473 CRC32 0xe9f62375 	Write_rows: table id 184 flags: STMT_END_F

BINLOG '
FM/5aRMBAAAAYgAAAKUBAAAAALgAAAAAAAEAEGxvZ2lzdGljYV9nbG9iYWwACGNsaWVudGVzAAoD
Dw/8Dw8PDw8PEcgAIAMCUABYAsgAyADIACgA/gMBAQACA/z/AEgIe/0=
FM/5aR4BAAAANAAAANkBAAAAALgAAAAAAAEAAgAK///8A/gBAAAJMTIzMTIzMTIzdSP26Q==
'/*!*/;
# at 473
#260505 13:05:56 server id 1  end_log_pos 504 CRC32 0x2333811d 	Xid = 1352
COMMIT/*!*/;
# at 504
#260505 13:05:59 server id 1  end_log_pos 548 CRC32 0x1446ff77 	Rotate to binlog.000342  pos: 4
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
