from django.conf.urls import url

from guestbook import views

urlpatterns = [
    url(r'^$', views.index, name='guestbook_index'),
    url(r'^temp/$', views.temp_is, name='guestbook_temp'),
]
