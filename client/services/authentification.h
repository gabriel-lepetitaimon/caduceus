#ifndef AUTHENTIFICATION_H
#define AUTHENTIFICATION_H

#include <QObject>
#include "server.h"
#include "../utils/promise.h"

class LoggedUser;


class AuthService : public QObject
{
    Q_OBJECT

    Q_PROPERTY(LoggedUser* loggedUser READ loggedUser NOTIFY loggedUserChanged);

    public:
        virtual ~AuthService() {}

        LoggedUser* loggedUser() const              {return _loggedUser;}
        Q_INVOKABLE bool isAuthenticated() const;

    public slots:
        QObserver* login(QString username, QString password, QUrl remoteUrl);
        void logout();

    signals:
        void loginFailed(QString msg);
        void loginSucceed();
        void loggedOut();
        void loggedUserChanged(LoggedUser* loggedUser);

    private:
        explicit AuthService();
        LoggedUser* _loggedUser=nullptr;

    // -- Singleton --
    public:
       static AuthService & service()
       {
           static AuthService instance;
           return instance;
       }
};


class LoggedUser: public QObject{
    Q_OBJECT

    Q_PROPERTY(QString username READ username)
    Q_PROPERTY(QString email READ username)
    Q_PROPERTY(QString role READ role)

    public:
        LoggedUser(QString username, QJsonObject json, QObject *parent=nullptr);

        const QString& username() const {return _username;}
        const QString& email() const    {return _email;}
        const QString& role() const {return _role;}

        QByteArray tokenHeader() const;

    private:
        QString _username;
        QString _email;
        QString _token;
        QString _role;
};

#endif // AUTHENTIFICATION_H
