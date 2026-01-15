"""
Quick MongoDB Connection Test
Run this to verify your database is connected properly
"""

from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, ServerSelectionTimeoutError
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

MONGODB_URI = os.getenv('MONGODB_URI', 'mongodb://localhost:27017/')
MONGODB_DB = os.getenv('MONGODB_DB', 'Mental_Platform_db')

print("=" * 60)
print("MindScope AI - MongoDB Connection Test")
print("=" * 60)

print(f"\nTrying to connect to:")
print(f"  URI: {MONGODB_URI}")
print(f"  Database: {MONGODB_DB}")

try:
    # Connect
    client = MongoClient(
        MONGODB_URI,
        serverSelectionTimeoutMS=5000,
        connectTimeoutMS=5000
    )

    # Ping
    client.admin.command('ping')
    print("\n✅ Successfully connected to MongoDB!")

    # Get database
    db = client[MONGODB_DB]
    print(f"✅ Database '{MONGODB_DB}' is accessible")

    # List collections
    collections = db.list_collection_names()
    print(f"\n📂 Existing collections in '{MONGODB_DB}':")
    if collections:
        for coll in collections:
            count = db[coll].count_documents({})
            print(f"  - {coll} ({count} documents)")
    else:
        print("  (No collections yet - they'll be created on first analysis)")

    # Test write operation
    print(f"\n🧪 Testing write operation...")
    test_collection = db['test_connection']
    result = test_collection.insert_one({'test': 'connection', 'status': 'success'})
    print(f"✅ Write successful! Inserted ID: {result.inserted_id}")

    # Clean up test
    test_collection.delete_one({'_id': result.inserted_id})
    print(f"✅ Cleanup successful!")

    print("\n" + "=" * 60)
    print("✅ MongoDB is ready for MindScope AI!")
    print("=" * 60)
    print("\nYou can now run:")
    print("  - run_backend.bat (to start Flask API)")
    print("  - run_frontend.bat (to start Streamlit UI)")

except ConnectionFailure as e:
    print(f"\n❌ Connection failed: {e}")
    print("\nTroubleshooting:")
    print("  1. Make sure MongoDB is running:")
    print("     Windows: net start MongoDB")
    print("  2. Check if MongoDB is on port 27017:")
    print("     netstat -an | findstr :27017")
    print("  3. Try starting MongoDB manually:")
    print("     mongod --dbpath C:\\data\\db")

except ServerSelectionTimeoutError as e:
    print(f"\n❌ Server selection timeout: {e}")
    print("\nMongoDB might not be running or not accessible.")
    print("Start MongoDB and try again.")

except Exception as e:
    print(f"\n❌ Unexpected error: {e}")

finally:
    if 'client' in locals():
        client.close()
        print("\n🔌 Connection closed.")
