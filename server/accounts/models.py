import uuid
from django.db import models
from django.contrib.auth.models import PermissionsMixin
from django.contrib.auth.models import BaseUserManager, AbstractUser
from django.contrib.postgres.fields import ArrayField
from django.utils.translation import gettext as _


class UserManager(BaseUserManager):

    def create_user(self, email, password=None):
   
        if not email:
            raise ValueError('Users Must Have an email address')
        user = self.model(email=self.normalize_email(email),)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password):

        if password is None:
            raise TypeError('Superusers must have a password.')
        user = self.create_user(email, password)
        user.is_superuser = True
        user.is_staff = True
        user.save()
        return user


class User(AbstractUser,PermissionsMixin):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.CharField(max_length=255,unique=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    username =models.CharField(max_length=80,unique=True,default='SOME STRING')
    fullname = models.CharField(max_length=50, unique=False, null=True, blank=True)
    image = models.ImageField(upload_to='images',null=True,blank=True) 
    phone_number = models.CharField(max_length=30, null=True, blank=True)
    bio = models.CharField(max_length=500,blank=True)
    location = models.CharField(max_length=200,blank=True) 

    


    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []
    objects = UserManager()

    class Meta:
        verbose_name = _('user')
        verbose_name_plural = _('users')



class Article(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = models.ForeignKey(User,on_delete=models.CASCADE,related_name='articles')
    caption = models.CharField(max_length=250, null=True, blank=True)
    details = models.CharField(max_length=250, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    category = models.CharField(max_length=20, null=True, blank=True)
    targetfund = models.IntegerField(default=0, null=False, blank=True)
    currentfund = models.IntegerField(default=0, null=False, blank=True)
    location = models.CharField(max_length=200, null=True, blank=True) 


class ArticleImage(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    image = models.ImageField(upload_to='images',null=True,blank=True,)
    article = models.ForeignKey(Article, on_delete=models.CASCADE,null=True,blank=True, related_name='images')

class Comment(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    article = models.ForeignKey(Article, on_delete=models.CASCADE, related_name='comments')
    author = models.ForeignKey(User,on_delete=models.CASCADE,related_name='comments_set')
    parent = models.ForeignKey('self', null=True, blank=True,on_delete=models.CASCADE, related_name='replies')
    content = models.CharField(max_length=100)
    timestamp = models.DateTimeField(auto_now_add=True)

class RecycleBin(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = models.ForeignKey(User,on_delete=models.CASCADE,related_name='reyclebins_set')
    locationlat = models.CharField(max_length=300, null=True, blank=True)
    locationlng = models.CharField(max_length=300, null=True, blank=True)
    image= models.ImageField(upload_to='images',null=True,blank=True,)
    timestamp = models.DateTimeField(auto_now_add=True)
    is_activated = models.BooleanField(default=False)


class LikeUser(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = models.ForeignKey(User,  on_delete=models.CASCADE,related_name='userlikes_set')
    profile = models.ForeignKey(User,on_delete=models.CASCADE,null=True,related_name='userlikes')
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [models.UniqueConstraint(fields=['author', 'profile'],name='unique_likeuser')]

class SecondLikeUser(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = models.ForeignKey(User,  on_delete=models.CASCADE,related_name='usersecondlikes_set')
    profile = models.ForeignKey(User,on_delete=models.CASCADE,null=True,related_name='usersecondlikes')
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [models.UniqueConstraint(fields=['author', 'profile'],name='unique_secondlikeuser')]

class SeePost(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = models.ForeignKey(User, on_delete=models.CASCADE,related_name='postviews_set')
    article = models.ForeignKey(Article,  on_delete=models.CASCADE,related_name='postviews')
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [models.UniqueConstraint(fields=['author', 'article'],name='unique_viewpost')]

class LikePost(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    author = models.ForeignKey(User, on_delete=models.CASCADE,related_name='postlikes_set')
    article = models.ForeignKey(Article,  on_delete=models.CASCADE,related_name='postlikes')
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [models.UniqueConstraint(fields=['author', 'article'],name='unique_likepost')]

