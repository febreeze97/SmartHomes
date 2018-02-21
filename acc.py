import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from sklearn import svm
from sklearn.ensemble import RandomForestClassifier

Smoothed = True
#Smoothed = False

#df = pd.DataFrame()
#if not Smoothed:
#    df2 = pd.read_csv('Reformatted/freeliving-pub.csv')
#else:
#    df2 = pd.read_csv('LowPassFilter/freeliving-pub.csv')
#
#for i in range(10):
#    if not Smoothed:
#        df1 = pd.read_csv('Reformatted/'+ str(i+1) + '.csv')
#    else:
#        df1 = pd.read_csv('LowPassFilter/' + str(i + 1) + '.csv')
#    frames = [df, df1]
#    df = pd.concat(frames, ignore_index=True)
Miss = 'Constant'
#Miss = 'Linear'

#Pre = 'Reformatted'
Pre = 'LowPassFilter' # Better results with smoothed data
#Pre = 'MovingMean'
#Pre = 'MovingMedian'
#Pre = 'MedianAndLowFilter'

df = pd.DataFrame()
for i in range(10):
    df1 = pd.read_csv(Miss+'/'+Pre+'/'+ str(i+1) + '.csv')
    # df.append(df1, ignore_index = True)
    frames = [df, df1]
    df = pd.concat(frames, ignore_index=True)

df2 = pd.read_csv(Miss+'/'+Pre+'/freeliving-pub.csv')
#calculate sperical coordinates for training data    
acc_x = df['AccX'].values
acc_y = df['AccY'].values
acc_z = df['AccZ'].values
sph_r=[]; sph_theta=[]; sph_phi=[]
for i in range(0,len(acc_x)):    
    r = np.sqrt(acc_x[i]**2 + acc_y[i]**2 + acc_z[i]**2)
    theta = np.arctan(acc_z[i]/(np.sqrt(acc_x[i]**2 + acc_y[i]**2)))
    phi = np.arctan(acc_y[i]/acc_x[i])
    sph_r.append(r)
    sph_theta.append(theta)
    sph_phi.append(phi)
    
label = df['Activity'].values
features = np.transpose((np.array(sph_phi),np.array(sph_theta)))
clf = svm.SVC(kernel='rbf', gamma=.1, C=200,probability=True)
#clf = RandomForestClassifier(n_jobs = -1, random_state=0, n_estimators=100)
clf.fit(features, label)


#calculate sperical coordinates for test data    
acc_x_2 = df2['AccX'].values
acc_y_2 = df2['AccY'].values
acc_z_2 = df2['AccZ'].values
sph_r_2=[]; sph_theta_2=[]; sph_phi_2=[]
for i in range(0,len(acc_x_2)):    
    r_2 = np.sqrt(acc_x_2[i]**2 + acc_y_2[i]**2 + acc_z_2[i]**2)
    theta_2 = np.arctan(acc_z_2[i]/(np.sqrt(acc_x_2[i]**2 + acc_y_2[i]**2)))
    phi_2 = np.arctan(acc_y_2[i]/acc_x_2[i])
    sph_r_2.append(r_2)
    sph_theta_2.append(theta_2)
    sph_phi_2.append(phi_2)


features2 = np.transpose((np.array(sph_phi_2),np.array(sph_theta_2)))
prediction = clf.predict(features2)
prob=clf.predict_proba(features2)
Room = df2['Room'].values
error = 0
#for j in range(len(Room)):
#    if Room[j] != Room[j-1] and prediction[j-1] != 2:
#        error+=1
count_a=0;count_b=0;count_c=0      
for k in range(len(label)):
    if prediction[k] == 2:
        if label[k] == prediction[k]:
            count_a+=1
        if label[k] != prediction[k]:
            count_b+=1
    if label[k] == 2:
        count_c+=1
error_2= count_a/count_c
#plotting
colours = ['b','r','g','k']
#colours = ['r','b','r','r']
colour = []; colour2=[]
for i in range(0,len(label)):
    c = colours[label[i]-1]
    colour.append(c) 
for i in range(0, len(prediction)):
    c2 = colours[prediction[i]-1]
    colour2.append(c2)    
var= np.var(sph_r)
sd=var**0.5
x_ax=np.linspace(1,len(sph_r),len(sph_r))
#plt.scatter(x_ax,sph_r,marker=".")  
#plt.xlabel('datapoint');
#plt.ylabel('radial distance (ms$^{-2}$) ')
print(error_2)
#plt.scatter(sph_phi, sph_theta, c=colour)
#plt.scatter(sph_phi_2, sph_theta_2, c=colour2)

#plt.xlabel('polar angle (radians)');
#plt.ylabel('azimuthal angle (radians)')
#
#
##create legend
#lb1=plt.scatter(1.5, 1, c='b', label='sitting')
#lb2=plt.scatter(0.3, 0.3, c='r', label='walking')
#lb3=plt.scatter(0.7, 0.9, c='g', label='lying')
#lb4=plt.scatter(1.2, 0.2, c='k', label='custom')
#plt.legend(handles=[lb1,lb2,lb3,lb4],loc=1,title=r'$\bf{Activity}$')
#lb1.remove();lb2.remove();lb3.remove();lb4.remove()
finaldf = pd.DataFrame(prob)
finaldf.to_csv("activity_4_probs.csv")
#plt.show()