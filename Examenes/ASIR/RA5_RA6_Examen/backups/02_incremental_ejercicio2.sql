# The proper term is pseudo_replica_mode, but we use this compatibility alias
# to make the statement usable on server versions 8.0.24 and older.
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#260424 10:01:59 server id 1  end_log_pos 126 CRC32 0xc36e8129 	Start: binlog v 4, server v 8.0.43-0ubuntu0.24.04.1 created 260424 10:01:59
BINLOG '
dyPraQ8BAAAAegAAAH4AAAAAAAQAOC4wLjQzLTB1YnVudHUwLjI0LjA0LjEAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAEwANAAgAAAAABAAEAAAAYgAEGggAAAAICAgCAAAACgoKKioAEjQA
CigAASmBbsM=
'/*!*/;
# at 126
#260424 10:01:59 server id 1  end_log_pos 157 CRC32 0xce348073 	Previous-GTIDs
# [empty]
# at 157
#260424 10:06:21 server id 1  end_log_pos 236 CRC32 0x6fdd7797 	Anonymous_GTID	last_committed=0	sequence_number=1	rbr_only=yes	original_committed_timestamp=1777017981566837	immediate_commit_timestamp=1777017981566837	transaction_length=1526
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
# original_commit_timestamp=1777017981566837 (2026-04-24 10:06:21.566837 CEST)
# immediate_commit_timestamp=1777017981566837 (2026-04-24 10:06:21.566837 CEST)
/*!80001 SET @@session.original_commit_timestamp=1777017981566837*//*!*/;
/*!80014 SET @@session.original_server_version=80043*//*!*/;
/*!80014 SET @@session.immediate_server_version=80043*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 236
#260424 10:06:21 server id 1  end_log_pos 323 CRC32 0xccc074dd 	Query	thread_id=30	exec_time=0	error_code=0
SET TIMESTAMP=1777017981/*!*/;
SET @@session.pseudo_thread_id=30/*!*/;
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
#260424 10:06:21 server id 1  end_log_pos 416 CRC32 0x07561ea5 	Table_map: `logistica_global`.`almacenes` mapped to number 139
# has_generated_invisible_primary_key=0
# at 416
#260424 10:06:21 server id 1  end_log_pos 1652 CRC32 0x6e8431ad 	Delete_rows: table id 139 flags: STMT_END_F

BINLOG '
fSTraRMBAAAAXQAAAKABAAAAAIsAAAAAAAEAEGxvZ2lzdGljYV9nbG9iYWwACWFsbWFjZW5lcwAI
Aw8PDw8PDw8OyABYApAByADIAMgAkAH+AQEAAgP8/wClHlYH
fSTraSABAAAA1AQAAHQGAAAAAIsAAAAAAAEAAgAI/wABAAAACEFMTS00NTlfDgAgIFN1Y3Vyc2Fs
IDAgIAYATWFkcmlkFDE1MTEgbWV0cm9zIGPDumJpY29zDCszNCAzMjM3Mjc5NQZQUk9QSUEbAExh
dDogNDAuNjQwNCB8IExvbjogLTEuMDQ1MQAZAAAACEFMTS01MjAgDwAgIFN1Y3Vyc2FsIDI0ICAF
AEJhcm5hFDYxOTEgbWV0cm9zIGPDumJpY29zDSszNCA5OTc5NjExNTgLc3ViY29udHJhdGEaAExh
dDogMzguNjMxIHwgTG9uOiAtNC40ODk2ABoAAAAIQUxNLTQwMV8PACAgU3VjdXJzYWwgMjUgIAYA
TWFkcmlkBzI2NjEgbTMNKzM0IDg0NzE5MzgyMAtzdWJjb250cmF0YRsATGF0OiA0MC45MDY1IHwg
TG9uOiAtMC41ODg4CCwAAAAHQUxNLTk2IA8AICBTdWN1cnNhbCA0MyAgBjMyNCBtMw0rMzQgMTAz
MzM2MjQxBlBST1BJQRsATGF0OiAzNy4zNDQ5IHwgTG9uOiAtNi42OTQ1AEIAAAAIQUxNLTEyOSAP
ACAgU3VjdXJzYWwgNjUgIAgAU2V2aWxsYSAUNTE5MCBtZXRyb3MgY8O6Ymljb3MNKzM0IDMwNzMx
NDAxMgtzdWJjb250cmF0YRsATGF0OiA0MC40NzQzIHwgTG9uOiAtMS4zMjk4CGwAAAAIQUxNLTk1
MyAQACAgU3VjdXJzYWwgMTA3ICAHMzgzNiBtMw0rMzQgNTAzNzk4NTYyBlBST1BJQRsATGF0OiAz
Ni4xNzM5IHwgTG9uOiAtOC43MDE4AIsAAAAIQUxNLTIwOCAQACAgU3VjdXJzYWwgMTM4ICAIAFNl
dmlsbGEgFDU4MDMgbWV0cm9zIGPDumJpY29zDSszNCA5NjMzMzAxMzUGUFJPUElBGgBMYXQ6IDM3
LjIxNiB8IExvbjogLTYuOTE1NACeAAAACEFMTS0yMzlfEAAgIFN1Y3Vyc2FsIDE1NyAgBQBCYXJu
YRQ1NDg4IG1ldHJvcyBjw7piaWNvcw0rMzQgNzMwMTYzNzUyC3N1YmNvbnRyYXRhGgBMYXQ6IDM3
LjI0NzggfCBMb246IC02Ljg2MQi0AAAACEFMTS05NTFfEAAgIFN1Y3Vyc2FsIDE3OSAgFDUzODMg
bWV0cm9zIGPDumJpY29zDCszNCA3MDM1NzgyNwtzdWJjb250cmF0YRoATGF0OiA0MC4wNTgzIHwg
TG9uOiAtMi4wNDMAvwAAAAhBTE0tNzk5XxAAICBTdWN1cnNhbCAxOTAgIAUAQmFybmEUMjQzMCBt
ZXRyb3MgY8O6Ymljb3MNKzM0IDY1MzM4NDQ0NwZQUk9QSUEaAExhdDogNDIuNDMwMSB8IExvbjog
Mi4wMjI5AMYAAAAIQUxNLTkwMSAQACAgU3VjdXJzYWwgMTk3ICAFAEJhcm5hEzYxMiBtZXRyb3Mg
Y8O6Ymljb3MNKzM0IDYwMTQ3MjI2OAZQUk9QSUEbAExhdDogNDAuOTg0NiB8IExvbjogLTAuNDU0
OfDOAAAAB0FMTS0wMDELAFN1Y3Vyc2FsICBBBgBNYWRyaWStMYRu
'/*!*/;
# at 1652
#260424 10:06:21 server id 1  end_log_pos 1683 CRC32 0x532130bc 	Xid = 1226165
COMMIT/*!*/;
# at 1683
#260424 10:07:11 server id 1  end_log_pos 1727 CRC32 0x88eda29b 	Rotate to binlog.000323  pos: 4
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
