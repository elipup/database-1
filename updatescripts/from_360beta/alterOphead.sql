ALTER TABLE ophead ADD COLUMN ophead_cntct_id INTEGER REFERENCES cntct (cntct_id);