#include "socketlistener.h"

#include <QTcpSocket>
#include <QTcpServer>
#include <QUdpSocket>

SocketListener::SocketListener(QObject *parent)
    : QObject{parent}
{
    m_tcpServer = nullptr;
    m_tcpSocket = nullptr;
    m_clientList = QList<QTcpSocket*>();
}

SocketListener::~SocketListener()
{
    stop();
}

void SocketListener::start(SocketType socketType, QString ip, QString port)
{
    stop();
    switch (socketType)
    {
    case SocketType::TCPServer:
        m_tcpServer = new QTcpServer(this);

        connect(m_tcpServer, &QTcpServer::newConnection, this, [&](){
            emit recvData("客户端连接");
            QTcpSocket* client = m_tcpServer->nextPendingConnection();
            int index = m_clientList.length();
            m_clientList.append(client);
            connect(m_clientList[index], &QTcpSocket::readyRead, this, &SocketListener::readAll);
            connect(m_clientList[index], &QTcpSocket::disconnected, this, [&](){
                m_clientList.removeOne(client);
            });
        });
        m_tcpServer->listen(QHostAddress(ip), port.toUInt());
        if (m_tcpServer->isListening())
            emit recvData("开始监听");
        else
            emit recvData("监听失败");
        break;

    case SocketType::TCPClient:
        m_tcpSocket = new QTcpSocket(this);
        connect(m_tcpSocket, &QTcpSocket::connected, this, [&](){
            emit recvData("服务器连接成功");
        });

        connect(m_tcpSocket, &QTcpSocket::readyRead, this, [&](){
            emit recvData(m_tcpSocket->readAll());
        });

        m_tcpSocket->connectToHost(QHostAddress(ip), port.toUInt());
        break;
        
    default:
        break;
    }
}

void SocketListener::stop()
{
    if (m_tcpServer != nullptr)
    {
        m_tcpServer->close();
        m_tcpServer->deleteLater();
        m_tcpServer = nullptr;
    }

    if (m_tcpSocket != nullptr)
    {
        m_tcpSocket->close();
        m_tcpSocket->deleteLater();
        m_tcpSocket = nullptr;
    }

    for (auto client : m_clientList)
    {
        client->close();
        client->deleteLater();
    }
    m_clientList.clear();
}

void SocketListener::sendData(QString data)
{
    if (m_tcpServer != nullptr)
    {
        for (auto client : m_clientList)
        {
            client->write(data.toUtf8());
        }
    }
    if (m_tcpSocket != nullptr)
        m_tcpSocket->write(data.toUtf8());
}

void SocketListener::readAll()
{
    for (auto client: m_clientList)
    {
        QString buffer = client->readAll();
        if (buffer.length() != 0)
        {
            emit recvData(buffer);
        }
    }
}
