from django.contrib import admin
from .models import Job

# Register your models here.

@admin.register(Job)
class MyJobs(admin.ModelAdmin):
    list_display = ["title", "company"]

    # def __str__(self):
    #     return self.title, self.company