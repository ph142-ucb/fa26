library(shiny)
library(shinyWidgets)
library(tidyverse)
library(dplyr)
library(geometry)

# Define UI for application that draws a histogram
ui <- fluidPage(
  #CSS
  tags$head(
    tags$style(HTML("hr {border-top: 1px solid #000000;}"))
  ),

  #Setting Background Color
  setBackgroundColor(color = "MintCream"),

  # Application title
  titlePanel("PH 142 Grade Estimator"),

  hr(),
  fluidRow(
    column(12,
           HTML("<b>Lab </b><br/> Select 'Completed' or 'Not Completed' for each lab or 'Unknown' for future labs. <b>One 'Not Completed' lab will automatically be dropped.</b><br/><br/>")),
    column(2,
           radioButtons("lab01", "Lab 01", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab02", "Lab 02", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab03", "Lab 03", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab04", "Lab 04", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab05", "Lab 05", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown"))),
  fluidRow(
    column(2,
           radioButtons("lab06", "Lab 06", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab07", "Lab 07", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab08", "Lab 08", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab09", "Lab 09", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab10", "Lab 10", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown")),
    column(2,
           radioButtons("lab11", "Lab 11", choices = c("Completed", "Not Completed", "Unknown"), selected = "Unknown"))),
  fluidRow(
    column(4,
           div(textOutput("lab_avg_out"), style = "color: blue;"))),
  hr(),
  fluidRow(
    column(12,
           HTML("<b>Quizzes </b><br/> Enter a percentage grade for each quiz (E.g. Enter 75 if you got 75%). <b>The lowest quiz grade will be automatically dropped.</b><br><br>")),
    column(2,
           numericInput("q1", "Quiz 1", value = NA, min = 0, max = 100, step = 1)),
    column(2,
           numericInput("q2", "Quiz 2", value = NA, min = 0, max = 100, step = 1)),
    column(2,
           numericInput("q3", "Quiz 3", value = NA, min = 0, max = 100, step = 1)),
    column(2,
           numericInput("q4", "Quiz 4", value = NA, min = 0, max = 100, step = 1)),
    column(2,
           numericInput("q5", "Quiz 5", value = NA, min = 0, max = 100, step = 1))),
  fluidRow(
    column(2,
           numericInput("q6", "Quiz 6", value = NA, min = 0, max = 100, step = 1)),
    column(2,
           numericInput("q7", "Quiz 7", value = NA, min = 0, max = 100, step = 1)),
  	column(2,
			numericInput("q8", "Quiz 8", value = NA, min = 0, max = 100, step = 1)),
  	column(2,
			numericInput("q9", "Quiz 9", value = NA, min = 0, max = 100, step = 1))),
  fluidRow(
    column(4,
           div(textOutput("quiz_avg_out"), style = "color: blue;"))),

  hr(),
  fluidRow(
    column(12,
           HTML("<b>Tests (Midterm 1: 15%, Midterm 2: 15%, Final: 15%)</b><br/>Enter a percentage grade for each test.
                Guess grades for tests not yet completed to see how it will affect your overall grade. <br><br>")),
    column(2,
           numericInput("m1", "Midterm 1", value = 50, min = 0, max = 100)),
    column(2,
           numericInput("m2", "Midterm 2", value = 50, min = 0, max = 100)),
    column(2,
           numericInput("final", "Midterm 3", value = 50, min = 0, max = 100))
           ),
  hr(),
  fluidRow(
    column(12,
           HTML("<b>Miscellaneous</b><br/> Enter an integer for the lecture participation and percentage grades for the data project and extra credit assignments.
                <br> For EC 2, please put '100' if full credit was received for one week, '200' if full credit was received for both weeks.<br><br>")),
    column(3,
           numericInput(("lec_missed"), "Participation Opportunities Missed", value = 0, min = 0, max = 40)),
    column(3,
           numericInput(("group"), "Data Project", value = 50, min = 0, max = 100)),
    column(3,
           numericInput(("ec1"), "EC 1: Statistics is Everywhere", value = 0, min = 0, max = 100)),
	column(3,
           numericInput(("ec2"), "EC 2: Questions and Solution Guide", value = 0, min = 0, max = 200))
  ),
  hr(),
  fluidRow(
    column(12,
           div(textOutput("weighted_avg"), style = "color: blue;")),
    column(12,
           div(textOutput("letter_grade"), style = "color: blue;")),
  ))


#--------------------------------------------------------------------------------------------------------------------------------------------
# Define server logic 
server <- function(input, output) {
  
  ### Defining Weights of Categories
  # lec_weight <- 0.10
  # lab_weight <- 0.10
  # quiz_weight <- 0.15
  # mt1_weight <- 0.15
  # mt2_weight <- 0.15
  # final_weight <- 0.15
  # proj_weight <- 0.20
  # ec_weight <- 0.01
  # 
  # weights <- c(lec_weight, lab_weight, quiz_weight, mt1_weight, 
  #              mt2_weight, final_weight, proj_weight, ec_weight)
  
  

  #### Define Average/Drop Function
  avg_drop_x_lowest <- function(values, drops=0) {
    if (length(values) - sum(is.na(values)) <= drops) {
      return(100)
    } else if (drops == 0) {
      return(round(sum(values, na.rm = T) / (sum(!is.na(values))), 2))
    } else {
      return(round((sum(values, na.rm = T) - sum(sort(values)[1:drops])) / (sum(!is.na(values)) - drops), 2))
    }
  }
  
  

  ##### LAB
  lab_avg <- reactive({
    lab_grades_raw <- c(input$lab01, 
                        input$lab02, 
                        input$lab03, 
                        input$lab04, 
                        input$lab05,
                        input$lab06, 
                        input$lab07, 
                        input$lab08, 
                        input$lab09, 
                        input$lab10, 
                        input$lab11)
    lab_grades <- replace(lab_grades_raw, lab_grades_raw == "Completed", 100)
    lab_grades <- replace(lab_grades, lab_grades == "Not Completed", 0)
    lab_grades <- replace(lab_grades, lab_grades == "Unknown", NA)
    return(avg_drop_x_lowest(as.numeric(lab_grades), drops=1))
  })

  output$lab_avg_out <- renderText({
    paste0("Lab Mean: ", lab_avg(), "%")
  })


  ##### QUIZ
  quiz_avg <- reactive({
  	quiz_grades <- c(input$q1, 
  	                 input$q2, 
  	                 input$q3, 
  	                 input$q4, 
  	                 input$q5,
                     input$q6, 
  	                 input$q7, 
  	                 input$q8, 
  	                 input$q9)
  	
  	if (length(quiz_grades[!is.na(quiz_grades)]) == 1) {
  	  return(sum(quiz_grades, na.rm = T))
  	} else {
  	  return(avg_drop_x_lowest(quiz_grades, drops = 1))
  	}
  })

  output$quiz_avg_out <- renderText({
    paste0("Quiz Mean: ", quiz_avg(), "%")
  })

  ##### Original Grading Policy Weighted
  original <- reactive({

    lec_weight <- 0.10
    lab_weight <- 0.10
    quiz_weight <- 0.15

    mt1_weight <- 0.15
    mt2_weight <- 0.15
    final_weight <- 0.15

    project_weight <- 0.20
    extra_credit_weight <- 0.01

    lec_percentage <- 100
    
    
    if (input$lec_missed > 1) {
      lec_percentage <- ((17 - (input$lec_missed - 1)) / 17) * 100
    }
    
    weight_avg <- (lec_weight * lec_percentage) + 
      (lab_avg() * lab_weight) + 
      (quiz_avg() * quiz_weight) +
      (input$m1 * mt1_weight) + 
      (input$m2 * mt2_weight) + 
      (input$final * final_weight) +
      (input$group * project_weight) + 
      (input$ec1 * extra_credit_weight) + 
      (input$ec2 * extra_credit_weight)

    return(weight_avg)
  })

  #### Grade Estimate
  
    output$weighted_avg <- renderText({
      paste0("Grade Estimate: ", original(), "%")
    })
  
    output$letter_grade <- renderText({
      paste0("Letter grade: ", case_when(original() >= 98.5 ~ "A+",
                                         original() < 98.5 & original() >= 94.0 ~ "A",
                                         original() < 94.0 & original() >= 89.0 ~ "A-",
                                         original() < 89.0 & original() >= 85.0 ~ "B+",
                                         original() < 85.0 & original() >= 81.0 ~ "B",
                                         original() < 81.0 & original() >= 75.5 ~ "B-",
                                         original() < 75.5 & original() >= 70.5 ~ "C+",
                                         original() < 70.5 & original() >= 60.5 ~ "C",
                                         original() < 60.5 & original() >= 51 ~ "C",
                                         original() < 51.0 ~ "D")
      )
  })


}

# Run the application 
shinyApp(ui = ui, server = server)
