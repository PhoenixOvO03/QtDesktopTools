#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include "utils/keyboardlistener.h"

#include <QMenu>
#include <QSystemTrayIcon>
#include <QQuickWidget>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    setWindowIcon(QIcon(":/res/Qt.png")); // 任务栏图标
    setWindowFlags(Qt::FramelessWindowHint); // 无边框
    setAttribute(Qt::WA_TranslucentBackground); // 透明

    trayIconInit(); // 托盘图标初始化

    connect(ui->listenKeyBtn, &QPushButton::clicked, this, &MainWindow::onListenKeyBtnClicked);
    connect(ui->closeBtn, &QPushButton::clicked, this, &MainWindow::onCloseBtnClicked);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::mousePressEvent(QMouseEvent *e)
{
    if (e->button() == Qt::LeftButton)
    {
        m_pressPos = e->globalPosition().toPoint() - pos();
    }
}

void MainWindow::mouseMoveEvent(QMouseEvent *e)
{
    if (e->buttons() & Qt::LeftButton)
    {
        move(e->globalPosition().toPoint() - m_pressPos);
    }
}

void MainWindow::trayIconInit()
{
    // 显示
    QAction* showAction = new QAction("显示");
    connect(showAction, &QAction::triggered, this, &QMainWindow::show);
    // 退出
    QAction* exitAction = new QAction("退出");
    connect(exitAction , &QAction::triggered, this, &QApplication::exit);

    // 初始化菜单并添加项
    QMenu* trayMenu = new QMenu(this);
    trayMenu->addAction(showAction);
    trayMenu->addAction(exitAction );

    //创建一个系统托盘
    m_trayIcon = new QSystemTrayIcon(this);
    m_trayIcon->setIcon(QIcon(":/res/Qt.png"));
    m_trayIcon->setContextMenu(trayMenu);
    m_trayIcon->show();
}

void MainWindow::onListenKeyBtnClicked()
{
    static bool isShow = false;
    if (isShow)
    {
        m_listenKey->deleteLater();
    }
    else
    {
        qmlRegisterType<KeyboardListener>("ten.util.KeyboardListener", 1, 0, "KeyboardListener");
        m_listenKey = new QQuickWidget();
        m_listenKey->setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnTopHint); // 无边框 | 去除任务栏 | 置顶
        m_listenKey->setAttribute(Qt::WA_TranslucentBackground); // 透明窗口
        m_listenKey->setClearColor(QColor(Qt::transparent)); // 背景清空
        QRect rect = QGuiApplication::primaryScreen()->availableGeometry();
        m_listenKey->move(rect.width()-300,rect.height()-200);
        m_listenKey->setSource(QUrl("qrc:/qml/ShowPressedKey.qml"));
        m_listenKey->show();
    }
    isShow = !isShow;
}

void MainWindow::onCloseBtnClicked()
{
    QMessageBox quitBox;
    quitBox.setWindowTitle("退出");
    quitBox.setText("最小化到系统托盘或退出程序");
    quitBox.addButton("最小化", QMessageBox::ActionRole);
    quitBox.addButton("关闭", QMessageBox::ActionRole);
    quitBox.setWindowFlags(Qt::FramelessWindowHint | Qt::WindowStaysOnTopHint);

    quitBox.setStyleSheet("QMessageBox,QPushButton{"
                          "color: white;"
                          "background-color: #c0444444;"
                          "border: 1px solid white;"
                          "border-color: white;"
                          "}"
                          "QLabel{"
                          "color: white;"
                          "}");

    int ret = quitBox.exec();
    if (ret == 0) hide();
    else close();
}
