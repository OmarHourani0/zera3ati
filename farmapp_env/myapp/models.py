from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.contrib.auth.models import Group, Permission
from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models
from django.utils.translation import gettext_lazy as _
from django.shortcuts import render
from django.contrib.auth.decorators import login_required
import re
from django.core.validators import RegexValidator
from django.contrib.auth.models import User

from PIL import Image

phone_regex = RegexValidator(
    regex=r'^\+9627\d{8}$',
    message="Phone number must be entered in the format: '+9627xxxxxxxx'. Only 10 digits allowed."
)


class LoginInstance(models.Model):
    timestamp = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey('myapp.CustomUser', on_delete=models.CASCADE, null=True, blank=True)



class Treatment(models.Model):
    prompt = models.TextField(unique=True)
    prompt_ar = models.TextField(unique=True, null=True, blank=True)
    response = models.TextField()
    response_ar = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

class CustomUserManager(BaseUserManager):
    def create_user(self, id, password=None, **extra_fields):
        if not id:
            raise ValueError('The ID field must be set')
        user = self.model(id=id, **extra_fields)
        user.set_password(password)
        user.full_clean()  # This will enforce all validators
        user.save(using=self._db)
        return user

    def create_superuser(self, id, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(id, password, **extra_fields)

class CustomUser(AbstractBaseUser, PermissionsMixin):
    id = models.CharField(validators=[phone_regex], max_length=13, unique=True, primary_key=True)
    firebase_token = models.TextField(null=True, blank=True)  # Optional field for Firebase token
    date_joined = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    name = models.CharField(max_length=255, null=True, blank=True)

    # Override the groups and user_permissions fields to provide custom related_name
    groups = models.ManyToManyField(
        Group,
        verbose_name=_('groups'),
        blank=True,
        help_text=_(
            'The groups this user belongs to. A user will get all permissions '
            'granted to each of their groups.'
        ),
        related_name="customuser_groups",  # Custom related_name
        related_query_name="customuser",
    )
    user_permissions = models.ManyToManyField(
        Permission,
        verbose_name=_('user permissions'),
        blank=True,
        help_text=_('Specific permissions for this user.'),
        related_name="customuser_user_permissions",  # Custom related_name
        related_query_name="customuser",
    )

    objects = CustomUserManager()

    USERNAME_FIELD = 'id'
    REQUIRED_FIELDS = []

    def save(self, *args, **kwargs):
        # Enforce password requirements
        password_regex = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+{}":;\',.<>?~\-\[\]=]).{8,}$'
        if not re.match(password_regex, self.password):
            raise ValueError('Password must be at least 8 characters long, contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.')
        super(CustomUser, self).save(*args, **kwargs)

    def __str__(self):
        return str(self.id)


class Assistant(CustomUser):
    # If you want to add any additional fields specific to the assistant, you can add them here.
    # For example:
    pass


class AllLogin(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return str(self.user) + ': ' + str(self.date)
