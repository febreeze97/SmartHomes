from sklearn.ensemble import RandomForestClassifier
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
Miss = 'Constant'
#Miss = 'Linear'

#Pre = 'Reformatted'
#Pre = 'LowPassFilter' # Better results with smoothed data
Pre = 'MovingMedian'
#Pre = 'MovingMean'
#Pre = 'MedianAndLowFilter'
df = pd.DataFrame()
for i in range(0,9):
    df1 = pd.read_csv(Miss+'/'+Pre+'/'+ str(i+1) + '.csv')
    # df.append(df1, ignore_index = True)
    frames = [df, df1]
    df = pd.concat(frames, ignore_index=True)



df2 = pd.read_csv(Miss+'/'+Pre+'/freeliving-pub.csv')

clf = RandomForestClassifier(n_jobs = -1, random_state=0, n_estimators=100)
y = df['Room'].values
headings = df.columns[:4]

#TRAINING
sort_df = np.sort(df[headings].values)[:,2:4]
diff = (sort_df[:,1] - sort_df[:,0])#calculate difference between first and second RSSI value
#for i in range(len(diff)):
#    if diff[i]<7:
#        diff[i]=10
#    else:
#        diff[i]=100
    
features = np.array(df)[0:,0:5]
features[0:,4]=diff
#TEST
sort_df2 = np.sort(df2[headings].values)[:,2:4]
diff2 = (sort_df2[:,1] -  sort_df2[:,0])
features2 = np.array(df2)[0:,0:5]
features2[0:,4]=diff2
y2=df2['Room'].values

clf.fit(features, y)
# print(features)
# print(df2.columns[:4])
prediction = clf.predict(features2)
fig = plt.figure()
# plt.plot(clf.predict(df2[features]))
# plt.plot(df2['Room'])
plt.plot(prediction-df2['Room'])
prob=clf.predict_proba(features2)
score=clf.score(features2, y2)
#print(prob)

labels=df2['Room']
plt.show()



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

right = right/len(prediction)*100
print('score = ', score)
print('success = ', right)
#print(Size)

"""print((c/len(prediction))*100)
print(c)
# finaldf = pd.DataFrame(clf.predict(df2[features]))
# finaldf.to_csv("Random_Forest_Data.csv")"""
