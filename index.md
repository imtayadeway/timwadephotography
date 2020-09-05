---
layout: default
title: home
---

{% assign categories = site.data | sort %}
{% for category in categories %}
  {% cycle  '<div class="row">', '', '' %}
    <div class="col-md-3">
      <div class="card bg-dark text-white">
        <img class="img-fluid img-thumbnail" src="{{ site.bucket_url }}/{{ category[1][0].name }}" />
        <!-- alt="{ category[1][0].alt-text }"/> -->
        <div class="card-img-overlay">
          <p class="card-title">{{ category[0] }}</p>
        </div>
      </div>
    </div>
  {% cycle '', '', '</div>' %}
{% endfor %}
