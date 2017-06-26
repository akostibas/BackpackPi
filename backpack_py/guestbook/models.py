from django.db import models

class GuestPost(models.Model):
    name = models.CharField(max_length=50)
    message = models.TextField(max_length=350)
    email = models.EmailField()
    created_on = models.DateTimeField()

    def __str__(self):
        return '{} posted at {}'.format(self.name, self.created_on)
