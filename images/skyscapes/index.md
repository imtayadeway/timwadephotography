---
layout: default
title: skyscapes
---

{% for image in site.data.skyscapes %}
  <img class="img-fluid" src="{{ site.bucket_url }}/{{ image.name }}" alt="{{ image.alt-text }}"/>
{% endfor %}
