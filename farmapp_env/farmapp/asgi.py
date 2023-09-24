import os
import django
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'farmapp.settings')
django.setup()  # This is the crucial line

from channels.routing import ProtocolTypeRouter, URLRouter
from farmapp import routing

application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    "websocket": URLRouter(routing.websocket_urlpatterns)
})
