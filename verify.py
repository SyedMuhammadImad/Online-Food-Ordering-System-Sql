"""Run coursework and constraints in an isolated in-memory SQLite database."""
from pathlib import Path
import sqlite3

def verify():
    root=Path(__file__).parent/'sql'
    db=sqlite3.connect(':memory:')
    db.execute('PRAGMA foreign_keys=ON')
    db.executescript((root/'01_schema.sql').read_text(encoding='utf-8'))
    db.executescript((root/'02_sample_data.sql').read_text(encoding='utf-8'))
    assert db.execute('PRAGMA foreign_key_check').fetchall()==[]
    statements=[q for q in (root/'03_queries.sql').read_text(encoding='utf-8').split(';') if q.strip()]
    for q in statements: db.execute(q).fetchall()
    assert len(statements)==10
    for sql in [
      "INSERT INTO Reviews VALUES(99,1,1,6,'example','2026-10-06')",
      "INSERT INTO Order_Items VALUES(99,1,1,0)",
      "INSERT INTO Order_Items VALUES(99,999,1,1)",
      "INSERT INTO Order_Items VALUES(99,1,3,1)",
      "UPDATE Order_Items SET item_id=3 WHERE order_item_id=1",
      "INSERT INTO Payments VALUES(99,1,-1,'Cash','2026-10-06')"
    ]:
        try: db.execute(sql)
        except sqlite3.IntegrityError: pass
        else: raise AssertionError('Invalid data accepted')
    totals=db.execute('SELECT o.order_id,o.total_amount,SUM(i.quantity*m.price) FROM Orders o JOIN Order_Items i USING(order_id) JOIN Menu_Items m USING(item_id) GROUP BY o.order_id').fetchall()
    assert all(abs(expected-actual)<1e-9 for _,expected,actual in totals)
    db.close()
    return {'tables':7,'analytical_queries':10,'negative_constraint_cases':6,'totals_match':True}

if __name__=='__main__': print(verify())
