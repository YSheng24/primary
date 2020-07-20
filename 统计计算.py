import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from scipy.stats import norm
from sklearn import linear_model
import numpy as np
from statsmodels.regression.linear_model import OLS
from sklearn import preprocessing
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import classification_report
from sklearn.tree import export_graphviz
from sklearn.preprocessing import StandardScaler
from sklearn.neural_network import MLPClassifier
from sklearn.neural_network import MLPRegressor
#读入数据
f=r'data/caschool.dta'
data =pd.read_stata(f)
df = pd.DataFrame(data);df

#目标：“如何能有效提高学生成绩”

#箱型图
scr = df[['testscr','read_scr','math_scr']]
scr_describe=scr.describe()
scr_describe.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/jietu/scr_describe.csv')
scr.plot.box(title="testscr and read_scr and math_scr")
plt.grid(linestyle="--", alpha=0.3)
plt.savefig('C:/Users/ASUS/Desktop/统计计算实验课/jietu/scr_box.png')
plt.show()

#Q-Q分布图
stats.probplot(df['testscr'],plot=plt)
plt.ylabel('testscr')
plt.savefig('C:/Users/ASUS/Desktop/统计计算实验课/jietu/testscr_QQ.png')
plt.show()

#直方图
sns.distplot(df['testscr'])
sns.distplot(df['testscr'],fit=norm)
plt.savefig('C:/Users/ASUS/Desktop/统计计算实验课/jietu/testscr_hist.png')
plt.show()

#散点图
plt.figure(figsize=(25,20))
plt.subplot(2,5,1)
plt.scatter(df['enrl_tot'],df['testscr'])
plt.xlabel('enrl_tot')
plt.ylabel('testscr')

plt.subplot(2,5,2)
plt.scatter(df['teachers'],df['testscr'])
plt.xlabel('teachers')
plt.ylabel('testscr')

plt.subplot(2,5,3)
plt.scatter(df['calw_pct'],df['testscr'])
plt.xlabel('calw_pct')
plt.ylabel('testscr')

plt.subplot(2,5,4)
plt.scatter(df['meal_pct'],df['testscr'])
plt.xlabel('meal_pct')
plt.ylabel('testscr')

plt.subplot(2,5,5)
plt.scatter(df['computer'],df['testscr'])
plt.xlabel('computer')
plt.ylabel('testscr')

plt.subplot(2,5,6)
plt.scatter(df['comp_stu'],df['testscr'])
plt.xlabel('comp_stu')
plt.ylabel('testscr')

plt.subplot(2,5,7)
plt.scatter(df['expn_stu'],df['testscr'])
plt.xlabel('expn_stu')
plt.ylabel('testscr')

plt.subplot(2,5,8)
plt.scatter(df['str'],df['testscr'])
plt.xlabel('str')
plt.ylabel('testscr')

plt.subplot(2,5,9)
plt.scatter(df['avginc'],df['testscr'])
plt.xlabel('avginc')
plt.ylabel('testscr')

plt.subplot(2,5,10)
plt.scatter(df['el_pct'],df['testscr'])
plt.xlabel('el_pct')
plt.ylabel('testscr')

plt.savefig('C:/Users/ASUS/Desktop/统计计算实验课/jietu/testscr&factors_scatter.png')
plt.show()


#分kk08,kk06
df_kk08 = df[df['gr_span'] == 'KK-08']
df_kk08.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/kk08.csv')
df_kk06 = df[df['gr_span'] == 'KK-06']
df_kk06.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/kk06.csv')

#数据整理
df_dat = df.drop(['observat','dist_cod','district'],axis=1)
#将gr_span中的KK-08转为1，KK-06转为0
ls1 = df_dat['gr_span']
ls2 = [str(i) for i in ls1]
a = ls2
b = []
for i in range(len(a)):
    s = eval(str(a[i] == 'KK-08'))
    b.append(s)
b1=np.array(b)+0
df_dat['gr_span01'] = b1

df1 = df_dat.groupby(['gr_span'])
df1['testscr'].describe()
df1.describe()
df1.mean()

df1 = df.groupby(['gr_span','county'])
df1.describe()

#01——线性回归模型拟合
reg = linear_model.LinearRegression()
x = pd.DataFrame(df_dat.iloc[:,[2,3,4,5,6,8,9,10,11,12]])
x['cons'] = 1 #加入常数项
y = df_dat['testscr']
regres = OLS(y,x,missing='drop').fit()
regres.summary()

