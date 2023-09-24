from django.contrib import admin, messages
from .models import Treatment, CustomUser, Assistant
from fcm_django.models import FCMDevice
from fcm_django.admin import DeviceAdmin as DefaultFCMDeviceAdmin

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

def send_notification(modeladmin, request, queryset):
    for device in queryset:
        try:
            device.send_message(title="Test title", body="Test body", icon=...)
        except Exception as e:
            messages.error(request, f"Error sending to device {device.id}: {e}")
        else:
            messages.success(request, f'Notification sent to device {device.id}!')

send_notification.short_description = "Send FCM Notification"

class CustomFCMDeviceAdmin(DefaultFCMDeviceAdmin):
    list_display = ['name', 'active', 'user', 'date_created']
    actions = [send_notification]

# Register FCMDevice with the custom admin class
admin.site.unregister(FCMDevice)  # Unregister the default admin
admin.site.register(FCMDevice, CustomFCMDeviceAdmin)
