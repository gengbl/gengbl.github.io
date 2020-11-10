---
title: 大事记
type: event
# All the Event of posts.
# v2.0
# https://github.com/cotes2020/jekyll-theme-chirpy
# © 2017-2019 Cotes Chung
# MIT License
---

{% comment %}
  'site.events' looks like a Map, e.g. site.events.MyEvent.[ Post0, Post1, ... ]
  Print the {{ site.events }} will help you to understand it.
{% endcomment %}
<div id="events" class="d-flex flex-wrap ml-xl-2 mr-xl-2">
{% assign events = "" | split: "" %}
{% for t in site.events %}
  {% assign events = events | push: t[0] %}
{% endfor %}

{% assign sorted_events = events | sort_natural %}

{% for t in sorted_events %}
  <div>
    <a class="event" href="{{ site.baseurl }}/events/{{ t | replace: ' ', '-' | downcase | url_encode }}/">{{ t }}<span class="text-muted">{{ site.events[t].size }}</span></a>
  </div>
{% endfor %}

</div>
