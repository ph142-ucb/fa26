library(tidyverse)
library(lubridate)

# Current workflow / pending improvements: 
# Save gradescope CSV file and edit column names to "lab_01_grade", "lab_01_time", etc.
# Run the script with: results <- process_grades("your_file.csv")

calculate_grades <- function(grade_data) {
  # Helper function to safely convert grades
  convert_grade <- function(x) {
    if(is.na(x) || x == "") return(NA)
    # Convert to numeric and multiply by 100 if in decimal format
    grade <- as.numeric(x)
    if(!is.na(grade) && grade <= 1) {
      grade <- grade * 100
    }
    return(grade)
  }
  
  # Helper function to calculate if submission is late (>24 hours)
  is_late <- function(submission_time, due_date) {
    if(is.na(submission_time) || is.na(due_date)) return(FALSE)
    as.numeric(difftime(submission_time, due_date, units = "hours")) > 24
  }
  
  # Helper function to calculate quiz mean with one drop
  calculate_quiz_mean <- function(quiz_grades) {
    # Convert grades and remove NA values
    grades <- sapply(quiz_grades, convert_grade)
    valid_grades <- sort(grades[!is.na(grades)])
    if(length(valid_grades) == 0) return(NA)
    # Drop lowest grade if there's more than one grade
    if(length(valid_grades) > 1) {
      valid_grades <- valid_grades[-1]  # Remove lowest
    }
    mean(valid_grades)
  }
  
  # Helper function to calculate lab mean with one drop
  calculate_lab_mean <- function(lab_grades) {
    # Convert grades to numeric values
    grades <- sapply(lab_grades, function(x) {
      if(is.na(x) || x == "") return(NA)
      # Handle both numeric and text formats
      if(is.numeric(x)) {
        return(convert_grade(x))
      } else if(tolower(x) %in% c("completed", "1", "true")) {
        return(100)
      } else if(tolower(x) %in% c("not completed", "0", "false")) {
        return(0)
      }
      return(NA)
    })
    
    valid_grades <- sort(grades[!is.na(grades)])
    if(length(valid_grades) == 0) return(NA)
    # Drop lowest if more than one grade
    if(length(valid_grades) > 1) {
      valid_grades <- valid_grades[-1]
    }
    mean(valid_grades)
  }
  
  # Process each student's grades
  results <- grade_data %>%
    rowwise() %>%
    mutate(
      across(ends_with("_grade"), ~convert_grade(.)),
      
      # Process labs
      lab_grades = list(c_across(starts_with("lab_") & ends_with("_grade"))),
      lab_times = list(c_across(starts_with("lab_") & ends_with("_time"))),
      lab_mean = calculate_lab_mean(lab_grades),
      
      # Process quizzes
      quiz_grades = list(c_across(starts_with("quiz_") & ends_with("_grade"))),
      quiz_times = list(c_across(starts_with("quiz_") & ends_with("_time"))),
      quiz_mean = calculate_quiz_mean(quiz_grades),
      
      # Process tests (no drops)
      midterm1_final = case_when(
        is.na(midterm1_grade) ~ NA_real_,
        is_late(midterm1_time, midterm1_due) ~ convert_grade(midterm1_grade)/2,
        TRUE ~ convert_grade(midterm1_grade)
      ),
      
      midterm2_final = case_when(
        is.na(midterm2_grade) ~ NA_real_,
        is_late(midterm2_time, midterm2_due) ~ convert_grade(midterm2_grade)/2,
        TRUE ~ convert_grade(midterm2_grade)
      ),
      
      final_final = case_when(
        is.na(final_grade) ~ NA_real_,
        is_late(final_time, final_due) ~ convert_grade(final_grade)/2,
        TRUE ~ convert_grade(final_grade)
      ),
      
      # Process participation and projects
      participation_score = 100 - (coalesce(missed_participation, 0) * 10),
      
      project_final = case_when(
        is.na(project_grade) ~ NA_real_,
        is_late(project_time, project_due) ~ convert_grade(project_grade)/2,
        TRUE ~ convert_grade(project_grade)
      ),
      
      ec_final = case_when(
        is.na(ec_grade) ~ 0,  # Default to 0 for missing EC
        is_late(ec_time, ec_due) ~ convert_grade(ec_grade)/2,
        TRUE ~ convert_grade(ec_grade)
      ),
      
      # Calculate final grade
      final_grade = (
        (coalesce(lab_mean, 0) * 0.25) +      # Labs worth 25%
          (coalesce(quiz_mean, 0) * 0.25) +     # Quizzes worth 25%
          (coalesce(midterm1_final, 0) * 0.15) + # Midterm 1 worth 15%
          (coalesce(midterm2_final, 0) * 0.15) + # Midterm 2 worth 15%
          (coalesce(final_final, 0) * 0.20) +    # Final worth 20%
          (participation_score * 0.10) +         # Participation worth 10%
          (coalesce(project_final, 0) * 0.15) +  # Project worth 15%
          (ec_final * 0.05)                      # Extra credit worth up to 5%
      ) / 1.05,  # Divide by 1.05 to account for EC being additional
      
      # Calculate letter grade
      letter_grade = case_when(
        final_grade >= 90 ~ "A",
        final_grade >= 80 ~ "B",
        final_grade >= 70 ~ "C",
        final_grade >= 60 ~ "D",
        TRUE ~ "F"
      )
    )
  
  return(results)
}

# Example usage with error handling
process_grades <- function(file_path) {
  tryCatch({
    grades <- read_csv(file_path, na = c("", "NA", "NULL"))
    results <- calculate_grades(grades)
    write_csv(results, paste0("processed_", basename(file_path)))
    cat("Grades processed successfully!\n")
    return(results)
  }, error = function(e) {
    cat("Error processing grades:", e$message, "\n")
    return(NULL)
  })
}

# Example of expected CSV format:
example_data <- tibble(
  student_id = c("1", "2"),
  lab_01_grade = c("1.0", "0.8"),
  lab_01_time = c("2024-01-01 10:00:00", "2024-01-01 09:00:00"),
  quiz_1_grade = c("0.9", ""),
  quiz_1_time = c("2024-01-15 14:00:00", NA),
  midterm1_grade = c("0.85", "0.75"),
  midterm1_time = c("2024-02-01 15:00:00", "2024-02-01 16:00:00"),
  missed_participation = c(1, 2)
)