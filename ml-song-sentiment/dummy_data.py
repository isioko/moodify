import csv
import numpy as np
import random

TRAIN_CSV_FILE = "spotify-audio-features/train_set.csv"
NUM_ROWS = 50
FIELD_NAMES = ['acousticness', 'danceability', 'energy', 'instrumentalness', 'speechiness', 'valence', 'sentiment']

def get_dummy_row():
    dummy_row = {}
    acousticness = random.random()
    danceability = random.random()
    energy = random.random()
    instrumentalness = random.random()
    speechiness = random.random()
    valence = random.random()
    danceability = 0.2*energy + 0.8*danceability
    valence = min(acousticness, instrumentalness, speechiness)*0.3 + np.mean([danceability, energy, valence])*0.7
    sentiment = random.random()*0.2 + np.mean([danceability, energy, valence])*0.6 + (np.mean([acousticness, instrumentalness, speechiness]))*0.2
    dummy_row['acousticness'] = acousticness
    dummy_row['danceability'] = danceability
    dummy_row['energy'] = energy
    dummy_row['instrumentalness'] = instrumentalness
    dummy_row['speechiness'] = speechiness
    dummy_row['valence'] = valence
    dummy_row['sentiment'] = sentiment
    return dummy_row

def write_to_csv(dummy_rows):
    with open(TRAIN_CSV_FILE, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=FIELD_NAMES)
        writer.writeheader()
        for entry in dummy_rows:
            writer.writerow(entry)

def main():
    dummy_rows = []
    for i in range(NUM_ROWS):
        dummy_rows.append(get_dummy_row())
    write_to_csv(dummy_rows)

main()
