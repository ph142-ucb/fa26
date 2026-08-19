---
layout: page
title: Staff
nav_order: 3
description: A listing of all the course staff members.
---

# Staff

For lab section and office hour schedules for each GSI, see the [calendar]({{ site.baseurl }}/calendar).

## Instructors

<div class="role">
  {% assign instructors = site.staffers | where: 'role', 'Instructor' %}
  {% for staffer in instructors %}
  {{ staffer }}
  {% endfor %}
</div>

## Lead GSI
<div class="role">
  {% assign lead_gsi = site.staffers | where: 'role', 'Lead GSI' %}
  {% for staffer in lead_gsi %}
  {{ staffer }}
  {% endfor %}
</div> 

## GSIs

<div class="role">
  {% assign gsis = site.staffers | where: 'role', 'GSI' %}
  {% for staffer in gsis %}
  {{ staffer }}
  {% endfor %}
</div>

## Tech GSI

<div class="role">
  {% assign tech_gsi = site.staffers | where: 'role', 'Tech GSI' %}
  {% for staffer in tech_gsi %}
  {{ staffer }}
  {% endfor %}
</div>

## Tutors

Through the Dream Office at the School of Public Health, we offer weekly group tutoring sessions where we review concepts from the current week's lecture material, work through example questions and live coding exercises for R concepts, and provide a space for students to ask questions and practice.

Our tutoring sessions are held weekly via Zoom and follow this schedule:
- **Alex Kwong**: Thursdays 6-8 PM
- **Dirk Tolson III**: Wednesdays 6-8 PM

<div class="role">
  {% assign tutor = site.staffers | where: 'role', 'Tutor' %}
  {% for staffer in tutor %}
  {{ staffer }}
  {% endfor %}
</div> 

<!-- ## Course Infrastructure -->
<!-- 
<div class="role">
  {% assign infra = site.staffers | where: 'role', 'Infrastructure' %}
  {% for staffer in infra %}
  {{ staffer }}
  {% endfor %}
</div>
 -->