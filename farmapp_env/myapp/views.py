from django.shortcuts import render
from rest_framework import generics, status
from .models import CustomUser, Treatment, Assistant, LoginInstance
from .serializers import CustomUserSerializer, ImageUploadSerializer, AssistantSerializer
from django.contrib.auth import authenticate
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.http import JsonResponse
from django.core.files.uploadedfile import InMemoryUploadedFile
import json
from .ai_module import predict_class, predict_crop, MarketPrice
from PIL import Image
import openai as gpt
from django.core.cache import cache
import os
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes
from django.http import StreamingHttpResponse
import time
import asyncio
import random
import requests
from django.contrib.auth.signals import user_logged_in
from django.http import HttpResponse
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer

mp=MarketPrice()



def translate_with_google(text, target_language):
    API_KEY = 'AIzaSyATDMOqTnKBJa7BiDpZ5F2vjOrrzjsVYjw'  # Replace with your Google API key
    API_ENDPOINT = f'https://translation.googleapis.com/language/translate/v2?key={API_KEY}'

    params = {
        'q': text,
        'target': target_language,
        'source': 'en'  # Assuming source language is English
    }

    response = requests.post(API_ENDPOINT, params=params)
    
    if response.status_code == 200:
        translated_text = json.loads(response.text)['data']['translations'][0]['translatedText']
        return translated_text
    else:
        print(f"Error with status code: {response.status_code}: {response.text}")
        return None


def transform_prediction_n(data):
    prediction = data.get("prediction", "")
    
    if "Pepper__bell" in prediction:
        prediction = prediction.replace("Pepper__bell", "Bell Pepper")
    
    prediction = prediction.replace("__", " ")
    
    data["prediction"] = prediction
    return data


