#include "mainwindow.h"

#include <QApplication>
#include <QQuickWidget>

#include "utils/keyboardlistener.h"
#include "utils/socketlistener.h"
#include "utils/cachemanager.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<KeyboardListener>("ten.util.KeyboardListener", 1, 0, "KeyboardListener");
    qmlRegisterType<SocketListener>("ten.util.SocketListener", 1, 0, "SocketListener");
    qmlRegisterType<CacheManager>("ten.util.CacheManager", 1, 0, "CacheManager");
    
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
