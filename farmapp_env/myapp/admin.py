from django.contrib import admin
from .models import Treatment, CustomUser, Assistant

@admin.register(Treatment)
class TreatmentAdmin(admin.ModelAdmin):
    list_display = ['prompt', 'response', 'created_at']
    search_fields = ['prompt', 'response']
    list_filter = ['created_at']

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    list_display = ['id', 'date_joined', 'is_active', 'is_staff']
    search_fields = ['id']
    list_filter = ['date_joined', 'is_active', 'is_staff']

@admin.register(Assistant)
class AssistantAdmin(admin.ModelAdmin):
    list_display = ['id', 'date_joined', 'is_active', 'is_staff']
    search_fields = ['id']
    list_filter = ['date_joined', 'is_active', 'is_staff']


# Register your models here.
