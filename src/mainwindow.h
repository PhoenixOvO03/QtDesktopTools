#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "utils/cachemanager.h" // 缓存管理

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

public slots:
    void setTheme(QString topLeft, QString bottomRight, QString theme, int index); // 设置背景渐变颜色

protected:
    // 拖动窗口
    void mousePressEvent(QMouseEvent *e);
    void mouseMoveEvent(QMouseEvent *e);

private:
    void trayIconInit(); // 系统托盘图标初始化
    void uiInit(); // 初始化界面和UI控件

private:
    Ui::MainWindow *ui;

    QPoint m_pressPos; // 鼠标按下位置
    QSystemTrayIcon* m_trayIcon; // 托盘图标
    CacheManager m_themeCache; // 主题缓存管理
};
#endif // MAINWINDOW_H
