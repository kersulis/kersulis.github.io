---
layout: page
title: Archive
---

## Posts

{% for post in site.posts %}
  * {{ post.date | date_to_string }} &raquo; [ {{ post.title }} ]({{ site.baseurl }}{{ post.url | remove_first:'/' }})
{% endfor %}