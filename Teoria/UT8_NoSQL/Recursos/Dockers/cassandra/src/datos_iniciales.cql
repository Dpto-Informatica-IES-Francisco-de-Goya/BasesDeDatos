CREATE KEYSPACE IF NOT EXISTS globotour WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
USE globotour;
CREATE TABLE IF NOT EXISTS busquedas_por_usuario (
    user_id text,
    search_time timestamp,
    destino text,
    client_ip text,
    PRIMARY KEY (user_id, search_time)
) WITH CLUSTERING ORDER BY (search_time DESC);

INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-20 00:50:33', 'Madrid', '192.168.1.46');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-16 00:37:33', 'Tokio', '192.168.1.151');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_8', '2026-04-17 08:48:33', 'Nueva York', '192.168.1.97');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_3', '2026-04-20 11:03:33', 'Nueva York', '192.168.1.138');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-15 12:42:33', 'Londres', '192.168.1.54');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_4', '2026-04-18 15:05:33', 'París', '192.168.1.109');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_2', '2026-04-13 19:17:33', 'Madrid', '192.168.1.240');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-16 03:31:33', 'Londres', '192.168.1.69');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_9', '2026-04-16 02:34:33', 'Roma', '192.168.1.31');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-14 07:10:33', 'Tokio', '192.168.1.184');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-15 07:29:33', 'Londres', '192.168.1.171');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_4', '2026-04-15 20:55:33', 'Roma', '192.168.1.78');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-16 02:04:33', 'Londres', '192.168.1.132');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-19 18:05:33', 'Madrid', '192.168.1.147');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_10', '2026-04-20 08:35:33', 'Tokio', '192.168.1.23');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_3', '2026-04-14 03:05:33', 'Madrid', '192.168.1.235');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_5', '2026-04-16 21:36:33', 'Madrid', '192.168.1.139');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_9', '2026-04-19 14:44:33', 'Roma', '192.168.1.133');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-14 00:51:33', 'Tokio', '192.168.1.11');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_4', '2026-04-17 22:22:33', 'París', '192.168.1.176');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-19 00:07:33', 'Madrid', '192.168.1.195');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-20 02:48:33', 'Tokio', '192.168.1.122');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-14 06:35:33', 'París', '192.168.1.12');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-16 23:58:33', 'Madrid', '192.168.1.117');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_10', '2026-04-17 15:30:33', 'París', '192.168.1.110');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_9', '2026-04-19 11:59:33', 'Tokio', '192.168.1.129');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_8', '2026-04-18 06:44:33', 'Nueva York', '192.168.1.121');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_2', '2026-04-14 07:43:33', 'Nueva York', '192.168.1.219');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_3', '2026-04-14 19:25:33', 'Madrid', '192.168.1.52');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-19 13:19:33', 'Londres', '192.168.1.179');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_8', '2026-04-18 23:28:33', 'París', '192.168.1.22');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_3', '2026-04-20 02:06:33', 'Tokio', '192.168.1.65');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_8', '2026-04-19 15:29:33', 'Tokio', '192.168.1.130');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-17 05:22:33', 'Madrid', '192.168.1.108');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_2', '2026-04-20 01:16:33', 'Nueva York', '192.168.1.239');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_6', '2026-04-19 18:04:33', 'Nueva York', '192.168.1.107');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_7', '2026-04-18 07:28:33', 'Nueva York', '192.168.1.117');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-18 02:20:33', 'Tokio', '192.168.1.242');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_8', '2026-04-20 09:23:33', 'Madrid', '192.168.1.203');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_4', '2026-04-15 14:54:33', 'Londres', '192.168.1.52');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_10', '2026-04-18 18:25:33', 'Tokio', '192.168.1.37');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_2', '2026-04-17 10:33:33', 'Roma', '192.168.1.107');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_4', '2026-04-14 09:19:33', 'París', '192.168.1.104');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-18 08:34:33', 'Roma', '192.168.1.146');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-20 06:42:33', 'Roma', '192.168.1.73');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_5', '2026-04-16 04:50:33', 'Londres', '192.168.1.4');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_8', '2026-04-18 00:19:33', 'Madrid', '192.168.1.95');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_1', '2026-04-17 17:00:33', 'París', '192.168.1.201');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_4', '2026-04-18 13:12:33', 'Roma', '192.168.1.130');
INSERT INTO busquedas_por_usuario (user_id, search_time, destino, client_ip) VALUES ('user_3', '2026-04-19 23:25:33', 'Roma', '192.168.1.238');
