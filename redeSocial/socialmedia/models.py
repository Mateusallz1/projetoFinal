from django.db import models

# Create your models here.

class Posts(models.Model):
    post_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100)
    text = models.CharField(max_length=500)

    class Meta:
        ordering = ('text',)

    def __str__(self):
        return self.text

class Coments(models.Model):
    comment_id = models.AutoField(primary_key=True)
    body_text = models.CharField(max_length=200)
    postId = models.ForeignKey(Posts, related_name='comments', on_delete=models.CASCADE)

    def __str__(self):
        return self.text