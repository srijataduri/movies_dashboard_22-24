# Movies IMDb Dataset Project

This is a project that sets up a relational database for IMDb movie data, runs some SQL queries for analytics, and serves it all up in a simple Flask dashboard.

## What This Does
We pull in IMDb data (movies, genres, directors, etc.), store it in MySQL, and use SQL for insights like top-rated films or genre trends. The Flask app gives you a dashboard with charts and tables to visualize things.

## Understand The Data

[Open in Colab](https://colab.research.google.com/drive/1-R6gFW4jzN6tqRfCsbaHk23vLf59FMdU?usp=sharing)

## Setup

### Database
First, get the database going. Open MySQL and run the `db.sql` script. That'll create the database, tables, and load the data from the CSV files (assuming they're in `~/Desktop/movies_dashboard_22_24/data/`).

Second, run `queries.sql` script.run to verify that the database has been successfully loaded and create an index for faster data retrieval.

### Python Environment
To run the Flask app:

1. Create a virtual environment:  
   ```bash
   python3 -m venv .venv
   ```

2. Activate it:  
   
- On macOS or Linux:  
     ```bash
     source .venv/bin/activate
     ```  
   
- On Windows:  
     ```cmd
     .venv\Scripts\activate.bat
     ```

3. Install the dependencies:  
   ```bash
   pip install -r requirements.txt
   ```

4. Start the app:  
   ```bash
   python3 app.py
   ```