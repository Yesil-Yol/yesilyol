# Generated by Django 3.1.7 on 2022-02-12 11:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0002_auto_20220212_1058'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='article',
            name='details',
        ),
        migrations.AddField(
            model_name='article',
            name='category',
            field=models.CharField(blank=True, max_length=20),
        ),
    ]