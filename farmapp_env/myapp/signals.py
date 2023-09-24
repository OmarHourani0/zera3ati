from django.contrib.auth.signals import user_logged_in
from django.dispatch import receiver
from .models import LoginInstance
import logging

logger = logging.getLogger(__name__)

@receiver(user_logged_in)
def user_logged_in_receiver(sender, request, user, **kwargs):
    LoginInstance.objects.create(user=user)
