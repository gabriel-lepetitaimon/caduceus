#ifndef EMBEDEDFONTS_H
#define EMBEDEDFONTS_H

#include "QtCore"
#include "QGuiApplication"
#include "QFontDatabase"

void loadEmbededFonts(){
    // --- Roboto ---
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Regular.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Bold.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Italic.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-BoldItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Black.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-BlackItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Condensed.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-BoldCondensed.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-CondensedItalic.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-BoldCondensedItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Medium.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-MediumItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Light.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-LightItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-Thin.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/Roboto/Roboto-ThinItalic.ttf");

    // --- RobotoMono ---
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-Regular.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-Bold.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-Italic.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-BoldItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-SemiBold.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-SemiBoldItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-Medium.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-MediumItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-Thin.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-ThinItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-Light.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-LightItalic.ttf");

    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-ExtraLight.ttf");
    QFontDatabase::addApplicationFont(":/assets/fonts/RobotoMono/RobotoMono-ExtraLightItalic.ttf");

    QGuiApplication::setFont(QFont("Roboto"));

    QFontDatabase::addApplicationFont(":/assets/fonts/fontawesome/Font Awesome 5 Brands-Regular-400.otf");
    QFontDatabase::addApplicationFont(":/assets/fonts/fontawesome/Font Awesome 5 Free-Regular-400.otf");
    QFontDatabase::addApplicationFont(":/assets/fonts/fontawesome/Font Awesome 5 Free-Solid-900.otf");
}

#endif // EMBEDEDFONTS_H
