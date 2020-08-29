# Generated by Django 2.2.12 on 2020-05-27 19:51

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ("autodo", "0001_initial"),
    ]

    operations = [
        migrations.AlterField(
            model_name="todo",
            name="completionOdomSnapshot",
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.CASCADE,
                to="autodo.OdomSnapshot",
            ),
        ),
        migrations.AlterField(
            model_name="todo",
            name="daysRepeatInterval",
            field=models.IntegerField(blank=True, default=None, null=True),
        ),
        migrations.AlterField(
            model_name="todo",
            name="dueDate",
            field=models.DateTimeField(blank=True, default=None, null=True),
        ),
        migrations.AlterField(
            model_name="todo",
            name="dueMileage",
            field=models.FloatField(blank=True, default=None, null=True),
        ),
        migrations.AlterField(
            model_name="todo",
            name="mileageRepeatInterval",
            field=models.FloatField(blank=True, default=None, null=True),
        ),
        migrations.AlterField(
            model_name="todo",
            name="monthsRepeatInterval",
            field=models.IntegerField(blank=True, default=None, null=True),
        ),
        migrations.AlterField(
            model_name="todo",
            name="yearsRepeatInterval",
            field=models.IntegerField(blank=True, default=None, null=True),
        ),
    ]
