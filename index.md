---
layout: default
title: home
---

{% for image in site.data.thumbs %}
  {% cycle  '<div class="row">', '', '' %}
    <div class="col-md-3">
      <a href="/images/{{ image.category }}">
        <div class="card bg-dark text-white" style="margin: 15px 0px;">
          <img class="img-fluid img-thumbnail" src="{{ site.bucket_url }}/{{ image.name }}" />
          <!-- alt="{ category[1][0].alt-text }"/> -->
          <div class="card-img-overlay">
            <h5 class="card-title">{{ image.category }}</h5>
          </div>
        </div>
      </a>
    </div>
  {% cycle '', '', '</div>' %}
{% endfor %}
