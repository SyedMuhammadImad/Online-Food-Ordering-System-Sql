# Online food ordering SQL coursework

Seven related tables, connected fictional sample records, and ten analytical queries. Login passwords were removed; this schema does not implement authentication. The scripts target SQLite and check foreign keys, required relationships, numeric ranges and restaurant/item consistency.

Run `python verify.py` to create and test an isolated in-memory database. No existing database is opened. The schema script resets tables, so use it only for disposable coursework databases. See `VERIFICATION.json` for checks.
