---
layout: default
title: personal
---

{% for image in site.data.personal %}
  <img class="img-fluid" src="{{ site.bucket_url }}/{{ image.name }}" alt="{{ image.alt-text }}"/>
{% endfor %}
