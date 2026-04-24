# The proper term is pseudo_replica_mode, but we use this compatibility alias
# to make the statement usable on server versions 8.0.24 and older.
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#260424 11:31:17 server id 1  end_log_pos 126 CRC32 0xddb0d00a 	Start: binlog v 4, server v 8.0.42-0ubuntu0.22.04.1 created 260424 11:31:17
BINLOG '
ZTjraQ8BAAAAegAAAH4AAAAAAAQAOC4wLjQyLTB1YnVudHUwLjIyLjA0LjEAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAEwANAAgAAAAABAAEAAAAYgAEGggAAAAICAgCAAAACgoKKioAEjQA
CigAAQrQsN0=
'/*!*/;
# at 126
#260424 11:31:17 server id 1  end_log_pos 157 CRC32 0x40748698 	Previous-GTIDs
# [empty]
# at 157
#260424 11:31:31 server id 1  end_log_pos 236 CRC32 0xd9836904 	Anonymous_GTID	last_committed=0	sequence_number=1	rbr_only=yes	original_committed_timestamp=1777023091823943	immediate_commit_timestamp=1777023091823943	transaction_length=1824
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
# original_commit_timestamp=1777023091823943 (2026-04-24 11:31:31.823943 CEST)
# immediate_commit_timestamp=1777023091823943 (2026-04-24 11:31:31.823943 CEST)
/*!80001 SET @@session.original_commit_timestamp=1777023091823943*//*!*/;
/*!80014 SET @@session.original_server_version=80042*//*!*/;
/*!80014 SET @@session.immediate_server_version=80042*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 236
#260424 11:31:31 server id 1  end_log_pos 323 CRC32 0x75d31e95 	Query	thread_id=92	exec_time=0	error_code=0
SET TIMESTAMP=1777023091/*!*/;
SET @@session.pseudo_thread_id=92/*!*/;
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
#260424 11:31:31 server id 1  end_log_pos 416 CRC32 0x003b6adc 	Table_map: `logistica_global`.`almacenes` mapped to number 186
# has_generated_invisible_primary_key=0
# at 416
#260424 11:31:31 server id 1  end_log_pos 680 CRC32 0x54b02590 	Delete_rows: table id 186 flags: STMT_END_F

BINLOG '
czjraRMBAAAAXQAAAKABAAAAALoAAAAAAAEAEGxvZ2lzdGljYV9nbG9iYWwACWFsbWFjZW5lcwAI
Aw8PDw8PDw8OyABYApAByADIAMgAkAH+AQEAAgP8/wDcajsA
czjraSABAAAACAEAAKgCAAAAALoAAAAAAAEAAgAI/yDJAAAACUFMTS1BTElFTggAw4FyZWEgNTEG
AE5ldmFkYQhJbmZpbml0YQdTZWNyZXRhGQAzNy4yNDMxwrAgTiwgMTE1Ljc5MzDCsCBXIMwAAAAK
QUxNLVRVUFBFUg4ATmV2ZXJhIE9maWNpbmEIAFBsYW50YSAyBzAuMDUgbTMJQmlvaGF6YXJkEAA0
MC40MTY4LCAtMy43MDM4IM0AAAAKQUxNLU5BUk5JQQcAQXJtYXJpbwYATmFybmlhBVJlaW5vCk1v
bmFycXXDrWEWAERldHLDoXMgZGUgbG9zIGFicmlnb3OQJbBU
'/*!*/;
# at 680
#260424 11:31:31 server id 1  end_log_pos 773 CRC32 0xa3e60757 	Table_map: `logistica_global`.`almacenes` mapped to number 186
# has_generated_invisible_primary_key=0
# at 773
#260424 11:31:31 server id 1  end_log_pos 1950 CRC32 0x0b187a29 	Delete_rows: table id 186 flags: STMT_END_F

