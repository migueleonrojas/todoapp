# Generated by Django 3.1.7 on 2021-04-02 16:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('autodo', '0004_auto_20210331_1955'),
    ]

    operations = [
        migrations.AddField(
            model_name='todo',
            name='complete',
            field=models.BooleanField(default=False),
        ),
    ]
