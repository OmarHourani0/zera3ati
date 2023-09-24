from django.contrib import admin
from django.urls import path
from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from myapp.views import (CustomUserList, user_view, user_login_or_register, login_view, signup_view, run_ai, 
                         login_view_assistant, signup_view_assistant, Call_Assistant, run_crop_ai, sse, event_stream, last_login_instance)
from myapp import consumers
from django.urls import re_path

urlpatterns = [
    path('login/', login_view, name='login_view'),
    path('users/', user_login_or_register, name='user_register_view'),
    path('signup/', signup_view, name='signup_view'),
    path('submit_img/', run_ai, name='run_ai'),
    path('admin/', admin.site.urls),
    path('assistant_login/', login_view_assistant, name='login_view_assistant'),
    path('assistant_signup/', signup_view_assistant, name='signup_view_assistant'),
    path('call_assistant/', Call_Assistant, name='Call_Assistant'),
    path('submit_crop/', run_crop_ai, name='run_crop_ai'),
    path('sse/', sse, name='sse'),
    path('events/', event_stream, name='event_stream'),
    path('last-login/', last_login_instance, name='last_login_instance'),






]
