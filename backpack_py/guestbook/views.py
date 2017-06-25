from django.shortcuts import render
from django.http import HttpResponse
from django import template

import subprocess

def index(requet):
    t = template.loader.get_template('guestbook/guestbook.html')
    c = dict({'temp': get_temp()})
    html = t.render(c)
    return HttpResponse(html)

def get_temp():
    command = 'sudo vcgencmd measure_temp'
    output = subprocess.check_output(command.split()).decode('utf8')
    degrees = output.strip().split('=')[1]
    return degrees
