CREATE SCHEMA IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.ft_ped;
DROP TABLE IF EXISTS dw.dim_cli;
DROP TABLE IF EXISTS dw.dim_vnd;
DROP TABLE IF EXISTS dw.dim_pro;
DROP TABLE IF EXISTS dw.dim_pag;
DROP TABLE IF EXISTS dw.dim_tmp;

CREATE TABLE IF NOT EXISTS dw.dim_tmp (
    sk_tmp INT PRIMARY KEY,
    dat_cmp DATE,
    nr_ano INT,
    nr_mes INT,
    nm_mes VARCHAR(20),
    nr_dia INT,
    nr_tri INT,
    nm_dia_sem VARCHAR(20),
    fl_fds BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_dim_tmp_dat ON dw.dim_tmp(dat_cmp);

CREATE TABLE IF NOT EXISTS dw.dim_cli (
    sk_cli SERIAL PRIMARY KEY,
    nk_id_cli VARCHAR(32),
    nm_cid VARCHAR(100),
    sg_est CHAR(2)
);

CREATE INDEX IF NOT EXISTS idx_dim_cli_nk ON dw.dim_cli(nk_id_cli);

CREATE TABLE IF NOT EXISTS dw.dim_vnd (
    sk_vnd SERIAL PRIMARY KEY,
    nk_id_vnd VARCHAR(32),
    nm_cid VARCHAR(100),
    sg_est CHAR(2)
);

CREATE INDEX IF NOT EXISTS idx_dim_vnd_nk ON dw.dim_vnd(nk_id_vnd);

CREATE TABLE IF NOT EXISTS dw.dim_pro (
    sk_pro SERIAL PRIMARY KEY,
    nk_id_pro VARCHAR(32),
    nm_cat VARCHAR(100)
);

CREATE INDEX IF NOT EXISTS idx_dim_pro_nk ON dw.dim_pro(nk_id_pro);

CREATE TABLE IF NOT EXISTS dw.dim_pag (
    sk_pag SERIAL PRIMARY KEY,
    ds_tip_pag VARCHAR(50),
    nr_par INT
);

CREATE TABLE IF NOT EXISTS dw.ft_ped (
    sk_ped BIGSERIAL PRIMARY KEY,
    sk_cli INT REFERENCES dw.dim_cli(sk_cli),
    sk_vnd INT REFERENCES dw.dim_vnd(sk_vnd),
    sk_pro INT REFERENCES dw.dim_pro(sk_pro),
    sk_tmp INT REFERENCES dw.dim_tmp(sk_tmp),
    sk_pag INT REFERENCES dw.dim_pag(sk_pag),
    nk_id_ped VARCHAR(32),
    vlr_tot NUMERIC(10,2),
    vlr_frt NUMERIC(10,2),
    vlr_itm NUMERIC(10,2),
    qtd_dia_ent INT,
    nr_ava INT,
    fl_atr BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_ft_ped_cli ON dw.ft_ped(sk_cli);
CREATE INDEX IF NOT EXISTS idx_ft_ped_pro ON dw.ft_ped(sk_pro);
CREATE INDEX IF NOT EXISTS idx_ft_ped_tmp ON dw.ft_ped(sk_tmp);