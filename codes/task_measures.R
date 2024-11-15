{
rm(list=ls())
gc()
options(timeout = 600)
options(scipen=999)
options(digits=2)
requiredPackages = c("splitstackshape", "tidyverse", "dplyr", "reshape2", "haven", 
                   "stringr", "viridisLite", "gridExtra", "lmreg", "mice","Hmisc",
                   "ggrepel", "viridis", "foreign", "bnstruct", "outliers","forecast",
                   "labelVector", "readxl", "zoo", "imputeTS")
for(i in requiredPackages){if(!require(i,character.only = TRUE)) install.packages(i)}
for(i in requiredPackages){if(!require(i,character.only = TRUE)) library(i,character.only = TRUE) }
rm(list=ls())
gc()
}

# TASK MEASURES TO MERGE WITH RVB DATA

data <- read_dta("../original_data/bibb2006_har.dta")

data <- data[,c("idnum", "f100_kldb2010_3d", "f513nace", "zpalter", "s1",
                "f310", # organizing
                "f313", # investigating
                "f311", # researching
                "f322_01", # programming
                "f312", # teaching
                "f314", # consulting
                "f307", # buying
                "f309", # promoting
                "f306", # repairing
                "f316", # caring
                "f315", # accomodating
                "f317", # protecting
                "f304", # measuring
                "f305", # operating
                "f303", # manufacturing
                "f308")]# storing 

for (i in 6:ncol(data)){
  data[[i]][data[[i]]==9] <- NA
}

unique(data$f310)

unique(data$f322_01)
data$f322_01[data$f322_01==2] <- 0
unique(data$f322_01)

data$f322_01 <- ifelse(is.na(data$f322_01), 0, data$f322_01)
unique(data$f322_01)

for (i in 6:ncol(data)){
  data[[i]][data[[i]]==2] <- 1
  data[[i]][data[[i]]==3] <- 0
}

for(i in 3:ncol(data)){
  data[[i]] <- as.numeric(data[[i]])
}

# rename

colnames(data) <- c("id", "occupation_3d", "sector", "age", "sex",
                    "organizing",
                    "investigating",
                    "researching",
                    "programming",
                    "teaching",
                    "consulting",
                    "buying",
                    "promoting",
                    "repairing",
                    "caring",
                    "accomodating",
                    "protecting",
                    "measuring",
                    "operating",
                    "manufacturing",
                    "storing")

# repair occupation codes (curr. coded as long and without 0 at the beginning)

data$occupation_3d <- as.character(data$occupation_3d)
data_1 <- data[(nchar(as.character(data$occupation_3d)) == 2),]
data_2 <- data[(nchar(as.character(data$occupation_3d)) == 3),]

data_1 <- subset(data_1, occupation_3d!="-1")
data_1$occupation_3d <- paste0("0", data_1$occupation_3d)

data <- rbind(data_1, data_2)
rm(data_1, data_2)

# create task measures

data$analytic <- ((data$organizing + data$researching + data$investigating + data$programming)/4)*100

data$interactive <- ((data$teaching + data$consulting + data$buying + data$promoting)/4)*100

data$nonroutine_cognitive <- ((data$organizing + data$researching + data$investigating + data$programming + data$teaching + data$consulting + data$buying + data$promoting)/8)*100

data$nonroutine_manual <- ((data$repairing + data$caring + data$accomodating + data$protecting)/4)*100

data$routine <- ((data$operating + data$manufacturing + data$storing + data$measuring)/4)*100

data_corr <- data[,c("id", "age", "sex", "sector", "analytic", "interactive", "nonroutine_cognitive", "nonroutine_manual", "routine")]

data <- data[,c("id", "occupation_3d", "analytic", "interactive", "nonroutine_cognitive", "nonroutine_manual", "routine")]

# remove NA

na <- is.na(data)
sum(na)/sum(1-na)

data <- data[complete.cases(data),]

na <- is.na(data)
sum(na)/sum(1-na)

na <- is.na(data_corr)
sum(na)/sum(1-na)

data_corr <- data_corr[complete.cases(data_corr),]

na <- is.na(data_corr)
sum(na)/sum(1-na)

data$occupation_2d <- substr(data$occupation_3d, 1, 2)

# aggregate 3d

analytic <- aggregate(data$analytic, by=list(occupation_3d=data$occupation_3d), FUN=mean)
analytic_2 <- data %>% count(occupation_3d)
colnames(analytic)[2] <- "analytic"
analytic <- merge(analytic, analytic_2, by = "occupation_3d", all = T)

