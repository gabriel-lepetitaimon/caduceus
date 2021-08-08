from django.urls import path
from . import views

urlpatterns = [
    path('', views.api_view),
    path('users/', views.UserList.as_view(), name='user-list'),
    path('users/<int:pk>/', views.UserDetail.as_view(), name='user-detail'),
    path('login', views.ObtainExpiringAuthToken.as_view(), name='login'),
    path('hello', views.api_hello, name='hello'),
]