#ifndef SERVICES_H
#define SERVICES_H

#include "authentification.h"
#include "localsettings.h"
#include "notifications.h"
#include "server.h"

#include <QQmlContext>

void registerServices(QQmlContext* qmlCtx){
    qmlCtx->setContextProperty("AuthService", &AuthService::service());
    qmlCtx->setContextProperty("LocalSettingsService", &LocalSettingsService::service());
    qmlCtx->setContextProperty("NotificationsService", &NotificationsService::service());
    qmlCtx->setContextProperty("ServerService", &ServerService::service());
}

#endif // SERVICES_H
