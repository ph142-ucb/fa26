from shiny import App, ui, render, reactive

# Custom CSS for a modern, beautiful UI
custom_css = """
body {
    background-color: #f4f7f6;
    font-family: 'Inter', system-ui, -apple-system, sans-serif;
    color: #333;
}
.app-container {
    max-width: 1200px;
    margin: 0 auto;
    padding-top: 30px;
}
.card {
    border: none;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.04);
    margin-bottom: 24px;
    background: #ffffff;
}
.card-header {
    background-color: #ffffff !important;
    border-bottom: 1px solid #f0f0f0 !important;
    font-weight: 700;
    font-size: 1.15em;
    color: #2c3e50;
    border-radius: 12px 12px 0 0 !important;
    padding: 15px 20px;
}
.card-body {
    padding: 20px;
}
.section-desc {
    color: #666;
    font-size: 0.95em;
    margin-bottom: 20px;
}

/* --- RADIO BUTTON STYLING --- */
.shiny-input-radiogroup > label {
    margin-bottom: 12px !important; 
    font-weight: 600 !important;
    color: #2c3e50;
    border-bottom: 2px solid #eef2f5;
    padding-bottom: 6px;
    display: block;
    font-size: 1.05em;
}
.shiny-options-group .form-check {
    margin-bottom: 8px;
    color: #555;
}
/* -------------------------------- */

.result-box {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 10px 20px rgba(118, 75, 162, 0.2);
}
.letter-grade {
    font-size: 4em;
    font-weight: 900;
    line-height: 1.1;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
}
.percentage-grade {
    font-size: 1.5em;
    font-weight: 600;
    opacity: 0.9;
}
.category-avg {
    font-weight: bold;
    color: #4a90e2;
    background: #eef5ff;
    padding: 8px 15px;
    border-radius: 8px;
    display: inline-block;
    margin-top: 15px;
}
.ec-highlight > label {
    color: #27ae60 !important;
    border-bottom: 2px solid #2ecc71 !important;
}
"""

app_ui = ui.page_fluid(
    ui.tags.head(ui.tags.style(custom_css)),
    
    ui.div(
        ui.h1("PH 142 Grade Estimator", style="font-weight: 800; color: #2c3e50; text-align: center;"),
        ui.p("Spring 2026 Semester", style="text-align: center; color: #7f8c8d; font-size: 1.2em; margin-bottom: 40px;"),
        
        ui.layout_columns(
            # LEFT COLUMN: Inputs
            ui.div(
                # 1. TESTS, PROJECT & PARTICIPATION (Moved to Top)
                ui.layout_columns(
                    ui.card(
                        ui.card_header("Exams (50%)"),
                        ui.div("Guess grades for future tests to predict your final outcome.", class_="section-desc"),
                        ui.input_numeric("m1", "Midterm 1 (15%)", value=100, min=0, max=100),
                        ui.input_numeric("m2", "Midterm 2 (15%)", value=100, min=0, max=100),
                        ui.input_numeric("final", "Final Exam (20%)", value=100, min=0, max=100)
                    ),
                    ui.card(
                        ui.card_header("Data Project (20%)"),
                        ui.input_numeric("project", "Project Score", value=100, min=0, max=100),
                        
                        ui.br(),
                        
                        ui.card_header("Participation (10%)"),
                        ui.input_numeric("part_polls", "Polls & Activities (5%)", value=100, min=0, max=100),
                        ui.input_numeric("part_surveys", "Surveys & Meetings (5%)", value=100, min=0, max=100),
                    ),
                    col_widths=(6, 6)
                ),
                
                # 2. QUIZZES
                ui.card(
                    ui.card_header("Quizzes (10%)"),
                    ui.div(
                        ui.HTML("Enter percentage grades (e.g., 75). <b>11 regular quizzes + 1 EC quiz</b>. The lowest regular quiz is dropped."),
                        class_="section-desc"
                    ),
                    ui.layout_columns(
                        *[ui.input_numeric(f"q{i:02d}", f"Quiz {i}", value=None, min=0, max=100) for i in range(1, 12)],
                        ui.div(ui.input_numeric("q_ec", "EC Quiz", value=None, min=0, max=100)),
                        col_widths=3
                    ),
                    ui.div(ui.output_text("quiz_avg_out"), class_="category-avg")
                ),
                
                # 3. LABS
                ui.card(
                    ui.card_header(ui.HTML("<i class='fas fa-flask'></i> Lab Assignments (10%)")),
                    ui.div(
                        ui.HTML("Select status for each lab. <b>11 regular labs + 1 EC lab</b>. The lowest regular lab is dropped."),
                        class_="section-desc"
                    ),
                    ui.layout_columns(
                        *[ui.input_radio_buttons(f"lab{i:02d}", f"Lab {i}", choices=["Completed", "Not Completed", "Unknown"], selected="Unknown") for i in range(1, 12)],
                        ui.div(ui.input_radio_buttons("lab_ec", "EC Lab", choices=["Completed", "Not Completed", "Unknown"], selected="Unknown")),
                        col_widths=3
                    ),
                    ui.div(ui.output_text("lab_avg_out"), class_="category-avg")
                )
            ),
            
            # RIGHT COLUMN: Sticky Results
            ui.div(
                ui.div(
                    ui.h3("Estimated Grade", style="margin-bottom: 20px; font-weight: bold;"),
                    ui.div(
                        ui.div(ui.output_text("letter_grade"), class_="letter-grade"),
                        ui.div(ui.output_text("weighted_avg"), class_="percentage-grade"),
                        class_="result-box"
                    ),
                    ui.p(
                        "Please note, the grade bins and thresholds are subject to change by the professor.", 
                        style="color: #95a5a6; font-size: 0.85em; margin-top: 15px; text-align: center; font-style: italic;"
                    ),
                    style="position: sticky; top: 30px;"
                )
            ),
            col_widths=(8, 4)
        ),
        class_="app-container"
    )
)

