# Super Naive Text-to-SQL Engine

Built for BYU's CS 452 course.

### The Database

Purpose: to store database schemas. (It's a database database. Why not.)

![alt-text](./ERD-no-RU.png)

### Text-to-SQL

#### Example queries

Successful:

```
>>> For each table, list the datatypes that are not used by that table.
Executing SQL: SELECT name FROM Datatypes;
Executing SQL: SELECT table_id, datatype_id FROM Columns;
The datatypes not used by each table are as follows:

1. **Tables**: TEXT, VARCHAR(100)
2. **Datatypes**: INT UNSIGNED, TEXT, VARCHAR(100)
3. **Columns**: INT UNSIGNED, TEXT, VARCHAR(100)
4. **ForeignKeys**: TEXT, VARCHAR(100)
5. **UniqueColumnSets**: INT UNSIGNED, TEXT, VARCHAR(100)
6. **UniqueColumnSetEntries**: INT UNSIGNED, TEXT, VARCHAR(100)
>>> 
```

Somewhat less successful:

```
>>> How many foreign keys are in the Tables and Columns tables?
Executing SQL: SELECT COUNT(*) AS foreign_key_count FROM ForeignKeys;
Executing SQL: SELECT COUNT(*) AS foreign_key_count FROM Columns WHERE table_id IN (SELECT id FROM Tables);
There are 7 foreign keys in the ForeignKeys table, and 20 foreign keys related to the Columns table that are associated with the Tables.
```

See below for other examples.

#### Prompting Strategies

TODO: Describe which prompting strategies you tried and if you noticed a difference between them.