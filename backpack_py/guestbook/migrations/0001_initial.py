# -*- coding: utf-8 -*-
# Generated by Django 1.11.2 on 2017-06-26 00:46
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='GuestPost',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50)),
                ('message', models.TextField(max_length=350)),
                ('email', models.EmailField(max_length=254)),
                ('created_on', models.DateTimeField()),
            ],
        ),
    ]
