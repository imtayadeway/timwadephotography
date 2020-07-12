---
layout: default
title: polaroids
---

{% for image in site.data.polaroids %}
  <img class="img-fluid" src="{{ site.bucket_url }}/{{ image.name }}" alt="{{ image.alt-text }}"/>
{% endfor %}
