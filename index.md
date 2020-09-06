---
layout: default
title: home
---

{% for image in site.data.thumbs %}
  {% cycle  '<div class="row">', '', '' %}
    <div class="col-sm-4">
      <a href="/images/{{ image.category }}">
        <div class="card bg-dark text-white" style="margin: 15px 0px;">
          <img class="img-fluid img-thumbnail" src="{{ site.bucket_url }}/{{ image.name }}" />
          <!-- alt="{ category[1][0].alt-text }"/> -->
          <div class="card-img-overlay">
            <p class="h5 card-title">{{ image.category }}</p>
          </div>
        </div>
      </a>
    </div>
  {% cycle '', '', '</div>' %}
{% endfor %}