#02--主成分分析
x1 = pd.DataFrame(df_dat.iloc[:,[2,3,4,5,6,8,9,10,11,12]])
x_scaled = preprocessing.scale(x1)
pca = PCA(n_components=3)#相关系数矩阵提取主成分
pca.fit(x_scaled)
pca_components = pd.DataFrame(pca.components_) #主成分系数矩阵
pca_components.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/jietu/成分系数矩阵.csv')
pca.explained_variance_ #特征值
pca.explained_variance_ratio_ #解释方差比
zdf = pd.DataFrame(x_scaled)
zi = pd.DataFrame(pca.transform(x_scaled),columns=['z1','z2','z3'])
Zdf = pd.concat([zdf, zi], axis=1)
Zdf_describe = pd.DataFrame(Zdf.describe())
Zdf_describe.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/jietu/成分矩阵描述.csv')

#03--聚类
kmeans = KMeans(n_clusters=6,random_state=0).fit(zi) #按三个主成分聚6类
y1 = kmeans.labels_
df_dat['class'] = y1
df2 = df_dat.groupby(['class'])
class_describe = pd.DataFrame(df2['testscr'].describe())
class_describe.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/jietu/聚类描述.csv')
kmeans.cluster_centers_ #6类聚类中心
kmeans.predict([zi.iloc[20,:],zi.iloc[100,:]]) #做简单预测
# 创建LDA降维模型，并计算投影矩阵，对X执行降维操作，得到降维后的结果X_r
lda = LinearDiscriminantAnalysis(n_components = 2)
X_r = lda.fit(x1, y1).transform(x1)
target_names = np.array([0,1,2,3,4,5])
colors = ['blanchedalmond','blue','blueviolet' ,'brown','burlywood','coral']
plt.figure()
# 显示降维后的样本
for color, i, target_name in zip(colors, [0,1,2,3,4,5], target_names):
    plt.scatter(X_r[y1 == i, 0], X_r[y1 == i, 1], alpha=.8, color=color,label=target_name)
plt.legend(loc='best', shadow=False, scatterpoints=1)
plt.title('LDA of class result')
plt.savefig('C:/Users/ASUS/Desktop/统计计算实验课/jietu/验证聚类结果.png')
plt.show()

#04--决策树
x1_class = x1
x1_class['class'] = y1
x1_class = x1_class.sort_values(by='class',ascending=True)
x1_class_data = x1_class.iloc[:,0:10]
x1_class_target = x1_class.iloc[:,10]
x1_class_names = np.array([0,1,2,3,4,5])
ct = DecisionTreeClassifier()
ct.fit(x1_class_data,x1_class_target)
ct.max_features_ #纳入了x1的十个指标
ct_import = pd.DataFrame(ct.feature_importances_,columns=['importance'],index=x1_class_data.columns)
ct_import.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/jietu/指标的重要程度.csv')
ct_predict = pd.DataFrame(ct.predict(x1_class_data)[:10]) #预测
ct_predict.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/jietu/预测的分类结果.csv')
print(classification_report(x1_class_target,ct.predict(x1_class_data)))
x1_class_names_str = [str(j) for j in x1_class_names ]
export_graphviz(ct,out_file='C:/Users/ASUS/Desktop/统计计算实验课/jietu/tree.dot',\
                feature_names=np.array(x1_class_data.columns),class_names=x1_class_names_str)

#神经网络
scaler = StandardScaler()
x1zx = scaler.fit_transform(x1_class_data)
clf = MLPClassifier(activation='logistic',hidden_layer_sizes=(5,5),solver='lbfgs',random_state=1)
clf.fit(x1zx,x1_class_target)
clf.coefs_#系数阵
clf.score(x1zx,x1_class_target)#MLP分类预测
clf_pre = pd.DataFrame(clf.predict_proba(x1zx)[:5])
clf_pre.to_csv('C:/Users/ASUS/Desktop/统计计算实验课/jietu/神经网络预测.csv')
clf1 = MLPRegressor(activation='logistic',hidden_layer_sizes=(5,5),solver='lbfgs',random_state=1)
clf1.fit(x1zx,x1_class_target)
clf1.score(x1zx,x1_class_target)#MLP回归决定系数