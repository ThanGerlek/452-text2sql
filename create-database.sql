CREATE TABLE IF NOT EXISTS AllDatabases
(
    id   INT UNSIGNED PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Tables
(
    id          INT UNSIGNED PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    database_id INT UNSIGNED NOT NULL,
    num_rows    INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE (name, database_id),
    FOREIGN KEY (database_id) REFERENCES AllDatabases (id)
);

CREATE TABLE IF NOT EXISTS Datatypes
(
    id   INT UNSIGNED PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Columns
(
    id            INT UNSIGNED PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    table_id      INT UNSIGNED NOT NULL,
    datatype_id   INT UNSIGNED NOT NULL,
    not_null      BOOL         NOT NULL DEFAULT FALSE,
    default_value TEXT,
    UNIQUE (name, table_id),
    FOREIGN KEY (datatype_id) REFERENCES Datatypes (id),
    FOREIGN KEY (table_id) REFERENCES Tables (id)
);

CREATE TABLE IF NOT EXISTS ForeignKeys
(
    column_id            INT UNSIGNED NOT NULL,
    references_column_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (column_id) REFERENCES Columns (id),
    FOREIGN KEY (references_column_id) REFERENCES Columns (id)
);

CREATE TABLE IF NOT EXISTS UniqueColumnSets
(
    id         INT UNSIGNED PRIMARY KEY,
    is_primary BOOL NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS UniqueColumnSetEntries
(
    set_id    INT UNSIGNED NOT NULL,
    column_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (set_id) REFERENCES UniqueColumnSets (id),
    FOREIGN KEY (column_id) REFERENCES Columns (id)
);

INSERT INTO AllDatabases (id, name)
VALUES (1, 'DatabaseDatabase');

INSERT INTO Tables (id, database_id, name, num_rows)
VALUES (1, 1, 'AllDatabases', 1);
INSERT INTO Tables (id, database_id, name, num_rows)
VALUES (2, 1, 'Tables', 7);
INSERT INTO Tables (id, database_id, name, num_rows)
VALUES (3, 1, 'Datatypes', 4);
INSERT INTO Tables (id, database_id, name, num_rows)
VALUES (4, 1, 'Columns', 20);
INSERT INTO Tables (id, database_id, name, num_rows)
VALUES (5, 1, 'ForeignKeys', 7);
INSERT INTO Tables (id, database_id, name, num_rows)
VALUES (6, 1, 'UniqueColumnSets', 11);
INSERT INTO Tables (id, database_id, name, num_rows)
VALUES (7, 1, 'UniqueColumnSetEntries', 15);

INSERT INTO Datatypes (id, name) VALUE (1, 'INT UNSIGNED');
INSERT INTO Datatypes (id, name) VALUE (2, 'VARCHAR(100)');
INSERT INTO Datatypes (id, name) VALUE (3, 'BOOL');
INSERT INTO Datatypes (id, name) VALUE (4, 'TEXT');

# AllDatabases
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (11, 1, 'id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (12, 1, 'name', 2, TRUE);

# Tables
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (21, 2, 'id', 1, not_null);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (22, 2, 'name', 2, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (23, 2, 'database_id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null, default_value)
VALUES (24, 2, 'num_rows', 1, TRUE, '0');

# Datatypes
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (31, 3, 'id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (32, 3, 'name', 2, TRUE);

# Columns
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (41, 4, 'id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (42, 4, 'name', 2, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (43, 4, 'table_id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (44, 4, 'datatype_id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null, default_value)
VALUES (45, 4, 'not_null', 3, TRUE, 'FALSE');
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (46, 4, 'default_value', 4, FALSE);

# ForeignKeys
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (51, 5, 'column_id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (52, 5, 'reference_column_id', 1, TRUE);

# UniqueColumnSets
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (61, 6, 'id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null, default_value)
VALUES (62, 6, 'is_primary', 3, TRUE, 'FALSE');

# UniqueColumnSetEntries
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (71, 7, 'set_id', 1, TRUE);
INSERT INTO Columns (id, table_id, name, datatype_id, not_null)
VALUES (72, 7, 'column_id', 1, TRUE);


INSERT INTO ForeignKeys (column_id, references_column_id)
VALUES (23, 11);
INSERT INTO ForeignKeys (column_id, references_column_id)
VALUES (43, 21);
INSERT INTO ForeignKeys (column_id, references_column_id)
VALUES (44, 31);
INSERT INTO ForeignKeys (column_id, references_column_id)
VALUES (51, 41);
INSERT INTO ForeignKeys (column_id, references_column_id)
VALUES (52, 41);
INSERT INTO ForeignKeys (column_id, references_column_id)
VALUES (71, 61);
INSERT INTO ForeignKeys (column_id, references_column_id)
VALUES (72, 41);


# AllDatabases
INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (10, TRUE);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (10, 11);

INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (11, FALSE); # name
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (11, 12);

# Tables
INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (20, TRUE);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (20, 21);

INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (21, FALSE); # name, db_id
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (21, 22);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (21, 23);

# Datatypes
INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (30, TRUE);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (30, 31);

INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (31, FALSE); # name
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (31, 31);

# Columns
INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (40, TRUE);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (40, 41);

INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (41, FALSE); # name, table_id
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (41, 42);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (41, 43);

# ForeignKeys
INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (50, TRUE);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (50, 51);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (50, 52);

# UniqueColumnSets
INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (60, TRUE);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (60, 61);

# UniqueColumnSetEntries
INSERT INTO UniqueColumnSets (id, is_primary)
VALUES (70, TRUE);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (70, 71);
INSERT INTO UniqueColumnSetEntries (set_id, column_id)
VALUES (70, 72);