class CustomUserList(generics.ListCreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer


#this function is depricated and is not used anymore
@csrf_exempt
@api_view(['POST'])
def user_view(request):
    if request.method == 'POST':
        idR = request.data.get('id')
        password = request.data.get('password')
        firebase_token = request.data.get('firebase_token', None)  # Get the optional firebase_token

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
            serializer_data = {
                'id': idR,
                'password': password
            }
            if firebase_token:
                serializer_data['firebase_token'] = firebase_token

            serializer = CustomUserSerializer(data=serializer_data)
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
        language = request.data.get('language')

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
            name = user.name
            user_logged_in.send(sender=user.__class__, request=request, user=user)

            return Response({"message": "Logged in successfully!", "token": token.key, "name": name }, status=status.HTTP_200_OK)
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

        language = request.data.get('language', 'en')

        serializer = ImageUploadSerializer(data=request.data)
        
        if serializer.is_valid():
            image = serializer.validated_data['image']

            if isinstance(image, InMemoryUploadedFile):
                temp_filename = "/tmp/temp_uploaded_image.jpg"
                with open(temp_filename, 'wb+') as destination:
                    for chunk in image.chunks():
                        destination.write(chunk)
                temp_image_path = temp_filename
            else:
                temp_image_path = image.temporary_file_path()

            predicted_class = predict_class(temp_image_path)

            data = {
                'prediction': predicted_class
            }
            data["prediction"] = transform_prediction_n(data)["prediction"]

            prompt_text = f"What are the most effective and specific treatment methods for managing and eliminating {data['prediction']}? Please provide a detailed explanation of the steps, techniques, and products that can be used to effectively treat this plant disease."
            translated_prediction = None

            # Translate the prediction into Arabic if language is 'ar'
            if language == 'ar':

                translated_prediction = translate_with_google(data["prediction"], "ar")
                prompt_text_ar = f"ما هي طرق العلاج الأكثر فعالية وتحديدًا لإدارة {translated_prediction} والقضاء عليها؟ يرجى تقديم شرح مفصل للخطوات والتقنيات والمنتجات التي يمكن استخدامها لعلاج هذا المرض النباتي بشكل فعال."

            if language == 'en':
                treatment_obj, created = Treatment.objects.get_or_create(prompt=prompt_text)
            else:
                treatment_obj, created = Treatment.objects.get_or_create(prompt_ar=prompt_text_ar)

            if created:
                gpt.organization = "org-9r1abh0a9gJPObJuqkE3cmiw"
                gpt.api_key = "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"
                if language == 'en':
                    response = gpt.ChatCompletion.create(
                        model="gpt-3.5-turbo-0613",
                        messages=[
                            {"role": "user", "content": prompt_text}
                        ]
                    )
                    treatment = response.choices[0].message['content'].strip()
                    treatment_obj.response = treatment

                else:
                    response_ar = gpt.ChatCompletion.create(
                        model="gpt-3.5-turbo-0613",
                        messages=[
                            {"role": "user", "content": prompt_text_ar}
                        ]
                    )
                    treatment_ar = response_ar.choices[0].message['content'].strip()
                    treatment_obj.response_ar = treatment_ar

                treatment_obj.save()

            else:
                if language == 'en':
                    treatment = treatment_obj.response
                else:
                    treatment_ar = treatment_obj.response_ar

            final_response = {
                'prediction_en': data['prediction'],
                'prediction_ar': translated_prediction if translated_prediction else None,
                'treatment_en': treatment if language == 'en' else None,
                'treatment_ar': treatment_ar if language == 'ar' else None
            }
            return JsonResponse(final_response)
        else:
            return JsonResponse(serializer.errors, status=400)
    return JsonResponse({"error": "Invalid request method."}, status=400)


@csrf_exempt
@api_view(['POST'])
def run_crop_ai(request):
    if request.method == 'POST':
        # Extract the parameters from the request
        N = request.data.get('N')
        P = request.data.get('P')
        K = request.data.get('K')
        temperature = request.data.get('temperature')
        humidity = request.data.get('humidity')
        ph = request.data.get('ph')
        rainfall = request.data.get('rainfall')
        
        # Extract the language from the request, default to 'en' if not provided
        language = request.data.get('language')
        print(language)

        # Load the translations dictionary
        file_path = r'C:\Users\jacks\anaconda3\envs\farmapp_env\zera3ati\farmapp_env\myapp\dictionary.json'
        with open(file_path, 'r', encoding='utf-8') as file:
            translations = json.load(file)

        # Get prediction using AI function
        predicted_crop = predict_crop(N, P, K, temperature, humidity, ph, rainfall)

        # If the language is 'ar', translate the prediction
        if language == 'ar':
            if predicted_crop in translations:
                print("found")
                predicted_crop = translations[predicted_crop]
            else:
                # Translate prediction using Google Translate API
                print('calling translate api')
                translated_crop = translate_with_google(predicted_crop, "ar")
                # Add the new translation to the dictionary
                translations[predicted_crop] = translated_crop
                # Update the JSON file with the new translation
                with open(file_path, 'w', encoding='utf-8') as file:
                    json.dump(translations, file, ensure_ascii=False, indent=4)
                # Update the prediction to the translated version
                predicted_crop = translated_crop

        # Prepare the response data
        data = {
            'prediction': predicted_crop
        }
        print(data['prediction'])
        return JsonResponse(data)

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
        user_id = 962712345679  # Not sure why you're setting this static value here
    except CustomUser.DoesNotExist:
        return JsonResponse({'error': 'User not found'}, status=404)

    # Verify the assistant name
    try:
        assistant = Assistant.objects.get(name=assistant_name)
        channel_layer = get_channel_layer()
        
        #get assistant id stripped of all "+"
        assistantid = assistant.id.replace('+', '')
        room_group_name = f"chat_{assistantid}"
        print(assistantid)
        
        # Use async_to_sync to make async call from synchronous context
        async_to_sync(channel_layer.group_send)(
            room_group_name,
            {
                'type': 'chat.message',  # This is the change. Use a known message type.
                'message': f"Chat request from user {user_id}",
                'sender_channel_name': "SYSTEM",
                # You might want to add the user's channel name or other details if necessary
            }
        )

    except Assistant.DoesNotExist:
        return JsonResponse({'error': 'Assistant not found'}, status=418)

    # Return the ID of the assistant
    return JsonResponse({'assistant_id': assistant.id})

async def generate_data():
    while True:
        data = random.randint(1, 100)
        yield f"data: {data}\n\n"
        await asyncio.sleep(3)

async def event_stream(request):
    response = StreamingHttpResponse(generate_data(), content_type="text/event-stream")
    response['Cache-Control'] = 'no-cache'
    response['Connection'] = 'keep-alive'
    return response

@csrf_exempt
def sse(request):
    response = StreamingHttpResponse(event_stream(), content_type='text/event-stream')
    response['Cache-Control'] = 'no-cache'
    return response

@api_view(['GET'])
def last_login_instance(request):
    try:
        last_login = LoginInstance.objects.latest('timestamp')
        response_data = {
            'timestamp': last_login.timestamp.strftime('%Y-%m-%d %H:%M:%S'),
            'user_id': last_login.user.id if last_login.user else None
                            }
    except LoginInstance.DoesNotExist:
        response_data = {
            'error': 'No login instances found'
        }
    return JsonResponse(response_data)


translation_dict = {
    'Tomato': 'Tomatoes',
    'Cucumber': 'Cucumbers',
    'Eggplant': 'Eggplants (aubergines)',
    'Potato': 'Potatoes',
    'Onion': 'Onions and shallots, green',
    'Watermelon': 'Watermelons',
    'Cantaloupe': 'Cantaloupes',
    'Grapes': 'Grapes',
    'Pomegranate': 'Pomegranates',
    'Fig': 'Figs',
    'Strawberries': 'Strawberries'
}

def round_and_divide_nested_values(data):
    for key, value_list in data.items():
        for i, (crop, num) in enumerate(value_list):
            value_list[i] = [crop, round(abs(num) / 1000, 2)]
    return data

@csrf_exempt
@api_view(['POST'])
@permission_classes([IsAuthenticated])  # Ensure the user is authenticated
def display_market_price(request):
    data = json.loads(request.body)
    language = data.get('language', 'en')
    crops_list = data.get('crops_list', None)
    specified_month = data.get('specified_month', None)
    
    # Translate the crops_list using the translation_dict
    translated_crops_list = [translation_dict.get(crop.split('|')[0], crop.split('|')[0]) for crop in crops_list]
    
    # Print all variables
    crops_list_str = str(translated_crops_list)
    print(language + crops_list_str + specified_month)
    result = mp.get_prices(language, translated_crops_list, specified_month)
    
    # Process the result to divide by 1000 and round
    result = round_and_divide_nested_values(result)
    
    return HttpResponse(json.dumps(result), content_type='application/json')
