from django.contrib.auth import authenticate
from django.contrib.auth.models import update_last_login
from rest_framework_jwt.settings import api_settings
from django.core import serializers
from rest_framework import serializers
from drf_writable_nested.serializers import WritableNestedModelSerializer
from urllib import request
from drf_dynamic_fields import DynamicFieldsMixin
from rest_framework.permissions import AllowAny,IsAuthenticated
from accounts.models import User,Article,Comment,ArticleImage,RecycleBin,LikePost,SeePost,LikeUser,SecondLikeUser
from rest_framework import routers, serializers, viewsets
from django.contrib.auth.hashers import make_password
from django.http import HttpResponse

class ArticleImageViewSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = ArticleImage
        fields = ('id','image','article')

class RecycleBinSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = RecycleBin
        fields = ('id','author','image','locationlat','locationlng','is_activated')

class LikePostViewSerializer(serializers.ModelSerializer):

    class Meta:
        model = LikePost
        fields = ('id',"author","article")

class SeePostViewSerializer(serializers.ModelSerializer):

    class Meta:
        model = SeePost
        fields = ('id',"article","author")

class CommentViewSerializer(serializers.ModelSerializer): 

    class Meta:
        model = Comment
        fields = ('id','content','article','author')


class SecondLikeUserViewSerializer(serializers.ModelSerializer):

    class Meta:
        model = SecondLikeUser
        fields = ('id',"author","profile")

class LikeUserViewSerializer(serializers.ModelSerializer):

    class Meta:
        model = LikeUser
        fields = ('id',"author","profile")


class UserViewSerializer(DynamicFieldsMixin,serializers.ModelSerializer):
    userlikes_set = LikeUserViewSerializer(source='userlikes',required=False,many=True)
    usersecondlikes_set = SecondLikeUserViewSerializer(source='usersecondlikes',required=False,many=True)    

    class Meta:
        model = User
        fields  = ('id','email','username','password','fullname','phone_number','bio','location','image','userlikes_set','usersecondlikes_set')

    def create(self,validated_data):
     user = User.objects.create(
 email=validated_data['email'],
 username=validated_data['username'],
 fullname=validated_data['fullname'],
 bio=validated_data['bio'],
 location=validated_data['location'],
 image=validated_data['image'],
 phone_number=validated_data['phone_number'],
 password = make_password(validated_data['password'])
)
     return user


class ArticleViewSerializer(serializers.ModelSerializer):
    images_set = ArticleImageViewSerializer(source='images',required=False,many=True)
    comments_set = CommentViewSerializer(source='comments',required=False,many=True)
    views_set = SeePostViewSerializer(source='views',required=False,many=True)
    postlikes_set = LikePostViewSerializer(source='postlikes',required=False,many=True)

    class Meta:
        model = Article
        fields = ('id','author','timestamp','location','caption','category','details','targetfund','currentfund','images_set','comments_set','postlikes_set','views_set')

class ArticleCreateViewSerializer(serializers.ModelSerializer):
    images_set = ArticleImageViewSerializer(source='images',required=False,many=True)
    class Meta:
        model = Article
        fields = ('id','timestamp','details','author','location','caption','category','targetfund','images_set')




        

  
          