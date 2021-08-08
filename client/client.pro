QT += quick quickcontrols2

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    services/authentification.cpp \
    services/localsettings.cpp \
    services/notifications.cpp \
    services/server.cpp \
    utils/promise.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    client_en_001.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    assets/fonts/embededFonts.h \
    services/authentification.h \
    services/localsettings.h \
    services/notifications.h \
    services/server.h \
    services/services.h \
    utils/promise.h
