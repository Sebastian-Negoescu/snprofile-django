from django.shortcuts import render
from django.http import HttpResponse
from django.http import Http404
from .models import Job

# Create your views here.

def home(request):
    jobs = Job.objects.all()
    return render(request, "myjobs/home.html", {"jobs": jobs})
