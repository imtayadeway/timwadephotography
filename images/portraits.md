---
layout: default
title: portraits
---

{% for image in site.data.portraits %}
  <img class="img-fluid" src="{{ site.bucket }}/{{ image.name }}" alt="{{ image.alt-text }}"/>
{% endfor %}
