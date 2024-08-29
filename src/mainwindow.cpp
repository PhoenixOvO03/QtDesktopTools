#include "src/mainwindow.h"
#include "src/ui_mainwindow.h"
#include "utils/compositionwindoweffect.h"

#include <QMouseEvent>
#include <QMenu>
#include <QSystemTrayIcon>
#include <QQuickItem>
#include <QFile>
#include <QJsonObject>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    trayIconInit(); // 托盘图标初始化
    uiInit(); // 初始化界面和UI控件
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::setTheme(QString topLeft, QString bottomRight, QString theme, int index)
{
    m_themeCache.changeCache("topLeft", topLeft);
    m_themeCache.changeCache("bottomRight", bottomRight);
    m_themeCache.changeCache("theme", theme);
    m_themeCache.changeCache("index", index);
    QFile qssFile(":/qss/MainWindow.qss");
    if(qssFile.open(QFile::ReadOnly)){
        setStyleSheet(QString(qssFile.readAll()).arg(topLeft).arg(bottomRight));
    }
    qssFile.close();
}

void MainWindow::mousePressEvent(QMouseEvent *e)
{
    if (e->button() == Qt::LeftButton)
        m_pressPos = e->globalPosition().toPoint() - pos();
}

void MainWindow::mouseMoveEvent(QMouseEvent *e)
{
    if (e->buttons() & Qt::LeftButton)
        move(e->globalPosition().toPoint() - m_pressPos);
}

void MainWindow::trayIconInit()
{
    // 显示
    QAction* showAction = new QAction("显示");
    connect(showAction, &QAction::triggered, this, [&](){
        this->show();
        // 毛玻璃效果
        HWND hwnd = (HWND)this->winId();
        CompositionWindowEffect::setAreoEffect((HWND)(hwnd));
    });
    // 退出
    QAction* exitAction = new QAction("退出");
    connect(exitAction , &QAction::triggered, this, &QApplication::exit);

    // 初始化菜单并添加项
    QMenu* trayMenu = new QMenu(this);
    trayMenu->addAction(showAction);
    trayMenu->addAction(exitAction );

    //创建一个系统托盘
    m_trayIcon = new QSystemTrayIcon(this);
    m_trayIcon->setIcon(QIcon(":/res/ten_OvO.png"));
    m_trayIcon->setContextMenu(trayMenu);

    // 双击托盘图标显示主窗口
    connect(m_trayIcon, &QSystemTrayIcon::activated, this, [&](QSystemTrayIcon::ActivationReason reason){
        if (reason == QSystemTrayIcon::DoubleClick) {
            this->show();
            // 毛玻璃效果
            HWND hwnd = (HWND)this->winId();
            CompositionWindowEffect::setAreoEffect((HWND)(hwnd));
        }
    });

    m_trayIcon->show();
}

void MainWindow::uiInit()
{
    // UI
    ui->quickWidget->setAttribute(Qt::WA_AlwaysStackOnTop); // 置顶 置顶qml清空不会影响widget
    ui->quickWidget->setClearColor(QColor(Qt::transparent)); // 背景清空
    ui->quickWidget->setSource(QUrl("qrc:/qml/Main.qml"));

    QQuickItem* item = ui->quickWidget->rootObject();
    QJsonObject theme = m_themeCache.loadCache(CacheManager::ThemeCache); // 加载主题缓存
    setTheme(theme.value("topLeft").toString(),
            theme.value("bottomRight").toString(),
            theme.value("theme").toString(),
            theme.value("index").toInt()); // 设置主题
    item->setProperty("theme", theme.value("theme").toString()); // 设置主题
    item->setProperty("skinIndex", theme.value("index").toInt()); // 设置皮肤索引
    connect(item, SIGNAL(close()), this, SLOT(close()));
    connect(item, SIGNAL(skinChanged(QString, QString, QString, int)), this, SLOT(setTheme(QString, QString, QString, int)));

    // 窗口
    setFixedSize(550, 500);
    setWindowTitle("桌面小工具 - 十_OvO脱发开发中");
    setWindowIcon(QIcon(":/res/ten_OvO.png")); // 任务栏图标
    setWindowFlags(Qt::FramelessWindowHint); // 无边框
    setAttribute(Qt::WA_TranslucentBackground); // 透明
    // 毛玻璃效果
    HWND hwnd = (HWND)this->winId();
    CompositionWindowEffect::setAreoEffect((HWND)(hwnd));
}
