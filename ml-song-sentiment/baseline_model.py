"""
Given a sentiment score (from an entry), a csv of songs that the user has listened to, and the number of songs to return, returns a list of songs that have the closest valence to the given sentiment score.
"""

import argparse
import csv
import numpy as np
import pandas as pd

from bisect import bisect_left

def score(string):
    value = float(string)
    if value < 0 or value > 1:
        msg = "%r is not in the range 0 to 1" % string
        raise argparse.ArgumentTypeError(msg)
    return value

def parse_args():
   parser = argparse.ArgumentParser()
   parser.add_argument('sentiment', help='file name pointing to csv where training data is stored', type=score)
   parser.add_argument('song_csv', help='file name pointing to csv where songs are stored', type=str)
   parser.add_argument('length', help='number of songs to return', type=int)
   args = parser.parse_args()
   return args.sentiment, args.song_csv, args.length

def sort_songs(filename, sentiment):
    df = pd.read_csv(filename)
    df['valence_diff'] = abs(df['valence'] - sentiment)
    df = df.sort_values(by=['valence_diff'])
    df = df.reset_index(drop=True)
    return df

def closest_songs(songs_df, length):
    songs = []
    for i in range(length):
        songs.append(songs_df.loc[[i]])
    return songs

def main():
    sentiment, song_csv, length = parse_args()
    songs_df = sort_songs(song_csv, sentiment)
    songs = closest_songs(songs_df, length)

main()
