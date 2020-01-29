from django.shortcuts import render
from django.http import HttpResponse
from django.http import Http404
from .models import Job

# Create your views here.

def home(request):
    jobs = Job.objects.all()
    return render(request, "myjobs/home.html", {"jobs": jobs})

def job_detail(request, id):
    try:
        job = Job.objects.get(id=id)
    except Job.DoesNotExist:
        raise Http404("Page not found...")
    return render(request, "myjobs/job_detail.html", {"job": job})