BINLOG '
czjraRMBAAAAXQAAAAUDAAAAALoAAAAAAAEAEGxvZ2lzdGljYV9nbG9iYWwACWFsbWFjZW5lcwAI
Aw8PDw8PDw8OyABYApAByADIAMgAkAH+AQEAAgP8/wBXB+aj
czjraSABAAAAmQQAAJ4HAAAAALoAAAAAAAEAAgAI/wABAAAACEFMTS00NTlfDgAgIFN1Y3Vyc2Fs
IDAgIAYATWFkcmlkFDE1MTEgbWV0cm9zIGPDumJpY29zDCszNCAzMjM3Mjc5NQZQUk9QSUEbAExh
dDogNDAuNjQwNCB8IExvbjogLTEuMDQ1MQAPAAAACEFMTS01MjAgDwAgIFN1Y3Vyc2FsIDE0ICAG
AE1hZHJpZBQxMTAxIG1ldHJvcyBjw7piaWNvcw0rMzQgMjEzODcxNjg0BlBST1BJQRsATGF0OiAz
OC44NDM0IHwgTG9uOiAtNC4xMjU2ABoAAAAIQUxNLTQwMV8PACAgU3VjdXJzYWwgMjUgIAYATWFk
cmlkBzI2NjEgbTMNKzM0IDg0NzE5MzgyMAtzdWJjb250cmF0YRsATGF0OiA0MC45MDY1IHwgTG9u
OiAtMC41ODg4CCwAAAAHQUxNLTk2IA8AICBTdWN1cnNhbCA0MyAgBjMyNCBtMw0rMzQgMTAzMzM2
MjQxBlBST1BJQRsATGF0OiAzNy4zNDQ5IHwgTG9uOiAtNi42OTQ1ADcAAAAIQUxNLTEyOSAPACAg
U3VjdXJzYWwgNTQgIAgAU2V2aWxsYSAUMTMzMyBtZXRyb3MgY8O6Ymljb3MNKzM0IDc3NTExNzU4
NAtzdWJjb250cmF0YRkATGF0OiA0Mi45MzcgfCBMb246IDIuODkyMQBJAAAACEFMTS0yMzlfDwAg
IFN1Y3Vyc2FsIDcyICAIAFNldmlsbGEgBzQzNTQgbTMNKzM0IDM5NzIxNjU3MQtzdWJjb250cmF0
YRoATGF0OiAzOC4xNDggfCBMb246IC01LjMxNzcIbAAAAAhBTE0tOTUzIBAAICBTdWN1cnNhbCAx
MDcgIAczODM2IG0zDSszNCA1MDM3OTg1NjIGUFJPUElBGwBMYXQ6IDM2LjE3MzkgfCBMb246IC04
LjcwMTgAgwAAAAhBTE0tMjA4IBAAICBTdWN1cnNhbCAxMzAgIAgAU2V2aWxsYSAHNDIxNCBtMwsr
MzQgOTk0ODIzNgtzdWJjb250cmF0YRsATGF0OiAzNi4yMTYyIHwgTG9uOiAtOC42MjkzCLQAAAAI
QUxNLTk1MV8QACAgU3VjdXJzYWwgMTc5ICAUNTM4MyBtZXRyb3MgY8O6Ymljb3MMKzM0IDcwMzU3
ODI3C3N1YmNvbnRyYXRhGgBMYXQ6IDQwLjA1ODMgfCBMb246IC0yLjA0MwC/AAAACEFMTS03OTlf
EAAgIFN1Y3Vyc2FsIDE5MCAgBQBCYXJuYRQyNDMwIG1ldHJvcyBjw7piaWNvcw0rMzQgNjUzMzg0
NDQ3BlBST1BJQRoATGF0OiA0Mi40MzAxIHwgTG9uOiAyLjAyMjkAxgAAAAhBTE0tOTAxIBAAICBT
dWN1cnNhbCAxOTcgIAUAQmFybmETNjEyIG1ldHJvcyBjw7piaWNvcw0rMzQgNjAxNDcyMjY4BlBS
T1BJQRsATGF0OiA0MC45ODQ2IHwgTG9uOiAtMC40NTQ5KXoYCw==
'/*!*/;
# at 1950
#260424 11:31:31 server id 1  end_log_pos 1981 CRC32 0x2c6a8f8f 	Xid = 1520
COMMIT/*!*/;
# at 1981
#260424 11:31:31 server id 1  end_log_pos 2025 CRC32 0xce0e0f08 	Rotate to binlog.000950  pos: 4
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
