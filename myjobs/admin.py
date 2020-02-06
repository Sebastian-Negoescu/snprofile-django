from django.contrib import admin
from .models import Job, Technology

# Register your models here.

@admin.register(Job)
class MyWhatever(admin.ModelAdmin):
    list_display = ["id", "title", "company"]

@admin.register(Technology)
class MyTech(admin.ModelAdmin):
    list_display = ["id", "name"]