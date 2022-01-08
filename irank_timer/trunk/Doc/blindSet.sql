DROP TABLE IF EXISTS blind_level;
DROP TABLE IF EXISTS blind_set;
DROP SEQUENCE IF EXISTS blind_set_seq;
DROP SEQUENCE IF EXISTS blind_level_seq;

CREATE SEQUENCE blind_set_seq;
CREATE TABLE blind_set (
    id INTEGER DEFAULT nextval('blind_set_seq') PRIMARY KEY,
    blind_set_name VARCHAR(32),
    has_break BOOLEAN DEFAULT FALSE,
    has_ante BOOLEAN DEFAULT FALSE,
    total_duration INTEGER,
    blind_duration INTEGER,
    levels INTEGER,
    breaks INTEGER,
    players VARCHAR(8),
    chips VARCHAR(32),
    start_stack INTEGER
);

ALTER TABLE blind_set ADD COLUMN stack VARCHAR(8);
ALTER TABLE blind_set ADD COLUMN speed VARCHAR(8);

SELECT chips FROM blind_set ORDER BY ;
SELECT REGEXP_REPLACE(blind_set_name, '^[a-zA-Z]+ [a-zA-Z]+(.*) (.*)( \+ ante)?', '\1') FROM blind_set;
UPDATE blind_set SET stack = REGEXP_REPLACE(blind_set_name, '^([a-zA-Z]+).*', '\1');
UPDATE blind_set SET speed = REGEXP_REPLACE(blind_set_name, '^[a-zA-Z]+ [a-zA-Z]+ ([a-z]*)( (.*)( \+ ante)?)?', '\1');

CREATE SEQUENCE blind_level_seq;
CREATE TABLE blind_level (
    id INTEGER DEFAULT nextval('blind_level_seq') PRIMARY KEY,
    blind_set_id INTEGER,
    level_number INTEGER,
    small_blind INTEGER,
    big_blind INTEGER,
    ante INTEGER,
    is_break BOOLEAN DEFAULT FALSE,
    duration INTEGER,
    elapsed_time INTEGER
);

UPDATE blind_set SET has_break = true WHERE breaks > 0;
UPDATE blind_set SET has_break = (SELECT COUNT(1) FROM blind_level WHERE blind_set_id = blind_set.ID AND is_break) > 0;
UPDATE blind_set SET has_ante = (SELECT COUNT(1) FROM blind_level WHERE blind_set_id = blind_set.ID AND ante > 0) > 0;
UPDATE blind_set SET levels = (SELECT COUNT(1) FROM blind_level WHERE blind_set_id = blind_set.ID AND NOT is_break);
UPDATE blind_set SET breaks = (SELECT COUNT(1) FROM blind_level WHERE blind_set_id = blind_set.ID AND is_break);
UPDATE blind_set SET total_duration = (SELECT SUM(duration) FROM blind_level WHERE blind_set_id = blind_set.ID);








UPDATE blind_level SET duration = duration * 60;

INSERT INTO blind_set(id) (SELECT DISTINCT blind_set_id FROM blind_level);
UPDATE blind_set SET has_break = (SELECT COUNT(1) FROM blind_level WHERE blind_set_id = blind_set.ID AND is_break) > 0;
UPDATE blind_set SET has_ante = (SELECT COUNT(1) FROM blind_level WHERE blind_set_id = blind_set.ID AND ante > 0) > 0;
UPDATE blind_set SET levels = (SELECT COUNT(1) FROM blind_level WHERE blind_set_id = blind_set.ID AND NOT is_break);
UPDATE blind_set SET duration = (SELECT SUM(duration) FROM blind_level WHERE blind_set_id = blind_set.ID);


ALTER TABLE blind_set ADD COLUMN blind_duration INTEGER;
UPDATE blind_set SET blind_duration = (SELECT duration FROM blind_level WHERE blind_set_id = blind_set.ID ORDER BY id LIMIT 1);

ALTER TABLE blind_set ADD COLUMN first_small_blind INTEGER;
UPDATE blind_set SET first_small_blind = (SELECT MIN(small_blind) FROM blind_level WHERE blind_set_id = blind_set.ID AND NOT is_break);

ALTER TABLE blind_set ADD COLUMN last_big_blind INTEGER;
UPDATE blind_set SET last_big_blind = (SELECT MAX(big_blind) FROM blind_level WHERE blind_set_id = blind_set.ID AND NOT is_break);

ALTER TABLE blind_set ADD COLUMN players INTEGER;

SELECT * FROM blind_set ORDER BY id;