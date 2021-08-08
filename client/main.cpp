#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickStyle>
#include "services/services.h"

#include "assets/fonts/embededFonts.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    loadEmbededFonts();

    QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/ui/window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    qmlRegisterUncreatableType<QObserver>("Caduceus", 1, 0, "QObserver", "Uncreatable type");
    qmlRegisterUncreatableType<QNetPromise>("Caduceus", 1, 0, "QNetPromise", "Uncreatable type");
    registerServices(engine.rootContext());

    engine.load(url);

    return app.exec();
}
