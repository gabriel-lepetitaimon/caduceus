#ifndef NOTIFICATIONSSERVICE_H
#define NOTIFICATIONSSERVICE_H

#include <QObject>

class NotificationsService : public QObject
{
    Q_OBJECT
public:
    virtual ~NotificationsService() {}

signals:

// -- Singleton --
public:
   static NotificationsService & service()
   {
       static NotificationsService instance;
       return instance;
   }
private:
   explicit NotificationsService();
};

#endif // NOTIFICATIONSSERVICE_H
