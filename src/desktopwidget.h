#ifndef DESKTOPWIDGET_H
#define DESKTOPWIDGET_H

#include <QWidget>

class QPropertyAnimation;
class QQuickWidget;
class QSystemTrayIcon;

class DesktopWidget : public QWidget
{
    Q_OBJECT
public:
    explicit DesktopWidget(QWidget *parent = nullptr);

    void trayIconInit(); // 系统托盘初始化

private slots:
    void onFoldBtnClicked(bool toFold); // 折叠按钮点击事件

private:
    bool m_isFold; // 是否折叠
    QPropertyAnimation* m_foldAnimation; // 折叠窗口动画
    QRect m_foldRect; // 折叠窗口的位置和大小
    QRect m_fullRect; // 全屏窗口的位置和大小

    QQuickWidget* m_quickWidget; // QML主界面
    QSystemTrayIcon* m_trayIcon; // 系统托盘
};

#endif // DESKTOPWIDGET_H
