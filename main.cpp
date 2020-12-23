#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSslSocket>

#include "appcore.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Azia");
    //QCoreApplication::setOrganizationDomain("mysoft.com"); //needed ios
    QCoreApplication::setApplicationName("AziaClient");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qDebug() << QSslSocket::supportsSsl() << QSslSocket::sslLibraryVersionString() << QSslSocket::sslLibraryBuildVersionString();

    AppCore core;
    engine.rootContext()->setContextProperty("core", &core);
    engine.rootContext()->setContextProperty("menu", &core.menu);
    engine.rootContext()->setContextProperty("basket", &core.basket);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.addImportPath(":/qml");
    engine.load(url);

    return app.exec();
}
