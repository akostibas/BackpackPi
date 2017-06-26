from django.shortcuts import render
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django import template

import subprocess

def index(requet):
    return render_to_response('guestbook/guestbook.html', {'temp': get_temp(),})

def get_temp():
    command = 'sudo vcgencmd measure_temp'
    output = subprocess.check_output(command.split()).decode('utf8')
    degrees = output.strip().split('=')[1]
    return degrees
