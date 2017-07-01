from django.shortcuts import redirect
from django.shortcuts import render
from django.shortcuts import render_to_response
from django.http import HttpResponse, HttpResponseRedirect
from django import template
from .models import GuestPost
from .forms import GuestPostForm

import subprocess

def index(request):
    form = GuestPostForm()

    posts = GuestPost.objects.order_by('-created_on')
    return render_to_response('guestbook/guestbook.html', {
        'temp': get_temp(),
        'posts': posts,
        'form': form,
        })

def post(request):
    if request.method == "POST":
        f = GuestPostForm(request.POST)
        if f.is_valid():
            f.save()
        return render_to_response('guestbook/post.html', {
            'temp': get_temp()
            })

    return HttpResponseRedirect('/guestbook/')

def get_temp():
    command = 'sudo vcgencmd measure_temp'
    output = subprocess.check_output(command.split()).decode('utf8')
    degrees = output.strip().split('=')[1]
    return degrees
