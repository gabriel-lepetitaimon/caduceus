#include "localsettings.h"

#include <QTimer>

LocalSettingsService::LocalSettingsService() : QObject(){
    _settings = new QSettings("LIV4D", "Caduceus");
    checkSettingsReady();
}

QVariant LocalSettingsService::value(const QString &key, const QVariant &defaultValue) const {
    return _settings->value(key, defaultValue);
}

bool LocalSettingsService::contains(const QString &key) const {
    return _settings->contains(key);
}

void LocalSettingsService::setValue(QString key, const QVariant &value) {
    _settings->setValue(key, value);
}

bool LocalSettingsService::checkSettingsReady() {
    if (_settings->status() == QSettings::NoError) {
        emit settingsReady();
        _isReady = true;
        return true;
    }

    QTimer::singleShot(10, this, &LocalSettingsService::checkSettingsReady);
    return false;
}

QVariant LocalSettingsService::get(const QString &key, const QVariant &defaultValue) {
    return LocalSettingsService::service().value(key, defaultValue);
}

bool LocalSettingsService::has(QString key) {
    return LocalSettingsService::service().contains(key);
}

void LocalSettingsService::set(QString key, const QVariant &value) {
    return LocalSettingsService::service().setValue(key, value);
}
