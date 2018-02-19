from sklearn.ensemble import RandomForestClassifier
import matplotlib.pyplot as plt
import pandas as pd

Miss = 'Constant'
Pre = 'Reformatted'
Pre = 'LowPassFilter' # Better results with smoothed data

df = pd.DataFrame()
for i in range(9):
    df1 = pd.read_csv(Miss+'/'+Pre+'/'+ str(i+1) + '.csv')
    # df.append(df1, ignore_index = True)
    frames = [df, df1]
    df = pd.concat(frames, ignore_index=True)

df2 = pd.read_csv(Miss+'/'+Pre+'/freeliving-pub.csv')

clf = RandomForestClassifier(n_jobs = -1, random_state=0, n_estimators=100)
y = df['Room'].values
features = df.columns[:4]
clf.fit(df[features], y)
# print(features)
# print(df2.columns[:4])
prediction = clf.predict(df2[features])
fig = plt.figure()
# plt.plot(clf.predict(df2[features]))
# plt.plot(df2['Room'])
plt.plot(clf.predict(df2[features])-df2['Room'])
clf.predict_proba(df2[features])
plt.show()

"""c = 0
for i in range(len(prediction)):
 # if prediction[i] == df2['Room'][i]:
 #     c+=1
 if df['Room'][i] == 4:
     if df['Room'][i-1] == 2:
         print('yeeeet')"""

Mat = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
Size = [0,0,0,0]

for i in range(len(prediction)):
    Mat[df2['Room'][i]-1][prediction[i]-1] += 1
    Size[df2['Room'][i]-1] += 1

for r in range(len(Mat)):
    for c in range(len(Mat[r])):
        Mat[r][c] = Mat[r][c]/Size[r]

right = 0;
for i in range(len(Mat)):
    right += int( Mat[i][i] * Size[i] )
    """count = 0
    for elem in row:
        count += elem
    print(count)"""
    print(Mat[i])

right = right/len(prediction)

print(right)
#print(Size)

"""print((c/len(prediction))*100)
print(c)
# finaldf = pd.DataFrame(clf.predict(df2[features]))
# finaldf.to_csv("Random_Forest_Data.csv")"""
