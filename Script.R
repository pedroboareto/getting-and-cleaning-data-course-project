##########################Coleta de dados#######################################
dados <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url, destfile = "data.zip")
unzip("data.zip")
#############################leituras############################################
#leitura das tabelas
atividades <- read.table("./UCI HAR Dataset/activity_labels.txt")
caracteristicas <- read.table("./UCI HAR Dataset/features.txt")  

#leitura das tabelas de teste
teste_objetivo <- read.table("./UCI HAR Dataset/test/subject_test.txt")
teste_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
teste_y <- read.table("./UCI HAR Dataset/test/y_test.txt")

#leitura das tabelas de treino
treino_objetivo <- read.table("./UCI HAR Dataset/train/subject_train.txt")
treino_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
treino_y <- read.table("./UCI HAR Dataset/train/y_train.txt")

##############ETAPA 1. Combinar tabelas de treino e de teste####################
teste  <- cbind(teste_objetivo, teste_y, teste_x)
traino <- cbind(treino_objetivo, treino_y, treino_x)
completo <- rbind(teste, traino)

##############ETAPA 2. Extração de da estatistica descritiva####################
metadados <- c("subject", "activity", as.character(caracteristicas$V2))
medias <- grep("subject|activity|[Mm]ean|std", metadados, value = FALSE)
reduzido <- fullSet[ ,medias]

names(atividades) <- c("activityNumber", "activityName")
reduzido$V1.1 <- atividades$activityName[reduzido$V1.1]
##########ETAPA 3. Correção de nomes############################################
NomesReduzidos <- metadados[medias] 
NomesReduzidos <- gsub("mean", "Mean", NomesReduzidos)
NomesReduzidos <- gsub("std", "Std", NomesReduzidos)
NomesReduzidos <- gsub("gravity", "Gravity", NomesReduzidos)
NomesReduzidos <- gsub("[[:punct:]]", "", NomesReduzidos)
NomesReduzidos <- gsub("^t", "time", NomesReduzidos)
NomesReduzidos <- gsub("^f", "frequency", NomesReduzidos)
NomesReduzidos <- gsub("^anglet", "angleTime", NomesReduzidos)
names(reduzido) <- NomesReduzidos 

#######################ETAPA 4.criação da base limpa############################
tidy <- reduzido %>% group_by(activity, subject) %>% summarise_all(funs(mean))

write.table(tidy, file = "tidyDataset.txt", row.names = FALSE)

########################sessionInfo()?##########################################
#R version 4.0.2 (2020-06-22)
#Platform: x86_64-w64-mingw32/x64 (64-bit)
#Running under: Windows 10 x64 (build 17763)

#Matrix products: default
#locale:
#LC_COLLATE=Portuguese_Brazil.1252  LC_CTYPE=Portuguese_Brazil.1252    LC_MONETARY=Portuguese_Brazil.1252 LC_NUMERIC=C LC_TIME=Portuguese_Brazil.1252    

#attached base packages:
#stats     graphics  grDevices utils     datasets  methods   base     

#other attached packages:
#data.table_1.12.8 lubridate_1.7.9   swirl_2.4.5      

#loaded via a namespace (and not attached):
#Rcpp_1.0.5     digest_0.6.25  bitops_1.0-6   R6_2.4.1       magrittr_1.5   httr_1.4.1     rlang_0.4.6    stringi_1.4.6  curl_4.3       testthat_2.3.2 generics_0.0.2 tools_4.0.2    stringr_1.4.0  tinytex_0.24   RCurl_1.98-1.2 xfun_0.15      yaml_2.2.1     compiler_4.0.2