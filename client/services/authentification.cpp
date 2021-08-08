#include "authentification.h"
#include "server.h"
#include <QJsonDocument>
#include <QJsonObject>

AuthService::AuthService() : QObject() {

}

bool AuthService::isAuthenticated() const {
    return _loggedUser != nullptr;
}

QObserver *AuthService::login(QString username, QString password, QUrl remoteUrl) {

    auto o = ServerService::service().connectRemoteHost(remoteUrl)
             ->then([username, password](){
                return ServerService::serverPost("/api/auth/login",
                                                 {{"username", username}, {"password", password}});
            })->thenDo([this, username](QNetworkReply* reply){
                auto json = QJsonDocument::fromJson(QString(reply->readAll()).toUtf8()).object();
                _loggedUser = new LoggedUser(username, json, this);
                emit loggedUserChanged(_loggedUser);
                emit loginSucceed();
            });
            o->onFail([this](QString error){
                emit loginFailed(error);
            });
            return o;
}

void AuthService::logout() {
    delete _loggedUser;
    _loggedUser = nullptr;
    emit loggedOut();
    emit loggedUserChanged(nullptr);
}


/****************************************************************************
 *                   ---- LoggedUser  definition ----                       *
 ****************************************************************************/

LoggedUser::LoggedUser(QString username, QJsonObject json, QObject *parent): QObject(parent), _username(username) {
    _token = json["token"].toString();
    _email = json["email"].toString("");
    _role = json["role"].toString("unknown");
}

QByteArray LoggedUser::tokenHeader() const {
    const QString header = QString("Token ") + _token.toLocal8Bit().toBase64();
    return header.toLocal8Bit();
}
