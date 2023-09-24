from channels.routing import ProtocolTypeRouter, URLRouter
from django.urls import path
from myapp import views, consumers
from django.core.asgi import get_asgi_application
from channels.auth import AuthMiddlewareStack
from django.urls import re_path

websocket_urlpatterns = [
    path('events/', views.event_stream),
    re_path(r'ws/socket/$', consumers.SquareConsumer.as_asgi()),
    path('ws/chat/<str:username>/', consumers.ChatConsumer.as_asgi()),  # adjust the path as needed

]

application = ProtocolTypeRouter({
    # "http" key is for regular HTTP traffic
    "http": get_asgi_application(),
    # Just HTTP for now. (We can also include websocket routing here.)
    "websocket": AuthMiddlewareStack(
        URLRouter(
            websocket_urlpatterns
        )
    ),

})
