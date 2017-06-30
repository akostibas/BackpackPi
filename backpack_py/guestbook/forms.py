from django import forms
from .models import GuestPost

class GuestPostForm(forms.ModelForm):
    class Meta:
        model = GuestPost
        fields = ['name', 'email', 'message',]

    def clean_email(self):
        return self.cleaned_data['email'].lower()
