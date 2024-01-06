import sqlite3
import sys

database_path = sys.argv[1]
print("Initializing database", database_path, "with VACUUM command")
conn = sqlite3.connect(database_path)
conn.execute("VACUUM")
conn.close()
