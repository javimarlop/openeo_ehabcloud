

df = read.table('efas.csv',sep=',',header=T)
df2<-scale(df)

# factoextra
# https://rpkgs.datanovia.com/factoextra/index.html

library(factoextra)


set.seed(123)


optcl_gap<-fviz_nbclust(df2, kmeans, nstart = 25,  method = "gap_stat", k.max=50, nboot = 50)+ labs(subtitle = "Gap statistic method") # 12 classes

reskm12<-kmeans(df2,12,iter.max=100)







