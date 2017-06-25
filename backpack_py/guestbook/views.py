from django.shortcuts import render
from django.http import HttpResponse

import subprocess

def index(requet):
    return HttpResponse('Hello')

def temp_is(request):
    temp = get_temp()
    html = "<html><body>Current cpu temp: {0}</body></html>".format(temp)
    return HttpResponse(html)

def get_temp():
    command = 'sudo vcgencmd measure_temp'
    output = subprocess.check_output(command.split()).decode('utf8')
    degrees = output.strip().split('=')[1]
    return degrees
