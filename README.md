--Books ETL Project--

    This project contains a simple ETL pipeline for processing book data and storing it in a PostgreSQL database.

--Features--

    Loads new book records from a database for a specified date.
    Transforms the data (price rounding, categorization).
    Inserts the transformed data back into a processed table.
    Handles empty datasets and errors.


--Setup--

    1. Python Environment
    # Create a virtual environment with Python 3.10.6
    python -m venv venv

    # Activate the virtual environment

    2. Install Dependencies
    pip install -r requirements.txt

    3. Database Setup

    Create a PostgreSQL database with provided migration file(migrations/books_schema.sql) to create schema and insert sample data:

    Create a .env file (based on .env_sample) and fill in your database credentials:

    DB_HOST=localhost
    DB_PORT=5432
    DB_NAME=task
    DB_USER=your_user
    DB_PASSWORD=your_password


--Usage--

    Run the ETL script with a date argument in YYYY-MM-DD format:

    python books_etl.py 2025-01-01


    Or, configure the run parameters in PyCharm and pass the date as a script argument.


--Example Output--:

    Підключено до бази даних успішно
    Витягнуто 6 записів з таблиці books
    Трансформовано 6 записів
    Збережено 6 записів в books_processed
    ETL процес завершено успішно
