#include "src/desktopwidget.h"

#include "utils/keyboardlistener.h"
#include "utils/socketlistener.h"
#include "utils/cachemanager.h"

#include <QApplication>
#include <QQuickWidget>

int main(int argc, char *argv[])
{
    qmlRegisterType<KeyboardListener>("ten.util.KeyboardListener", 1, 0, "KeyboardListener");
    qmlRegisterType<SocketListener>("ten.util.SocketListener", 1, 0, "SocketListener");
    qmlRegisterType<CacheManager>("ten.util.CacheManager", 1, 0, "CacheManager");
    
    QApplication a(argc, argv);
    DesktopWidget w;
    w.showMaximized();
    return a.exec();
}
