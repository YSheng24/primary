data = data.frame(read.csv("C:/Users/ASUS/Desktop/应用多元统计/data.csv",header = T))
data
#主成分分析
data_std= scale(data[,1:10]) #数据标准化

df = as.data.frame(data_std)
class(df)

#标准误，方差贡献率和累计贡献率
arrests.pr = prcomp(df,scale = TRUE)
summary(arrests.pr)


#每个变量的标准误和变换矩阵
prcomp(df,scale = TRUE)

#查看对象arests.pr中的内容
str(arrests.pr)

#利用主成分的标准误计算出主成分的累计方差比列
cumsum(arrests.pr$sdev^2)/10

#各个成分占主成分的得分
arrests.pr$x

#数据拆分结果图形表示
screeplot(arrests.pr,main="df")
biplot(arrests.pr)

#按第一主成分排序的结果
data.frame(sort(arrests.pr$x[,1]))

#主因子分析-计算数据的相关系数矩阵
df.cor = cor(df)
t = as.data.frame(df.cor)
write.table(t,"C:/Users/ASUS/Desktop/应用多元统计/t1.csv",row.names=FALSE,col.names=TRUE,sep=",")


#计算特征值和特征向量及因子贡献率和累计贡献率
df.eigen<-eigen(df.cor)
df.eigen

#根据主成分分析结果确定公共因子个数
df.pr<- princomp(df, cor=T)
summary(df.pr)

#均值
df.pr$center

#标准误
df.pr$scale

#特征值的平方根乘以相应的特征向量得到因子载荷矩阵.并且只显示前4个因子的结果
t(sqrt(df.eigen$values) *t(df.eigen$vectors))[,1:3]
df.fa<-factanal(df,factors = 3)
print(df.fa, cutoff=0.001)

#回归方法(regression)计算因子得分并作图，然后对样本进行分类
df.fa<-factanal(df,factors = 3, scores = "regression")
s = data.frame(df.fa$scores)
frame = cbind(s,data[,12])
#回归分析

lm<-lm(data[,12]~Factor1+Factor2+Factor3,frame)
lm
summary(lm)

ds = kmeans(frame[,c(1,2,3)],centers = 6)

str(ds)
ds$cluster

A = cbind(data[,12],ds$cluster)
A = A[order(A[,2],decreasing=F),]
colnames(A) = c('testscr','class')
aggregate(A[,1],list(A[,2]),mean)



