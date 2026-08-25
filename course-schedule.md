---
layout: page
title: Course Schedule
nav_order: 1
description: Weekly lectures and assignments.
---

# Course Schedule

**Please note:** This schedule is still tentative, and is likely to change. See the [calendar]({{ site.baseurl }}/calendar) to see the scheduling and Zoom links of our weekly events (lecture, office hours, etc).

Quizzes are due at **11:59 PM on Fridays**, and labs are due at **11:59 AM on Saturdays**. During midterm weeks, both deadlines are extended by 24 hours.


{% for module in site.modules %}
{{ module }}
{% endfor %}
