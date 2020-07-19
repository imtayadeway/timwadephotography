---
layout: default
title: abstract
---

{% for image in site.data.abstract %}
  <img class="img-fluid" src="{{ site.bucket_url }}/{{ image.name }}" alt="{{ image.alt-text }}"/>
{% endfor %}
