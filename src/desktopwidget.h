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

protected:
    // 右键移动折叠浮窗
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;

private:
    bool m_isFold = false; // 是否折叠
    bool m_moveEnabled = false; // 是否可以移动
    QPoint m_startPos; // 鼠标按下时的位置
    QPropertyAnimation* m_foldAnimation; // 折叠窗口动画
    QRect m_foldRect; // 折叠窗口的位置和大小
    QRect m_fullRect; // 全屏窗口的位置和大小

    QQuickWidget* m_quickWidget; // QML主界面
    QSystemTrayIcon* m_trayIcon; // 系统托盘
};

#endif // DESKTOPWIDGET_H
