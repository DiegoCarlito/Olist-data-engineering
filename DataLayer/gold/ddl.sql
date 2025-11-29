CREATE SCHEMA IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.fat_ped;
DROP TABLE IF EXISTS dw.dim_cli;
DROP TABLE IF EXISTS dw.dim_vnd;
DROP TABLE IF EXISTS dw.dim_pro;
DROP TABLE IF EXISTS dw.dim_pag;
DROP TABLE IF EXISTS dw.dim_tmp;

CREATE TABLE IF NOT EXISTS dw.dim_tmp (
    srk_tmp INT PRIMARY KEY,
    dat_cmp DATE,
    num_ano INT,
    num_mes INT,
    nom_mes VARCHAR(20),
    num_dia INT,
    num_tri INT,
    nom_dia_sem VARCHAR(20),
    flg_fds BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_dim_tmp_dat ON dw.dim_tmp(dat_cmp);

CREATE TABLE IF NOT EXISTS dw.dim_cli (
    srk_cli SERIAL PRIMARY KEY,
    ntk_idn_cli VARCHAR(32),
    nm_cid VARCHAR(100),
    sig_est CHAR(2)
);

CREATE INDEX IF NOT EXISTS idx_dim_cli_ntk ON dw.dim_cli(ntk_idn_cli);

CREATE TABLE IF NOT EXISTS dw.dim_vnd (
    srk_vnd SERIAL PRIMARY KEY,
    ntk_idn_vnd VARCHAR(32),
    nm_cid VARCHAR(100),
    sig_est CHAR(2)
);

CREATE INDEX IF NOT EXISTS idx_dim_vnd_ntk ON dw.dim_vnd(ntk_idn_vnd);

CREATE TABLE IF NOT EXISTS dw.dim_pro (
    srk_pro SERIAL PRIMARY KEY,
    ntk_idn_pro VARCHAR(32),
    nm_cat VARCHAR(100)
);

CREATE INDEX IF NOT EXISTS idx_dim_pro_ntk ON dw.dim_pro(ntk_idn_pro);

CREATE TABLE IF NOT EXISTS dw.dim_pag (
    srk_pag SERIAL PRIMARY KEY,
    dsc_tip_pag VARCHAR(50),
    num_par INT
);

CREATE TABLE IF NOT EXISTS dw.fat_ped (
    srk_ped BIGSERIAL PRIMARY KEY,
    srk_cli INT REFERENCES dw.dim_cli(srk_cli),
    srk_vnd INT REFERENCES dw.dim_vnd(srk_vnd),
    srk_pro INT REFERENCES dw.dim_pro(srk_pro),
    srk_tmp INT REFERENCES dw.dim_tmp(srk_tmp),
    srk_pag INT REFERENCES dw.dim_pag(srk_pag),
    ntk_idn_ped VARCHAR(32),
    vlr_tot NUMERIC(10,2),
    vlr_frt NUMERIC(10,2),
    vlr_itm NUMERIC(10,2),
    qtd_dia_ent INT,
    num_ava INT,
    flg_atr BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_fat_ped_cli ON dw.fat_ped(srk_cli);
CREATE INDEX IF NOT EXISTS idx_fat_ped_pro ON dw.fat_ped(srk_pro);
CREATE INDEX IF NOT EXISTS idx_fat_ped_tmp ON dw.fat_ped(srk_tmp);