def server(input, output, session):

    def calc_category_score(regular_scores, ec_score):
        """
        Drops the lowest 1 regular score, sums the remaining 10,
        adds the EC bonus on top, and averages out of 10.
        Caps at 100% full credit.
        """
        regular_scores.sort()
        best_10 = regular_scores[1:] # Drop the single lowest regular score
        
        total_points = sum(best_10) + ec_score
        avg = total_points / 10.0 # Base denominator is the 10 graded items
        
        return round(min(avg, 100.0), 2) # Cap at 100%

    @reactive.calc
    def lab_avg():
        reg_labs = []
        for i in range(1, 12):
            val = getattr(input, f"lab{i:02d}")()
            if val == "Completed":
                reg_labs.append(100.0)
            elif val == "Not Completed":
                reg_labs.append(0.0)
            else:
                # "Unknown" future labs default to 100% for optimistic projecting
                reg_labs.append(100.0)
                
        # Parse EC Lab
        ec_val = input.lab_ec()
        ec_score = 100.0 if ec_val == "Completed" else 0.0
        
        return calc_category_score(reg_labs, ec_score)

    @render.text
    def lab_avg_out():
        return f"Current Lab Average: {lab_avg()}%"

    @reactive.calc
    def quiz_avg():
        reg_quizzes = []
        for i in range(1, 12):
            val = getattr(input, f"q{i:02d}")()
            if val is not None:
                reg_quizzes.append(float(val))
            else:
                # Blank quizzes default to 100% for optimistic projecting
                reg_quizzes.append(100.0)
                
        # Parse EC Quiz
        ec_val = input.q_ec()
        ec_score = float(ec_val) if ec_val is not None else 0.0
        
        return calc_category_score(reg_quizzes, ec_score)

    @render.text
    def quiz_avg_out():
        return f"Current Quiz Average: {quiz_avg()}%"

    @reactive.calc
    def participation_score():
        # Handle cases where the user completely deletes the text in the box (None)
        polls_val = input.part_polls()
        surveys_val = input.part_surveys()
        
        polls = float(polls_val) if polls_val is not None else 0.0
        surveys = float(surveys_val) if surveys_val is not None else 0.0
        
        return round((polls + surveys) / 2, 2)

    @render.text
    def participation_out():
        return f"Overall Participation: {participation_score()}%"

    @reactive.calc
    def final_grade():
        w_lab, w_quiz, w_part = 0.10, 0.10, 0.10
        w_m1, w_m2 = 0.15, 0.15
        w_final, w_proj = 0.20, 0.20

        m1 = float(input.m1()) if input.m1() is not None else 0.0
        m2 = float(input.m2()) if input.m2() is not None else 0.0
        final_exam = float(input.final()) if input.final() is not None else 0.0
        proj = float(input.project()) if input.project() is not None else 0.0

        total = (
            (lab_avg() * w_lab) +
            (quiz_avg() * w_quiz) +
            (participation_score() * w_part) +
            (m1 * w_m1) +
            (m2 * w_m2) +
            (final_exam * w_final) +
            (proj * w_proj)
        )
        return round(total, 2)

    @render.text
    def weighted_avg():
        capped = min(final_grade(), 100.0)
        return f"{capped:.2f}%"

    @render.text
    def letter_grade():
        capped = min(final_grade(), 100.0)
        
        if capped >= 99: return "A+"
        if capped >= 93: return "A"
        if capped >= 90: return "A-"
        if capped >= 87: return "B+"
        if capped >= 83: return "B"
        if capped >= 80: return "B-"
        if capped >= 77: return "C+"
        if capped >= 73: return "C"
        if capped >= 70: return "C-"
        if capped >= 67: return "D+"
        if capped >= 63: return "D"
        if capped >= 60: return "D-"
        return "F"

app = App(app_ui, server)