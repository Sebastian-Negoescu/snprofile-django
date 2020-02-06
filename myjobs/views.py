from django.shortcuts import render
from django.http import HttpResponse
from django.http import Http404
from .models import Job
from .models import Technology

# Create your views here.

def home(request):
    jobs = Job.objects.all().order_by('-start_date')
    return render(request, "myjobs/home.html", {"jobs": jobs})

def job_detail(request, id):
    try:
        job = Job.objects.get(id=id)
    except Job.DoesNotExist:
        raise Http404("Page not found...")
    return render(request, "myjobs/job_detail.html", {"job": job})

def about(request):
    try:
        techs = Technology.objects.all()
    except Technology.DoesNotExist:
        raise Http404("Technology does not exist in the DB...")
    return render(request, "myjobs/about.html", {"techs": techs})