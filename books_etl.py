import os
import sys
import pandas as pd
from datetime import datetime
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine
from sqlalchemy.exc import SQLAlchemyError


def connect_to_db() -> Engine:
    """
    Create a SQLAlchemy engine to connect to the PostgreSQL database using
    environment variables for credentials.

    :raises ValueError: If any required environment variable is missing.
    :raises RuntimeError: If connection to the database fails.
    :return: SQLAlchemy Engine instance
    """
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT", "5432")
    dbname = os.getenv("DB_NAME")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")

    if not all([host, port, dbname, user, password]):
        raise ValueError("Missing required environment variables")

    db_url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{dbname}"

    try:
        engine = create_engine(db_url)
        with engine.connect() as conn:
            pass
        return engine
    except SQLAlchemyError as e:
        raise RuntimeError(f"Could not connect to database: {e}")


def extract_books(engine: Engine, cutoff_date: str) -> pd.DataFrame:
    """
    Extract books from the database updated on or after cutoff_date.

    :param cutoff_date: Cutoff date string in format 'YYYY-MM-DD'
    :param engine: SQLAlchemy Engine object
    :return: DataFrame containing the selected books
    """
    query = text("""
        SELECT book_id, title, price, genre, stock_quantity, last_updated
        FROM books
        WHERE last_updated >= :cutoff
    """)
    try:
        df = pd.read_sql(query, engine, params={"cutoff": cutoff_date})
        print(f"Витягнуто {len(df)} записів з таблиці books")
        return df
    except SQLAlchemyError as e:
        raise RuntimeError(f"Error extracting books: {e}")


def transform_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Transform the raw book data according to business rules.

    :param df: Raw books DataFrame
    :return: Transformed DataFrame
    """
    df = df.copy()
    df["original_price"] = df["price"]
    df["rounded_price"] = df["price"].round(1)
    df["price_category"] = df["rounded_price"].lt(500).map(
        {True: "budget", False: "premium"}
    )
    df = df.drop(columns=["price"])
    print(f"Трансформовано {len(df)} записів")
    return df


def load_data(df: pd.DataFrame, engine: Engine) -> None:
    """
    Load the transformed DataFrame into the 'books_processed' table.

    :param df: Transformed books DataFrame
    :param engine: SQLAlchemy Engine object
    """
    from sqlalchemy import inspect

    inspector = inspect(engine)
    table_columns = [col["name"] for col in inspector.get_columns("books_processed")]
    df_to_load = df[[c for c in table_columns if c in df.columns]]

    df_to_load.to_sql(
        "books_processed",
        engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi"
    )
    print(f"Збережено {len(df_to_load)} записів в books_processed")


def main() -> None:
    """
    Main ETL process:
      1. Load environment variables.
      2. Validate command line arguments.
      3. Connect to the database.
      4. Extract, transform, and load book data.
      5. Handle empty results and errors gracefully.
    """
    load_dotenv()
    if len(sys.argv) != 2:
        print("Використання: python books_etl.py YYYY-MM-DD")
        print("Приклад: python books_etl.py 2025-01-01")
        sys.exit(1)

    cutoff_date = sys.argv[1]
    try:
        datetime.strptime(cutoff_date, "%Y-%m-%d")
    except ValueError:
        print(f"Помилка: невірний формат дати '{cutoff_date}'. Очікується YYYY-MM-DD")
        sys.exit(1)

    try:
        engine = connect_to_db()
        print("Підключено до бази даних успішно")

        df_raw = extract_books(engine, cutoff_date)
        if df_raw.empty:
            print("Нових книг для обробки за вказану дату не знайдено. Роботу завершено.")
            return
        df_transformed = transform_data(df_raw)
        load_data(df_transformed, engine)

        print("ETL процес завершено успішно")

    except Exception as e:
        print(f"Помилка виконання ETL: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
