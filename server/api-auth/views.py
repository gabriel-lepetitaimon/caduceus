from django.contrib.auth.models import User
from .serializers import UserSerializer
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view
from rest_framework.reverse import reverse
from django.utils import timezone
from drf_yasg.utils import swagger_auto_schema


@api_view(['GET'])
def api_root(request, format=None):
    return Response({
        'users': reverse('user-list', request=request, format=format)
    })


@swagger_auto_schema(method='get',
                     operation_summary="Request server infos.")
@api_view(['GET'])
def api_hello(request, format=None):
    return Response({
        'version': '1.0.0',
    })


class UserList(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class UserDetail(generics.RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class ObtainExpiringAuthToken(ObtainAuthToken):
    @swagger_auto_schema(operation_summary="Login")
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid():
            token, created = Token.objects.get_or_create(user=serializer.validated_data['user'])

            if not created:
                # update the created time of the token to keep it valid
                token.created = timezone.now()
                token.save()

            return Response({'token': token.key})

        return Response(serializer.errors, status=status.HTTP_401_UNAUTHORIZED)
