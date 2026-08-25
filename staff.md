---
layout: page
title: Staff
nav_order: 3
description: A listing of all the course staff members.
---

# Staff

For lab section and office hour schedules for each GSI, see the [calendar]({{ site.baseurl }}/calendar).

## Instructor

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

## Tutor

<div class="role">
  {% assign tutor = site.staffers | where: 'role', 'Tutor' %}
  {% for staffer in tutor %}
  {{ staffer }}
  {% endfor %}
</div> 
