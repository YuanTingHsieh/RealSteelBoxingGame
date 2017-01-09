#include <QApplication>
#include <VPApplication>

#include <QQmlApplicationEngine>
#include <QDebug>
#include <iostream>
#include "server.h"

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);

    VPApplication vplay;

    // QQmlApplicationEngine is the preferred way to start qml projects since Qt 5.2
    // if you have older projects using Qt App wizards from previous QtCreator versions than 3.1, please change them to QQmlApplicationEngine
    QQmlApplicationEngine engine;

    vplay.initialize(&engine);

    // use this during development
    // for PUBLISHING, use the entry point below
    vplay.setMainQmlFileName(QStringLiteral("qml/Main.qml"));

    // use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
    // this is the preferred deployment option for publishing games to the app stores, because then your qml files and js files are protected
    // to avoid deployment of your qml files and images, also comment the DEPLOYMENTFOLDERS command in the .pro file
    // also see the .pro file for more details
    //  vplay.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));

    engine.load(QUrl(vplay.mainQmlFileName()));

    for (int i=0;i<engine.rootObjects()[0]->children().size();i++)
    {
        qDebug() << i;
        qDebug() << engine.rootObjects()[0]->children()[i];
        qDebug() << engine.rootObjects()[0]->children()[i]->children();
    }

//    const QObject* item = engine.rootObjects()[0]->children()[10]->children()[10];
//    const QMetaObject *meta = item->metaObject();
//    QHash<QString, QVariant> list;
//    for (int i = 0; i < meta->propertyCount(); i++)
//    {
//        QMetaProperty property = meta->property(i);
//        const char* name = property.name();
//        QVariant value = item->property(name);
//        list[name] = value;
//    }

//    QString out;
//    QHashIterator<QString, QVariant> i(list);
//    while (i.hasNext()) {
//        i.next();
//        if (!out.isEmpty())
//        {
//            out += ", ";
//            out += "   ";
//        }
//        out.append(i.key());
//        out.append(": ");
//        out.append(i.value().toString());
//    }
//    qDebug() << out ;

    auto object = engine.rootObjects()[0]->children()[10]->findChild<QObject*>(QLatin1Literal("Load_BABY"));
    //auto object_arena = engine.rootObjects()[0]->children()[10]->findChild<QObject*>(QLatin1Literal("Arena"));
    qDebug() << object;

//    QVariant returnedValue;
//    QVariant msg = "Hello from C++";
//    QMetaObject::invokeMethod(object, "myQmlFunction",
//            Q_RETURN_ARG(QVariant, returnedValue),
//            Q_ARG(QVariant, msg));

//    qDebug() << "QML function returned:" << returnedValue.toString();
    Server server(0, 8888);
    // QObject::connect(object_arena, SIGNAL(arenaClicked()), &server, SLOT(setValue()) );
    QObject::connect(&server, SIGNAL(punchChanged(int)), object, SIGNAL(punchHit(int)));
    QObject::connect(&server, SIGNAL(actionChanged(int)), object, SIGNAL(actionTake(int)));

    Server server_zeus(0, 7777);
    QObject::connect(&server_zeus, SIGNAL(punchChanged(int)), object, SIGNAL(punchHit_zeus(int)));
    QObject::connect(&server_zeus, SIGNAL(actionChanged(int)), object, SIGNAL(actionTake_zeus(int)));

    //return 0;
    return app.exec();
}

