---
layout: default
title: self
---

{% for image in site.data.self %}
  <img class="img-fluid" src="{{ site.bucket }}/{{ image.name }}" alt="{{ image.alt-text }}"/>
{% endfor %}
