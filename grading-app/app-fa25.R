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
           HTML("<b>Participation (10%)</b><br/> Mid-Semester Evaluation (5%), End-of-Course Evaluation (5%), and Lab Section Attendance (90% of participation). 14 total labs; top 12 count.<br/><br>")),
    column(3,
           checkboxInput("mid_eval", "Mid-Semester Evaluation Completed", value = FALSE)),
    column(3,
           checkboxInput("end_eval", "End-of-Course Evaluation Completed", value = FALSE)),
    column(3,
           numericInput("labs_attended", "Lab Sections Attended (out of 14)", value = 0, min = 0, max = 14, step = 1)),
    column(3,
           div(textOutput("participation_out"), style = "color: blue;"))
  ),
  hr(),
  fluidRow(
    column(12,
           HTML("<b>Tests (Midterm 1: 15%, Midterm 2: 15%, Final: 20%)</b><br/>Enter a percentage grade for each test, including points received as extra credit.
                Guess grades for tests not yet completed to see how it will affect your overall grade. <br><br>")),
    column(2,
           numericInput("m1", "Midterm 1", value = 50, min = 0, max = 100)),
    column(2,
           numericInput("m2", "Midterm 2", value = 50, min = 0, max = 100)),
    column(2,
           numericInput("final", "Final", value = 50, min = 0, max = 100))
           ),
  hr(),
  fluidRow(
    column(12,
           HTML("<b>Data Project</b><br/>Data Skills Demonstration Project (20% of course grade).<br/><br>")),
    column(4,
           numericInput(("group"), "Data Skills Demonstration Project", value = 50, min = 0, max = 100))
  ),
  hr(),
  fluidRow(
    column(12,
           HTML("<b>Extra Credit</b><br/>Up to 4% total: 1% for an extra credit assignment (options are mutually exclusive) and up to 3% from lecture attendance.<br/><br>")),
    column(3,
           checkboxInput("ec_assign1", "Extra Credit Assignment 1 Completed", value = FALSE)),
    column(3,
           checkboxInput("ec_assign2", "Extra Credit Assignment 2 Completed", value = FALSE)),
    column(3,
           sliderInput("attendance_pct", "Lecture Attendance Bonus (%)", value = 0, min = 0, max = 3, step = 0.1)),
    column(3,
           div(textOutput("extra_credit_out"), style = "color: blue;"))
  ),
  hr(),
  fluidRow(
    column(12,
           div(textOutput("weighted_avg"), style = "color: blue;")),
    column(12,
           div(textOutput("letter_grade"), style = "color: blue;")),
    column(12,
           div(textOutput("grade_note"), style = "color: blue;")),
  ))


#--------------------------------------------------------------------------------------------------------------------------------------------
# Define server logic 
server <- function(input, output) {

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

  ##### PARTICIPATION
  participation_percent <- reactive({
    mid_eval_score <- ifelse(isTRUE(input$mid_eval), 5, 0) # 5% of participation category
    end_eval_score <- ifelse(isTRUE(input$end_eval), 5, 0) # 5% of participation category
    labs_attended <- ifelse(is.null(input$labs_attended) || is.na(input$labs_attended), 0, input$labs_attended)
    lab_score <- (pmin(labs_attended, 12) / 12) * 90 # 90% of participation category from top 12 labs
    return(round(mid_eval_score + end_eval_score + lab_score, 2))
  })

  output$participation_out <- renderText({
    paste0("Participation Score: ", participation_percent(), "% (out of 100% for participation category)")
  })

  ##### EXTRA CREDIT
  extra_credit_points <- reactive({
    ec_assignments <- min(1, sum(c(input$ec_assign1, input$ec_assign2))) # mutually exclusive, max 1%
    attendance_bonus <- ifelse(is.null(input$attendance_pct) || is.na(input$attendance_pct), 0, input$attendance_pct)
    total_bonus <- (ec_assignments * 1) + attendance_bonus
    return(round(min(total_bonus, 4), 2))
  })

  output$extra_credit_out <- renderText({
    paste0("Extra Credit Applied: ", extra_credit_points(), "% (max 4%)")
  })

  ##### Original Grading Policy Weighted
  original <- reactive({

    participation_weight <- 0.10
    lab_weight <- 0.10
    quiz_weight <- 0.10

    mt1_weight <- 0.15 # 15% midterm 1
    mt2_weight <- 0.15 # 15% midterm 2
    final_weight <- 0.20 # 20% final

    project_weight <- 0.20 # 20% data project

    weight_avg <- (participation_weight * participation_percent()) + 
      (lab_avg() * lab_weight) + 
      (quiz_avg() * quiz_weight) +
      (input$m1 * mt1_weight) + 
      (input$m2 * mt2_weight) + 
      (input$final * final_weight) +
      (input$group * project_weight) + 
      extra_credit_points()

    return(weight_avg)
  })

  #### Grade Estimate
  
    output$weighted_avg <- renderText({
      capped <- min(original(), 100)
      paste0("Grade Estimate: ", capped, "%")
    })
  
    output$letter_grade <- renderText({
      capped <- min(original(), 100)
      grade_letter <- case_when(
        capped >= 99 ~ "A+",
        capped >= 93 ~ "A",
        capped >= 90 ~ "A-",
        capped >= 87 ~ "B+",
        capped >= 83 ~ "B",
        capped >= 80 ~ "B-",
        capped >= 77 ~ "C+",
        capped >= 73 ~ "C",
        capped >= 70 ~ "C-",
        capped >= 67 ~ "D+",
        capped >= 63 ~ "D",
        capped >= 60 ~ "D-",
        TRUE ~ "F"
      )
      paste0("Letter grade: ", grade_letter)
    })

    output$grade_note <- renderText({
      paste0("Please note, the grade bins are subject to change by Prof. Altman")
    })


}

# Run the application 
shinyApp(ui = ui, server = server)
