
from sklearn.ensemble import RandomForestClassifier
from sklearn import svm
import matplotlib.pyplot as plt
import pandas as pd

df = pd.DataFrame()
for i in range(10):
    # df1 = pd.read_csv('Training-Reformated/'+ str(i+1) + '.csv')
    df1 = pd.read_csv('LowPassFiltered0.1Hz/' + str(i + 1) + '.csv')
    # df.append(df1, ignore_index = True)
    frames = [df, df1]
    df = pd.concat(frames, ignore_index=True)

# df2 = pd.read_csv('Test-Reformatted/freeliving-pub.csv')
df2 = pd.read_csv('LowPassFiltered0.1Hz/freeliving-pub.csv')

clf = svm.SVC()

#clf = RandomForestClassifier(n_jobs = -1, random_state=0, n_estimators=100)
y = df['Room'].values
features = df.columns[:4]
clf.fit(df[features], y)
print(features)
# print(df2.columns[:4])
prediction = clf.predict(df2[features])
print(prediction)
fig = plt.figure()
# plt.plot(clf.predict(df2[features]))
# plt.plot(df2['Room'])
plt.plot(clf.predict(df2[features])-df2['Room'])
plt.show()

c = 0
for i in range(len(prediction)):
 if prediction[i] == df2['Room'][i]:
     c+=1

print((c/len(prediction))*100)
print(c)
# finaldf = pd.DataFrame(clf.predict(df2[features]))
# finaldf.to_csv("Random_Forest_Data.csv")