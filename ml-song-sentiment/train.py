import argparse
import csv
import numpy as np
import pandas as pd

from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

def parse_args():
   parser = argparse.ArgumentParser()
   parser.add_argument('training', help='file name pointing to csv where training data is stored', type=str)
   parser.add_argument('testing', help='file name pointing to csv where testing data is stored', type=str)
   args = parser.parse_args()
   return args.training, args.testing

def parse_train(filename):
    dataset = pd.read_csv(filename)
    x_dataset = dataset.drop(['sentiment'], axis=1)
    y_dataset = dataset['sentiment']
    return x_dataset, y_dataset

def parse_test(filename):
    dataset = pd.read_csv(filename)
    x_dataset = dataset.drop(['artist_name', 'track_id', 'track_name', 'duration_ms', 'key', 'mode', 'liveness', 'loudness', 'tempo', 'time_signature', 'popularity', 'sentiment'], axis=1)
    y_dataset = dataset['sentiment']
    return x_dataset, y_dataset

def train_and_predict_linear(x_train, y_train, x_test):
    regressor = LinearRegression(fit_intercept=False)
    regressor.fit(x_train, y_train)
    y_pred_train = regressor.predict(x_train)
    y_pred_test = regressor.predict(x_test)
    return y_pred_train, y_pred_test

def main():
    train_file, test_file = parse_args()
    x_train, y_train = parse_train(train_file)
    x_test, y_test = parse_test(test_file)
    y_pred_train, y_pred_test = train_and_predict_linear(x_train, y_train, x_test)
    rms_train = np.sqrt(mean_squared_error(y_train, y_pred_train))
    print('The RMSE of the training set is: ' + rms_train.astype(str))
    rms_test = np.sqrt(mean_squared_error(y_test, y_pred_test))
    print('The RMSE of the training set is: ' + rms_test.astype(str))

main()
