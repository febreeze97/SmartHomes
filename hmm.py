from hmmlearn import hmm
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

df = pd.DataFrame()
for i in range(10):
    # df1 = pd.read_csv('Training-Reformated/'+ str(i+1) + '.csv')
    df1 = pd.read_csv('LowPassFiltered0.1Hz/' + str(i + 1) + '.csv')
    # df.append(df1, ignore_index = True)
    frames = [df, df1]
    df = pd.concat(frames, ignore_index=True)

df2 = pd.read_csv('LowPassFiltered0.1Hz/freeliving-pub.csv')

# startprob = np.array([0.25, 0.25, 0.25, 0.25])
# transmat = np.array([[0.7, 0.15, 0, 0.15], [0.2, 0.5, 0, 0.3], [0, 0, 0.8, 0.2], [0.3, 0.3, 0.3, 0.1]])
# model = hmm.GaussianHMM(n_components=4, covariance_type="diag")

sensor = df[['Sensor 1', 'Sensor 2', 'Sensor 3', 'Sensor 4']].values
vals = df['Room'].values

# sensor = np.matrix(sensor)
#data = data[:, 1]


means = np.array([[np.mean(sensor[:, 0])], [np.mean(sensor[:, 1])], [np.mean(sensor[:, 2])], [np.mean(sensor[:, 3])]])

# model.startprob_ = startprob
# model.transmat_ = transmat
# model.means_ = means
# model.covars_ = np.squeeze(np.cov(sensor))
#
# X, Z = model.sample(500)

X = np.column_stack([sensor, vals])
model = hmm.GaussianHMM(n_components=4, covariance_type="diag", n_iter=1000).fit(X)
hidden_states = model.predict(X)

print(model.transmat_)