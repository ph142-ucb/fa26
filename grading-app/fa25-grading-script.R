library(dplyr)

#generate.grades <- function(gradescope.df, final.p = FALSE) {

### Parameters:
final.p <- FALSE
data.proj.phases.complete <- 2
is.fall.2025.p <- TRUE

## Get this file from GradeScope:
dat <- read.csv("~/data/PH_142_Fall_2025_grades-2025-11-17.csv")
  
## Get rid of columns
dat <- dat %>% select(-c(contains("Time"),contains("Lateness")))
  
quiz <- dat %>% select(c(SID),contains("Quiz"))
labs <- dat %>% select(c(SID),contains("Lab"))
midterm <- dat %>% select(c(SID),contains("Midt"))
datproj <- dat %>% select(c(SID),contains("Data.p"))
  
if ( final.p ) {
  final <- dat %>% select(c(SID),contains("Final.E"))
  Extra <- dat %>% select(c(SID),contains("Extra"))
}
  
##Labs Scores
if ( is.fall.2025.p ) {
  labs <- labs %>% mutate(Lab05 = 17, Lab05...Max.Points = 17)
}

labs <- replace(labs, is.na(labs), 0)
lab.max <- labs %>% select(c(SID,contains("Max")))
lab.s <- labs %>% select(-contains("Max"))
nc <- ncol(lab.max)
num.labs <- nc - 1
num.graded.labs <- num.labs - 1
perc.lab <- data.frame(SID=lab.s[,1],lab.s[,2:nc]/lab.max[,2:nc])
minlab <- apply(perc.lab[,2:nc],1,min)
sumlab <- apply(perc.lab[,2:nc],1,sum)
lab.score <- data.frame(SID=lab.s[,1],lab.tot = (sumlab-minlab)/num.graded.labs)
  
# Quiz Scores
quiz <- replace(quiz, is.na(quiz), 0)
quiz.max <- quiz %>% select(c(SID,contains("Max")))
quiz.s <- quiz %>% select(-contains("Max"))
nc <- ncol(quiz.max)
num.quizzes <- nc - 1
num.graded.quizzes <- num.quizzes - 1
perc.quiz <- data.frame(SID=quiz.s[,1],quiz.s[,2:nc]/quiz.max[,2:nc])
minquiz <- apply(perc.quiz[,2:nc],1,min)
sumquiz <- apply(perc.quiz[,2:nc],1,sum)
quiz.score <- data.frame(SID=lab.s[,1],quiz.tot = (sumquiz-minquiz)/num.graded.quizzes)
  
# Midterms
midterm <- replace(midterm, is.na(midterm), 0)
mid.max <- midterm %>% select(c(SID,contains("Max")))
mid.s <- midterm %>% select(-contains("Max"))
nc <- ncol(mid.max)
perc.mid <- data.frame(SID=mid.s[,1],mid.s[,2:nc]/mid.max[,2:nc])
mid.score <- data.frame(SID=mid.s[,1],mid.tot=apply(perc.mid[,2:nc],1,mean))


# Data Project
datproj <- replace(datproj, is.na(datproj), 0)
data.max <- datproj %>% select(c(SID,contains("Max")))
data.s <- datproj %>% select(-contains("Max"))
nc <- ncol(data.max)
perc.data <- data.frame(SID=data.s[,1],data.s[,2:nc]/data.max[,2:nc])
sumdata <- apply(perc.data[,2:nc],1,sum)
data.score <- data.frame(SID=lab.s[,1],data.tot = sumdata/data.proj.phases.complete)
#data.score <- data.frame(SID=data.s[,1],data.tot=apply(perc.data[,2:nc],1,mean))

all.scores <- dat %>% select(SID,First.Name,Last.Name) %>% 
  left_join(lab.score, by = "SID") %>%
  left_join(quiz.score, by = "SID") %>%
  left_join(mid.score, by = "SID") %>%
  left_join(data.score, by = "SID")
  
if (final.p) {
  # Final
  final <- replace(final, is.na(final), 0)
  final.score <- data.frame(SID=final[,1], fin.tot = final[,2]/42)
  
  ## Extra Credit
  Extra <- replace(Extra, is.na(Extra), 0)
  Extra <- Extra %>% select(-contains("Max"))
  extra.score <- data.frame(SID=Extra[,1],extra.tot=apply(Extra[,2:3],1,mean)/100)
  
  ## Join all the scores
  all.scores <- all.scores %>%
    left_join(final.score, by = "SID") %>%
    left_join(extra.score, by = "SID")
  ## First term of 0.10 is a place-hold for the participation grade
  all.scores <- all.scores %>% mutate(class.tot = 0.10            + 
                                                  0.10 * quiz.tot +  
                                                  0.10 * lab.tot  + 
                                                  0.3  * mid.tot  + 
                                                  0.20 * data.tot + 
                                                  0.20 * fin.tot+extra.tot)  
  
  all.scores <- all.scores %>% 
    mutate(grade = 
             cut(class.tot, breaks = c(0, .59, .62,.67,.699,
                                       .72, .74,.75,.82,.87,.899,.92,.99,1.2), 
                 labels = c("F","D-", "D","D+", "C-", "C","C+",
                            "B-","B","B+","A-","A","A+"),right = TRUE))                                      
  
  write.csv(all.scores,"FinalGradesFall2024.csv")
  
} else {
  
  ## First 0.10 is the participation grade. The 0.8 denominator is to give the
  ## grade without the final exam, but scaled so that we give them an estimate 
  ## out of 100%.
  all.scores <- all.scores %>% mutate(final.score = ( 0.10            + 
                                                      0.10 * quiz.tot +
                                                      0.10 * lab.tot  +
                                                      0.3  * mid.tot  +
                                                      0.2  * data.tot   )/0.8
                                      )
  
}

  
