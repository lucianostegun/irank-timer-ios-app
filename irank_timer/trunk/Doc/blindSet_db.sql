CREATE TABLE blind_set (
    id INTEGER PRIMARY KEY,
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

CREATE TABLE blind_level (
    id INTEGER PRIMARY KEY,
    blind_set_id INTEGER,
    level_number INTEGER,
    small_blind INTEGER,
    big_blind INTEGER,
    ante INTEGER,
    is_break BOOLEAN DEFAULT FALSE,
    duration INTEGER,
    elapsed_time INTEGER
);
