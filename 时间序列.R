library(tseries)
data = read.csv('C:/Users/ASUS/Desktop/应用时间序列/data.csv',header = T)
str(data)
zt = ts(matrix(data[,2],ncol=1),start = c(1949,1),frequency = 12)

#(1)判断平稳性：画时序图和样本自相关函数图
plot(zt,xlab="year",ylab="passengers",type="l")#时序图
abline(reg = lm(zt~time(zt)))
acf(zt,lag.max = NULL, type = c("correlation", "covariance", "partial")[1], plot = TRUE)#自相关函数图
adf.test(zt)

#(2)缩小范围对数化
zt_log = ts(matrix(log(data[,2]),ncol=1),start = c(1949,1),frequency = 12)
plot(zt_log,xlab="time",ylab="passenger",type="l")
acf(zt_log,lag.max = NULL, type = c("correlation", "covariance", "partial")[1], plot = TRUE)#自相关函数图

#(3)差分
plot(diff(zt_log),xlab="time",ylab="passenger",type="l")
acf(diff(zt_log),lag.max = NULL,type = c("correlation", "covariance", "partial")[1], plot = TRUE)#自相关函数图
pacf(diff(zt_log))
adf.test(diff(zt_log))

#模型1——AR模型(ARIMA(2,1,0))
m1 = arima(zt_log,order=c(2, 1, 0),seasonal = list(order = c(0,1,0),period = 12),include.mean = TRUE,method = "CSS-ML")
confint(m1)#系数显著性检验
#残差正态性检验
qqnorm(m1$residuals);qqline(m1$residuals)#qq图
#残差白噪声检验
Box.test(m1$residuals,type="Ljung-Box")#LB检验


#模型2——MA模型(ARIMA(0,1,2))
m2 = arima(zt_log, order=c(0, 1, 2),seasonal = list(order = c(0,1,0),period = 12),include.mean = TRUE,method = "CSS-ML") 
confint(m2)#系数显著性检验
#残差正态性检验
qqnorm(m2$residuals);qqline(m2$residuals)#qq图
#残差白噪声检验
Box.test(m2$residuals,type="Ljung-Box")#LB检验

#模型3——ARIMA模型(ARIMA(2,1,2))
m3 = arima(zt_log, order=c(2, 1, 1),seasonal = list(order = c(0,1,0),period = 12),include.mean = TRUE,method = "CSS-ML") 
confint(m3)#系数显著性检验
#残差正态性检验
qqnorm(m3$residuals);qqline(m3$residuals)#qq图
#残差白噪声检验
Box.test(m3$residuals,type="Ljung-Box")#LB检验

#预测
pred = predict(m3,10*12)
pred
plot(pred$pred,xlab="year",ylab="passengers",type="l")#时序图
str(pred)
se = pdata


#预测图加原图
b = data.frame(rbind(zt_log,se))
temp1 <- seq.Date(from = as.Date("1949/01/01",format = "%Y/%m/%d"), by = "month", length.out = 264)
rownames(b)= temp1
zt1 = ts(matrix(a[,1],ncol=1),start = c(1949,1),frequency = 12)
plot(zt1,xlab="year",ylab="passengers",type="l")#时序图


#Holt_Winters指数平滑及预测
gdp.hw<-HoltWinters(zt_log,seasonal="multi")
plot(gdp.hw$fitted,type="o",main="分解图")
plot(gdp.hw,type="o")
pdata<-predict(gdp.hw,n.ahead=10*12)
pdata
plot(pdata,xlab="year",ylab="passengers",type="l")#时序图

a = data.frame(rbind(zt_log,pdata))
zt2 = ts(matrix(a[,1],ncol=1),start = c(1949,1),frequency = 12)
plot(zt2,xlab="year",ylab="passengers",type="l")#时序图