interactive <- aggregate(data$interactive, by=list(occupation_3d=data$occupation_3d), FUN=mean)
colnames(interactive)[2] <- "interactive"

nonroutine_cognitive <- aggregate(data$nonroutine_cognitive, by=list(occupation_3d=data$occupation_3d), FUN=mean)
colnames(nonroutine_cognitive)[2] <- "nonroutine_cognitive"

nonroutine_manual <- aggregate(data$nonroutine_manual, by=list(occupation_3d=data$occupation_3d), FUN=mean)
colnames(nonroutine_manual)[2] <- "nonroutine_manual"

routine <- aggregate(data$routine, by=list(occupation_3d=data$occupation_3d), FUN=mean)
colnames(routine)[2] <- "routine"

task_measures_2006_occ_3d <- merge(analytic, interactive, by="occupation_3d")
task_measures_2006_occ_3d <- merge(task_measures_2006_occ_3d, nonroutine_cognitive, by="occupation_3d")
task_measures_2006_occ_3d <- merge(task_measures_2006_occ_3d, nonroutine_manual, by="occupation_3d")
task_measures_2006_occ_3d <- merge(task_measures_2006_occ_3d, routine, by="occupation_3d")

# aggregate 2d

analytic <- aggregate(data$analytic, by=list(occupation_2d=data$occupation_2d), FUN=mean)
analytic_2 <- data %>% count(occupation_2d)
colnames(analytic)[2] <- "analytic"
analytic <- merge(analytic, analytic_2, by = "occupation_2d", all = T)

interactive <- aggregate(data$interactive, by=list(occupation_2d=data$occupation_2d), FUN=mean)
colnames(interactive)[2] <- "interactive"

nonroutine_cognitive <- aggregate(data$nonroutine_cognitive, by=list(occupation_2d=data$occupation_2d), FUN=mean)
colnames(nonroutine_cognitive)[2] <- "nonroutine_cognitive"

nonroutine_manual <- aggregate(data$nonroutine_manual, by=list(occupation_2d=data$occupation_2d), FUN=mean)
colnames(nonroutine_manual)[2] <- "nonroutine_manual"

routine <- aggregate(data$routine, by=list(occupation_2d=data$occupation_2d), FUN=mean)
colnames(routine)[2] <- "routine"

task_measures_2006_occ_2d <- merge(analytic, interactive, by="occupation_2d")
task_measures_2006_occ_2d <- merge(task_measures_2006_occ_2d, nonroutine_cognitive, by="occupation_2d")
task_measures_2006_occ_2d <- merge(task_measures_2006_occ_2d, nonroutine_manual, by="occupation_2d")
task_measures_2006_occ_2d <- merge(task_measures_2006_occ_2d, routine, by="occupation_2d")

rm(list=setdiff(ls(), c("task_measures_2006_occ_3d", "task_measures_2006_occ_2d", "data_corr")))

# Prepare a cross-sectional file with 2006 measures

task_measures_2006_occ_3d <- task_measures_2006_occ_3d[,c("occupation_3d", "n", "analytic", "interactive", "nonroutine_manual", "routine")]
task_measures_2006_occ_2d <- task_measures_2006_occ_2d[,c("occupation_2d", "n", "analytic", "interactive", "nonroutine_manual", "routine")]

task_measures_2006_occ_3d$occupation_3d <- str_replace_all(task_measures_2006_occ_3d$occupation_3d, "-", "")
task_measures_2006_occ_3d <- subset(task_measures_2006_occ_3d, nchar(occupation_3d)==3)

task_measures_2006_occ_2d$occupation_2d <- str_replace_all(task_measures_2006_occ_2d$occupation_2d, "-", "")
task_measures_2006_occ_2d <- subset(task_measures_2006_occ_2d, nchar(occupation_2d)==2)

colnames(task_measures_2006_occ_3d) <- c("kldb_2010_3d", "n", "analytic_2006", "interactive_2006", "nonroutine_manual_2006", "routine_2006")
colnames(task_measures_2006_occ_2d) <- c("kldb_2010_2d", "n", "analytic_2006", "interactive_2006", "nonroutine_manual_2006", "routine_2006")

write.dta(task_measures_2006_occ_3d, file="task_measures_all_2006_occ_3d.dta")
write.dta(task_measures_2006_occ_2d, file="task_measures_all_2006_occ_2d.dta")

write.csv(task_measures_2006_occ_3d, file="task_measures_all_2006_occ_3d.csv", row.names = F)
write.csv(task_measures_2006_occ_2d, file="task_measures_all_2006_occ_2d.csv", row.names = F)

rm(task_measures_2006_occ_3d, task_measures_2006_occ_2d)
gc()