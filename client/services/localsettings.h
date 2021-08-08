#ifndef LOCALSETTINGSSERVICE_H
#define LOCALSETTINGSSERVICE_H

#include <QSettings>
#include <QObject>

class LocalSettingsService : public QObject
{
    Q_OBJECT

public:
    virtual ~LocalSettingsService() {}

    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE bool contains(const QString &key) const;
    Q_INVOKABLE bool isReady() const {return _isReady;}

public slots:
    void setValue(QString key, const QVariant& value);

signals:
    void settingsReady();

private slots:
    bool checkSettingsReady();
private:
    QSettings* _settings;
    bool _isReady = false;


// -- Singleton --
public:
   static LocalSettingsService & service()
   {
       static LocalSettingsService instance;
       return instance;
   }
   static QVariant get(const QString &key, const QVariant &defaultValue = QVariant());
   static bool has(QString key);
   static void set(QString key, const QVariant &value);
private:
   explicit LocalSettingsService();
};

#endif // LOCALSETTINGSSERVICE_H
