from django.contrib import admin
from django.urls import path
from myapp.views import CustomUserList, user_view, user_login_or_register, login_view, signup_view, run_ai

urlpatterns = [
    path('login/', login_view, name='login_view'),
    path('users/', user_login_or_register, name='user_register_view'),
    path('signup/', signup_view, name='signup_view'),
    path('submit_img/', run_ai, name='run_ai')

]
