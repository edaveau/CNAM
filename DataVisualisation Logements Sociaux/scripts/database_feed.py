import pandas as pd
import numpy as np
import psycopg2
from sqlalchemy import create_engine

engine = create_engine('postgresql+psycopg2://postgres:postgres@localhost:5432/DataVisualisation')

df = pd.read_csv('C:/Users/edaveau/Documents/R/DataVisualisation/Aggregated Data/data_aggregated.csv', sep=',', encoding = 'latin-1').replace(to_replace='null', value=np.NaN)
df.to_sql('raw_data_table', engine, schema='raw_data_schema', if_exists='replace')

#If the above solution doesn't work : Inject directly in postgresql
#COPY persons(first_name,last_name,dob,email) 
#FROM 'C:/Users/edaveau/Documents/R/DataVisualisation/Aggregated Data/data_aggregated.csv' DELIMITER ';' CSV HEADER;
filename = 'C:/Users/edaveau/Documents/R/DataVisualisation/Aggregated Data/data_aggregated.csv'
chunksize = 10 ** 6
for chunk in pd.read_csv(filename, chunksize=chunksize, sep = ",", encoding = "latin-1"):
    chunk.to_sql('raw_data_table', engine, schema='public', if_exists='append')
	