from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.contrib.auth.models import Group, Permission
from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models
from django.utils.translation import gettext_lazy as _
import re
from PIL import Image


class Treatment(models.Model):
    prompt = models.TextField(unique=True)
    response = models.TextField()
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
    id = models.BigIntegerField(
        primary_key=True,
        validators=[
            MinValueValidator(1000000000),  # Minimum 10 digits
            MaxValueValidator(9999999999)   # Maximum 10 digits
        ]
    )
    date_joined = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

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
