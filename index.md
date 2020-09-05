---
layout: default
title: home
---

{% assign categories = site.data | map: "first" %}

{% for category in site.data %}
  {% cycle  '<div class="row">', '', '' %}
    <div class="col-md-3">
      <img width="200" height="200" class="img-fluid img-thumbnail" src="{{ site.bucket_url }}/{{ category[1][0].name }}" />
      <!-- alt="{ category[1][0].alt-text }"/> -->
    </div>
  {% cycle '', '', '</div>' %}
{% endfor %}
