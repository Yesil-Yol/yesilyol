from accounts.views import LikePostViewSet,LikeUserViewSet,SeePostViewSet,SecondLikeUserViewSet,ArticleCreateViewSet,ArticleImageViewSet,UserViewSet,ArticleViewSet,CommentViewSet,RecycleBinViewSet
from django.conf.urls import url,include
from rest_framework import routers
from rest_framework.authtoken import views

router = routers.DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'articles', ArticleViewSet)
router.register(r'articlecreate', ArticleCreateViewSet)
router.register(r'articleimages', ArticleImageViewSet)
router.register(r'comments', CommentViewSet)
router.register(r'userlikes', LikeUserViewSet)
router.register(r'usersecondlikes', SecondLikeUserViewSet)
router.register(r'postlikes', LikePostViewSet)
router.register(r'postviews', SeePostViewSet)
router.register(r'recyclebins', RecycleBinViewSet)

urlpatterns = [url(r'', include(router.urls)),]

