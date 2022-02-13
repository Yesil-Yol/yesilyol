from accounts.serializers import  UserViewSerializer,ArticleImageViewSerializer,ArticleViewSerializer,ArticleCreateViewSerializer,CommentViewSerializer,LikePostViewSerializer,LikeUserViewSerializer,SecondLikeUserViewSerializer,SeePostViewSerializer,RecycleBinSerializer
from accounts.models import User,Article,Comment,ArticleImage,LikePost,SeePost,SecondLikeUser,LikeUser,RecycleBin
from rest_framework import serializers, viewsets

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserViewSerializer 

class ArticleViewSet(viewsets.ModelViewSet):
    queryset = Article.objects.all().order_by('-timestamp')
    serializer_class = ArticleViewSerializer 

class ArticleCreateViewSet(viewsets.ModelViewSet):
    queryset = Article.objects.all()
    serializer_class = ArticleCreateViewSerializer 

class ArticleImageViewSet(viewsets.ModelViewSet):
    queryset = ArticleImage.objects.all()
    serializer_class = ArticleImageViewSerializer

class RecycleBinViewSet(viewsets.ModelViewSet):
    queryset = RecycleBin.objects.all()
    serializer_class = RecycleBinSerializer  

class CommentViewSet(viewsets.ModelViewSet):
    queryset = Comment.objects.all().order_by('-timestamp')
    serializer_class = CommentViewSerializer 

class LikePostViewSet(viewsets.ModelViewSet):
    queryset = LikePost.objects.all().order_by('-timestamp')
    serializer_class = LikePostViewSerializer

class SeePostViewSet(viewsets.ModelViewSet):
    queryset = SeePost.objects.all().order_by('-timestamp')
    serializer_class = SeePostViewSerializer

class LikeUserViewSet(viewsets.ModelViewSet):
    queryset = LikeUser.objects.all().order_by('-timestamp')
    serializer_class = LikeUserViewSerializer

class SecondLikeUserViewSet(viewsets.ModelViewSet):
    queryset = SecondLikeUser.objects.all().order_by('-timestamp')
    serializer_class = SecondLikeUserViewSerializer


