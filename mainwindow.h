#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class QSystemTrayIcon;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    // 拖动窗口
    void mousePressEvent(QMouseEvent *e);
    void mouseMoveEvent(QMouseEvent *e);

private:
    void trayIconInit(); // 系统托盘图标初始化

private:
    Ui::MainWindow *ui;

    QPoint m_pressPos; // 鼠标按下位置

    QSystemTrayIcon* m_trayIcon; // 托盘图标
};
#endif // MAINWINDOW_H
