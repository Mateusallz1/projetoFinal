from django.db.models import fields
from rest_framework import serializers
from .models import Posts, Coments


class ComentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coments
        fields = ('comment_id','body_text','postId')


class PostsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Posts
        fields = ('post_id','title','text')