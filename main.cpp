#include "mainwindow.h"

#include <QApplication>
#include <QQuickWidget>
#include "utils/keyboardlistener.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<KeyboardListener>("ten.util.KeyboardListener", 1, 0, "KeyboardListener");

    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
