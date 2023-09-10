from rest_framework import serializers
from .models import CustomUser
import re
from PIL import Image


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ('id', 'password')
        extra_kwargs = {
            'password': {'write_only': True}  # Ensure password is not returned in API responses
        }

    def validate_password(self, value):
        """
        Validate the password to ensure it meets the requirements.
        """
        password_regex = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+{}":;\',.<>?~\-\[\]=]).{8,}$'
        if not re.match(password_regex, value):
            raise serializers.ValidationError(
                'Password must be at least 8 characters long, contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.'
            )
        return value

    def create(self, validated_data):
        """
        Override the default create method to handle password hashing.
        """
        user = CustomUser.objects.create_user(
            id=validated_data['id'],
            password=validated_data['password']
        )
        return user

class ImageUploadSerializer(serializers.Serializer):
    image = serializers.ImageField()

class generateuidAgora(serializers.Serializer):
    channelName = serializers.CharField(max_length=100)
    uid = serializers.IntegerField()