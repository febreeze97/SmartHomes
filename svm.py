from sklearn.ensemble import RandomForestClassifier
from sklearn import svm
import matplotlib.pyplot as plt
import pandas as pd

#Smoothed = True
Smoothed = False # Better results with unsmoothed data

df = pd.DataFrame()
for i in range(10):
    if not Smoothed:
        df1 = pd.read_csv('Constant/Reformatted/'+ str(i+1) + '.csv')
    else:
        df1 = pd.read_csv('Constant/LowPassFilter/' + str(i + 1) + '.csv')
    # df.append(df1, ignore_index = True)
    frames = [df, df1]
    df = pd.concat(frames, ignore_index=True)

if not Smoothed:
    df2 = pd.read_csv('Constant/Reformatted/freeliving-pub.csv')
else:
    df2 = pd.read_csv('Constant/LowPassFilter/freeliving-pub.csv')

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
