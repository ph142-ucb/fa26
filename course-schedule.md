---
layout: page
title: Course Schedule
nav_order: 1
description: Weekly lectures and assignments.
---

# Course Schedule

**Please note:** This schedule is still tentative, and is likely to change. See the [calendar]({{ site.baseurl }}/calendar) to see the scheduling and Zoom links of our weekly events (lecture, office hours, etc).


{% for module in site.modules %}
{{ module }}
{% endfor %}
