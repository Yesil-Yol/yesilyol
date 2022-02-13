from accounts.models import User,RecycleBin,Article,Comment,ArticleImage,SecondLikeUser,LikePost,SeePost,LikeUser
from django.contrib import admin
from rest_framework.authtoken.admin import TokenAdmin

class RecycleBinAdmin(admin.ModelAdmin):
    list_filter = (
        ('is_activated', admin.BooleanFieldListFilter),
    )


TokenAdmin.raw_id_fields = ['user']
admin.site.register(User)
admin.site.register(Article)
admin.site.register(RecycleBin,RecycleBinAdmin)
admin.site.register(ArticleImage)
admin.site.register(Comment)
admin.site.register(LikeUser)
admin.site.register(SecondLikeUser)
admin.site.register(LikePost)
admin.site.register(SeePost)





