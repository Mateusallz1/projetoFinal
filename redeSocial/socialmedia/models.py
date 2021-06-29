from django.db import models

# Create your models here.

class Coments(models.Model):
    body_text = models.CharField(max_length=200)

    def __str__(self):
        return self.text

class Posts(models.Model):
    text = models.CharField(max_length=500)
    post_coments = models.ForeignKey(Coments, related_name='coments', on_delete=models.CASCADE)

    class Meta:
        ordering = ('text',)

    def __str__(self):
        return self.text