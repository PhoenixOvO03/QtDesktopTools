#include "keyboardlistener.h"

#include <QDebug>

HHOOK KeyboardListener::hHook = NULL;
KeyboardListener* KeyboardListener::keyboardListener = nullptr;

KeyboardListener::KeyboardListener(QObject *parent)
    : QObject{parent}
{
    keyboardListener = this;
    keyPressedList = QList<bool>(256, false);
    hHook = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc, NULL, 0);
    if (hHook == NULL) {
        qDebug() << "Failed to install hook!";
    }
}

KeyboardListener::~KeyboardListener()
{
    if (hHook != NULL) {
        UnhookWindowsHookEx(hHook);
        hHook = NULL;
    }
}

LRESULT CALLBACK KeyboardListener::LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam) {
    if (nCode >= 0) {
        KBDLLHOOKSTRUCT *pKeyboard = (KBDLLHOOKSTRUCT *)lParam;
        unsigned int code = pKeyboard->vkCode;

        if (keyboardListener) {
            if (wParam == WM_KEYDOWN || wParam == WM_SYSKEYDOWN) {
                if (keyboardListener->keyPressedList[code]) // 已经按下直接退出
                {
                    return CallNextHookEx(hHook, nCode, wParam, lParam);
                }

                // qDebug() << code;

                if (code >= 65 && code <= 90) // A-Z
                    emit keyboardListener->keyPressed(QString(char(code)));
                else if (code >= 112 && code <= 123) // F1-F12
                    emit keyboardListener->keyPressed(QString("F%1").arg(code - 111));
                else
                {
                    switch (code) {
                    case 8:
                        emit keyboardListener->keyPressed("Backspace");
                        break;
                    case 9:
                        emit keyboardListener->keyPressed("TAB");
                        break;
                    case 13:
                        emit keyboardListener->keyPressed("Enter");
                        break;
                    case 20:
                        emit keyboardListener->keyPressed("CAPS");
                        break;
                    case 27:
                        emit keyboardListener->keyPressed("ESC");
                        break;
                    case 32:
                        emit keyboardListener->keyPressed("Space");
                        break;
                    case 33:
                        emit keyboardListener->keyPressed("Page Up");
                        break;
                    case 34:
                        emit keyboardListener->keyPressed("Page Down");
                        break;
                    case 35:
                        emit keyboardListener->keyPressed("End");
                        break;
                    case 36:
                        emit keyboardListener->keyPressed("Home");
                        break;
                    case 37:
                        emit keyboardListener->keyPressed("Left");
                        break;
                    case 38:
                        emit keyboardListener->keyPressed("Up");
                        break;
                    case 39:
                        emit keyboardListener->keyPressed("Right");
                        break;
                    case 40:
                        emit keyboardListener->keyPressed("Down");
                        break;
                    case 45:
                        emit keyboardListener->keyPressed("Insert");
                        break;
                    case 46:
                        emit keyboardListener->keyPressed("Delete");
                        break;
                    case 48:
                        emit keyboardListener->keyPressed(")", "0");
                        break;
                    case 49:
                        emit keyboardListener->keyPressed("!", "1");
                        break;
                    case 50:
                        emit keyboardListener->keyPressed("@", "2");
                        break;
                    case 51:
                        emit keyboardListener->keyPressed("#", "3");
                        break;
                    case 52:
                        emit keyboardListener->keyPressed("$", "4");
                        break;
                    case 53:
                        emit keyboardListener->keyPressed("%", "5");
                        break;
                    case 54:
                        emit keyboardListener->keyPressed("^", "6");
                        break;
                    case 55:
                        emit keyboardListener->keyPressed("&", "7");
                        break;
                    case 56:
                        emit keyboardListener->keyPressed("*", "8");
                        break;
                    case 57:
                        emit keyboardListener->keyPressed("(", "9");
                        break;
                    case 75:
                        emit keyboardListener->keyPressed("Delete");
                        break;
                    case 91:
                    case 92:
                        emit keyboardListener->keyPressed("Win");
                        break;
                    case 160: // 左shift
                    case 161: // 右shift
                        emit keyboardListener->keyPressed("Shift");
                        break;
                    case 162: // 左Control
                    case 163: // 右Control
                        emit keyboardListener->keyPressed("Control");
                        break;
                    case 164: // 左Alt
                    case 165: // 右Alt
                        emit keyboardListener->keyPressed("Alt");
                        break;
                    case 186:
                        emit keyboardListener->keyPressed(";", ":");
                        break;
                    case 187:
                        emit keyboardListener->keyPressed("=", "+");
                        break;
                    case 188:
                        emit keyboardListener->keyPressed(",", "<");
                        break;
                    case 189:
                        emit keyboardListener->keyPressed("-", "_");
                        break;
                    case 190:
                        emit keyboardListener->keyPressed(".", ">");
                        break;
                    case 191:
                        emit keyboardListener->keyPressed("/", "?");
                        break;
                    case 192:
                        emit keyboardListener->keyPressed("`", "~");
                        break;
                    case 219:
                        emit keyboardListener->keyPressed("[", "{");
                        break;
                    case 220:
                        emit keyboardListener->keyPressed("\\", "|");
                        break;
                    case 221:
                        emit keyboardListener->keyPressed("]", "}");
                        break;
                    case 222:
                        emit keyboardListener->keyPressed("'", "\"");
                        break;
                    default:
                        emit keyboardListener->keyPressed("暂未添加");
                        break;
                    }
                }
                keyboardListener->keyPressedList[code] = true;
            }
            else
            {
                keyboardListener->keyPressedList[code] = false; // 松开按键
            }
        }
    }
    return CallNextHookEx(hHook, nCode, wParam, lParam);
}
