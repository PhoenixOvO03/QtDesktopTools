#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class QQuickWidget;
class QSystemTrayIcon;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    void mousePressEvent(QMouseEvent *e);
    void mouseMoveEvent(QMouseEvent *e);

private:
    void trayIconInit(); // 系统托盘图标初始化

private slots:
    void onListenKeyBtnClicked();
    void onCloseBtnClicked();

private:
    Ui::MainWindow *ui;

    QPoint m_pressPos;

    QQuickWidget* m_listenKey; // 监听按键的qml
    QSystemTrayIcon* m_trayIcon; // 托盘图标
};
#endif // MAINWINDOW_H
