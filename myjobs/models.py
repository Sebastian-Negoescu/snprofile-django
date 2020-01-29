from django.db import models

# Create your models here.
class Job(models.Model):
    title = models.CharField(max_length=30)
    company = models.CharField(max_length=30)
    location = models.CharField(max_length=30)
    description = models.TextField(max_length=300)
    start_date = models.DateField(blank=False)
    end_date = models.DateField(blank=True, null=True)

    # def __str__(self):
    #     return f"{self.title} at {self.company}"