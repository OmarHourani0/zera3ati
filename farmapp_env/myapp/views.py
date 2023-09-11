from django.shortcuts import render
from rest_framework import generics, status
from .models import CustomUser, Treatment, Assistant
from .serializers import CustomUserSerializer, ImageUploadSerializer, AssistantSerializer
from django.contrib.auth import authenticate
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.http import JsonResponse
from django.core.files.uploadedfile import InMemoryUploadedFile
import json
from .ai_module import predict_class
from PIL import Image
import openai as gpt
from django.core.cache import cache
import os
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes


def transform_prediction(data):
    prediction = data.get("prediction", "")
    
    if "Pepper__bell" in prediction:
        prediction = prediction.replace("Pepper__bell", "Bell Pepper")
    
    prediction = prediction.replace("__", " ")
    
    data["prediction"] = prediction
    return data


class CustomUserList(generics.ListCreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer

@csrf_exempt
@api_view(['POST'])
def user_view(request):
    if request.method == 'POST':
        idR = request.data.get('id')
        password = request.data.get('password')

        # Check if user with the given ID exists
        try:
            user = CustomUser.objects.get(id=idR)
        except CustomUser.DoesNotExist:
            user = None

        # If user exists, authenticate
        if user:
            auth_user = authenticate(id=idR, password=password)
            if auth_user:
                # User exists and password is correct
                token, created = Token.objects.get_or_create(user=user)
                return Response({"message": "Logged in successfully!", "token": token.key}, status=status.HTTP_200_OK)
            else:
                # Password is incorrect
                return Response({"error": "Invalid password."}, status=status.HTTP_400_BAD_REQUEST)
        else:
            # If user doesn't exist, create a new user
            serializer = CustomUserSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save()
                token, created = Token.objects.get_or_create(user=serializer.instance)
                return Response({"message": "User created successfully!", "token": token.key}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response({"error": "Invalid request method."}, status=status.HTTP_400_BAD_REQUEST)


@csrf_exempt
@api_view(['POST'])
def login_view(request):
    if request.method == 'POST':
        idR = request.data.get('id')
        password = request.data.get('password')

        # Check if user with the given ID exists
        try:
            user = CustomUser.objects.get(id=idR)
        except CustomUser.DoesNotExist:
            return Response({"error": "User does not exist."}, status=status.HTTP_404_NOT_FOUND)

        # Authenticate user
        auth_user = authenticate(id=idR, password=password)
        if auth_user:
            # User exists and password is correct
            token, created = Token.objects.get_or_create(user=user)
            return Response({"message": "Logged in successfully!", "token": token.key}, status=status.HTTP_200_OK)
        else:
            # Password is incorrect
            return Response({"error": "Invalid password."}, status=status.HTTP_400_BAD_REQUEST)

    return Response({"error": "Invalid request method."}, status=status.HTTP_400_BAD_REQUEST)


@csrf_exempt
@api_view(['POST'])
def signup_view(request):
    if request.method == 'POST':
        idR = request.data.get('id')

        # Check if user with the given ID already exists
        try:
            user = CustomUser.objects.get(id=idR)
            return Response({"error": "User with this ID already exists."}, status=status.HTTP_400_BAD_REQUEST)
        except CustomUser.DoesNotExist:
            pass

        # Create a new user
        serializer = CustomUserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            token, created = Token.objects.get_or_create(user=serializer.instance)
            return Response({"message": "User created successfully!", "token": token.key}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    return Response({"error": "Invalid request method."}, status=status.HTTP_400_BAD_REQUEST)



@api_view(['POST'])
def user_login_or_register(request):
    if request.method != 'POST':
        return Response({"error": "Method not allowed."}, status=status.HTTP_405_METHOD_NOT_ALLOWED)

    idR = request.data.get('idR')
    password = request.data.get('password')

    # Check if user with the given ID exists
    try:
        user = CustomUser.objects.get(id=idR)
    except CustomUser.DoesNotExist:
        user = None

    # If user exists, authenticate
    if user:
        auth_user = authenticate(id=idR, password=password)
        if auth_user:
            # User exists and password is correct
            token, created = Token.objects.get_or_create(user=user)
            return Response({"message": "Logged in successfully!", "token": token.key}, status=status.HTTP_200_OK)
        else:
            # Password is incorrect
            return Response({"error": "Invalid password."}, status=status.HTTP_400_BAD_REQUEST)
    else:
        # If user doesn't exist, create a new user
        serializer = CustomUserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            token, created = Token.objects.get_or_create(user=serializer.instance)
            return Response({"message": "User created successfully!", "token": token.key}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
@api_view(['POST'])
def run_ai(request):
    if request.method == 'POST':
        token = request.META.get('HTTP_AUTHORIZATION').split()[1]
        user = Token.objects.get(key=token).user

        serializer = ImageUploadSerializer(data=request.data)
        
        if serializer.is_valid():
            # Get the image from the validated data
            image = serializer.validated_data['image']

            # Check if the image is in memory or a temporary file
            if isinstance(image, InMemoryUploadedFile):
                # Handle in-memory uploaded file
                temp_filename = "/tmp/temp_uploaded_image.jpg"
                with open(temp_filename, 'wb+') as destination:
                    for chunk in image.chunks():
                        destination.write(chunk)
                temp_image_path = temp_filename
            else:
                temp_image_path = image.temporary_file_path()

            # Get prediction using AI function
            predicted_class = predict_class(temp_image_path)

            # Transform the prediction
            data = {
                'prediction': predicted_class
            }
            data["prediction"] = transform_prediction(data)["prediction"]

            # Construct the prompt for GPT
            prompt_text = f"What are the most effective and specific treatment methods for managing and eliminating {data['prediction']}? Please provide a detailed explanation of the steps, techniques, and products that can be used to effectively treat this plant disease."

            treatment_obj, created = Treatment.objects.get_or_create(
                prompt=prompt_text
            )

            if created:
                # If the Treatment object was newly created, it means the prompt was not previously in the database.
                # Hence, query GPT to get the treatment
                gpt.organization = "org-9r1abh0a9gJPObJuqkE3cmiw"
                gpt.api_key = "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"  # Directly setting the API key (not recommended for production)

                response = gpt.ChatCompletion.create(
                    model="gpt-3.5-turbo-0613",
                    messages=[
                        {"role": "user", "content": prompt_text}
                    ]
                )
                treatment = response.choices[0].message['content'].strip()

                # Update the treatment in the database for the newly created Treatment object
                treatment_obj.response = treatment
                treatment_obj.save()

            else:
                # If not created, it means the Treatment object was already in the database.
                # Hence, simply retrieve the treatment from the Treatment object
                treatment = treatment_obj.response

            final_response = {
                'prediction': data['prediction'],
                'treatment': treatment
            }

            return JsonResponse(final_response)
        else:
            return JsonResponse(serializer.errors, status=400)


@csrf_exempt
@api_view(['POST'])
def login_view_assistant(request):
    if request.method == 'POST':
        idR = request.data.get('id')
        password = request.data.get('password')
        name = request.data.get('name')

        # Check if user with the given ID exists
        try:
            user = CustomUser.objects.get(id=idR)
        except CustomUser.DoesNotExist:
            return Response({"error": "User does not exist."}, status=status.HTTP_404_NOT_FOUND)

        # Authenticate user
        auth_user = authenticate(id=idR, password=password)
        if auth_user:
            # User exists and password is correct
            token, created = Token.objects.get_or_create(user=user)
            return Response({"message": "Logged in successfully!", "token": token.key}, status=status.HTTP_200_OK)
        else:
            # Password is incorrect
            return Response({"error": "Invalid password."}, status=status.HTTP_400_BAD_REQUEST)

    return Response({"error": "Invalid request method."}, status=status.HTTP_400_BAD_REQUEST)


@csrf_exempt
@api_view(['POST'])
def signup_view_assistant(request):
    if request.method == 'POST':
        idR = request.data.get('id')
        name = request.data.get('name')

        # Check if user with the given ID already exists
        try:
            user = Assistant.objects.get(id=idR)
            return Response({"error": "Assistant with this ID already exists."}, status=status.HTTP_400_BAD_REQUEST)
        except Assistant.DoesNotExist:
            pass

        # Create a new assistant
        serializer = AssistantSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            token, created = Token.objects.get_or_create(user=serializer.instance)
            return Response({"message": "Assistant created successfully!", "token": token.key}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    return Response({"error": "Invalid request method."}, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
@api_view(['POST'])
@permission_classes([IsAuthenticated])  # Ensure the user is authenticated
def Call_Assistant(request):
    user_id = request.data.get('user_id')
    assistant_name = request.data.get('assistant_name')

    # Verify the user ID
    try:
        user = CustomUser.objects.get(id=user_id)
    except CustomUser.DoesNotExist:
        return JsonResponse({'error': 'User not found'}, status=404)

    # Verify the assistant name
    try:
        assistant = Assistant.objects.get(name=assistant_name)
    except Assistant.DoesNotExist:
        return JsonResponse({'error': 'Assistant not found'}, status=404)

    # Return the ID of the assistant
    return JsonResponse({'assistant_id': assistant.id})