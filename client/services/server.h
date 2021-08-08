#ifndef SERVERSERVICE_H
#define SERVERSERVICE_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include "../utils/promise.h"

class ServerService : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl remoteHost READ remoteHost NOTIFY remoteHostChanged)

   public:
       virtual ~ServerService() {}

       const QUrl& remoteHost() const {return _remoteHost;}
       QObserver* connectRemoteHost(const QUrl &remoteHost);

    public slots:
        QNetworkReply* put(QString path, const QJsonObject& json, std::initializer_list<QPair<QString, QString> > parameters={});
        QNetworkReply*  post(QString path, const QJsonObject& json, std::initializer_list<QPair<QString, QString> > parameters={});
        QNetworkReply*  get(QString path, std::initializer_list<QPair<QString, QString> > parameters={});

    signals:
       void hostConnected();
       void hostConnexionError(QString error);
       void remoteHostChanged(QUrl host);

    protected:
        QNetworkAccessManager manager;
        QNetworkRequest prepareServerRequest(QString path, std::initializer_list<QPair<QString, QString> > parameters={}) const;
        QNetworkRequest prepareServerRequest(const QUrl &host, QString path, std::initializer_list<QPair<QString, QString> > parameters={}) const;

   private:
        explicit ServerService();
        QUrl _remoteHost;

    // -- Singleton --
    public:
        static ServerService & service()
        {
            static ServerService instance;
            return instance;
        }
        static QNetworkReply* serverPut(QString path, const QJsonObject& json, std::initializer_list<QPair<QString, QString> > parameters={});
        static QNetworkReply* serverPost(QString path, const QJsonObject& json, std::initializer_list<QPair<QString, QString> > parameters={});
        static QNetworkReply* serverGet(QString path, std::initializer_list<QPair<QString, QString> > parameters={});

        static QString formatError(QNetworkReply* reply);
};

#endif // SERVERSERVICE_H
