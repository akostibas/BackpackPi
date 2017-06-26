from django.shortcuts import render
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django import template
from .models import GuestPost

import subprocess

def index(requet):


    posts = GuestPost.objects.all()
    return render_to_response('guestbook/guestbook.html', {
        'temp': get_temp(),
        'posts': posts,
        })


def get_temp():
    command = 'sudo vcgencmd measure_temp'
    output = subprocess.check_output(command.split()).decode('utf8')
    degrees = output.strip().split('=')[1]
    return degrees
