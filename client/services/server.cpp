#include <QJsonDocument>
#include <QUrlQuery>
#include "authentification.h"

ServerService::ServerService() : QObject(), manager(this) {

}

QObserver* ServerService::connectRemoteHost(const QUrl &remoteHost) {
    auto request = prepareServerRequest(remoteHost, "/api/auth/hello");
    auto o = new QNetPromise(manager.get(request));

    auto r = o->thenDo([this, remoteHost](QNetworkReply*){
            _remoteHost = remoteHost;
            emit remoteHostChanged(remoteHost);
            emit hostConnected();
        });
    o->onFail([this](QString error){
            emit hostConnexionError(error);
        });
    return r;
}

QNetworkReply* ServerService::put(QString path, const QJsonObject& json, std::initializer_list<QPair<QString, QString> > parameters) {
    QNetworkRequest request = prepareServerRequest(path, parameters);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader(QByteArray("Accept"), QByteArray("application/json"));
    return manager.put(request, QJsonDocument(json).toJson());
}

QNetworkReply *ServerService::post(QString path, const QJsonObject& json, std::initializer_list<QPair<QString, QString> > parameters) {
    QNetworkRequest request = prepareServerRequest(path, parameters);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader(QByteArray("Accept"), QByteArray("application/json"));
    return manager.post(request, QJsonDocument(json).toJson());
}

QNetworkReply *ServerService::get(QString path, std::initializer_list<QPair<QString, QString> > parameters) {
    QNetworkRequest request = prepareServerRequest(path, parameters);
    request.setRawHeader(QByteArray("Accept"), QByteArray("application/json"));
    return manager.get(request);
}

QNetworkRequest ServerService::prepareServerRequest(QString path, std::initializer_list<QPair<QString, QString>> parameters) const
{
   return prepareServerRequest(_remoteHost, path, parameters);
}

QNetworkRequest ServerService::prepareServerRequest(const QUrl& host, QString path, std::initializer_list<QPair<QString, QString>> parameters) const {
    QUrl url(host);
    url.setPath(path);
    if(parameters.size())
        url.setQuery(QUrlQuery(parameters));

    QNetworkRequest request(url);
    if(AuthService::service().isAuthenticated())
        request.setRawHeader("Authorization", AuthService::service().loggedUser()->tokenHeader());

    return request;
}


/********************************************************
 *          ---  SINGLETON SHORTCUTS  ---               *
 ********************************************************/

QNetworkReply *ServerService::serverPut(QString path, const QJsonObject &json, std::initializer_list<QPair<QString, QString> > parameters) {
    return service().put(path, json, parameters);
}

QNetworkReply *ServerService::serverPost(QString path, const QJsonObject &json, std::initializer_list<QPair<QString, QString> > parameters) {
    return service().post(path, json, parameters);
}

QNetworkReply *ServerService::serverGet(QString path, std::initializer_list<QPair<QString, QString> > parameters) {
    return service().get(path, parameters);
}

/********************************************************
 *                  ---  MISC  ---                      *
 ********************************************************/

QString ServerService::formatError(QNetworkReply *reply)
{
    auto status_code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(status_code.isValid()){
        QString error = QString("<b>ERROR ") + QString::number(status_code.toInt()) + "</b>: ";
        error += reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
        return error;
    } else {
        QString error = QString("<b>ERROR ") + QString::number(reply->error()) + "</b>: ";
        error += reply->errorString();
        return error;
    }
}
