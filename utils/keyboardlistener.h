#ifndef KEYBOARDLISTENER_H
#define KEYBOARDLISTENER_H

#include <QObject>
#include <windows.h>
#include <Qstring>
#include <QList>

class KeyboardListener : public QObject
{
    Q_OBJECT
public:
    explicit KeyboardListener(QObject *parent = nullptr);
    ~KeyboardListener();

    static LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam);

    QList<bool> keyPressedList;

    static HHOOK hHook;
    static KeyboardListener *keyboardListener;

signals:
    void keyPressed(QString topKey, QString bottomKey = "");
};

#endif // KEYBOARDLISTENER_H
