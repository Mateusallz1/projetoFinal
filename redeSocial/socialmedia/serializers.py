from django.db.models import fields
from rest_framework import serializers
from .models import Posts, Coments


class ComentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coments
        fields = ('body_text')


class PostsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Posts
        fields = ('text', 'post_coments')