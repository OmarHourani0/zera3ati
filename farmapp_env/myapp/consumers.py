from channels.generic.websocket import AsyncWebsocketConsumer
import json
from channels.generic.websocket import AsyncJsonWebsocketConsumer
import random
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer


class MyConsumer(AsyncJsonWebsocketConsumer):
      async def connect(self):
           await self.accept()

      async def receive(self, text_data=None, bytes_data=None, **kwargs):
            if text_data == 'PING':
                 await self.send('PONG')


class SquareConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        await self.accept()
        await self.send_random_number()

    async def send_random_number(self):
        self.random_number = random.randint(1, 100)
        print(f"Server sending: {self.random_number}")
        await self.send(json.dumps({'number': self.random_number}))

    async def receive(self, text_data=None, bytes_data=None, **kwargs):
        received_data = json.loads(text_data)
        squared_value = received_data.get('squared_value', None)
        print(f"Server received: {squared_value}")

        if squared_value == self.random_number ** 2:
            print("Server: passed")
            await self.send_random_number()
        else:
            print("Server: failed")
            await self.send_random_number()


class ChatConsumer(AsyncJsonWebsocketConsumer):

    async def connect(self):
        # This assumes the username is part of the route. For example: ws/chat/username/
        self.room_name = self.scope['url_route']['kwargs']['username']
        self.room_group_name = f"chat_{self.room_name}"

        # Add user to their group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        # Accept the WebSocket connection
        await self.accept()

    async def disconnect(self, close_code):
        # Remove user from their group
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        target_user = text_data_json['target_user']
        message = text_data_json['message']

        # Add sender's channel name to the message data
        room_group_name = f"chat_{target_user}"
        print(f"Sending message to {room_group_name}: {message}")
        await self.channel_layer.group_send(
            room_group_name,
            {
                'type': 'chat.message',
                'message': message,
                'sender_channel_name': self.channel_name
            }
        )

    async def chat_message(self, event):
        message = event['message']

        # Check if the sender's channel name matches the current channel name
        # If they match, don't send the message to the sender
        if event['sender_channel_name'] != self.channel_name:
            await self.send(text_data=json.dumps({
                'message': message
            }))
