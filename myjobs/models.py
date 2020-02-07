from django.db import models
import datetime
from django.utils.timesince import timesince

# Create your models here.
class Job(models.Model):
    title = models.CharField(max_length=30)
    company = models.CharField(max_length=30)
    location = models.CharField(max_length=30)
    description = models.TextField(max_length=5000)
    start_date = models.DateField(blank=False)
    end_date = models.DateField(blank=True, null=True)
    projects = models.TextField(max_length=5000, blank=True, null=True)
    photo = models.ImageField(upload_to="media/", null=True, blank=False, default="/media/unavailable.jpg")

    def __str__(self):
        return f"{self.title} at {self.company}"

    def get_time_dif(self):
        dummytime = datetime.time(0, 0)
        dummydate = datetime.date.today()
        if (self.end_date):
            dt1 = datetime.datetime.combine(self.start_date, dummytime)
            dt2 = datetime.datetime.combine(self.end_date, dummytime)
            return timesince(dt1, dt2)
        else:
            dt1 = datetime.datetime.combine(self.start_date, dummytime)
            dt2 = datetime.datetime.combine(dummydate, dummytime)
            return timesince(dt1, dt2)


class Technology(models.Model):
    name = models.CharField(max_length=30)
    description = models.TextField(max_length=500)
    img = models.ImageField(upload_to="media/", null=True, blank=False, default="/media/unavailable.jpg")

    def __str__(self):
        return f"{self.name}"