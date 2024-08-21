#ifndef SOCKETLISTENER_H
#define SOCKETLISTENER_H

#include <QObject>
#include <QString>
#include <QList>

class QTcpSocket;
class QTcpServer;

class SocketListener : public QObject
{
    Q_OBJECT
public:
    enum SocketType {
        TCPServer,
        TCPClient,
    };

public:
    explicit SocketListener(QObject *parent = nullptr);
    ~SocketListener();

signals:
    void recvData(QString data);

public slots:
    void start(SocketType socketType, QString ip, QString port);
    void stop();
    void sendData(QString data);
    void readAll();

private:
    QTcpServer *m_tcpServer;
    QTcpSocket *m_tcpSocket;
    QList<QTcpSocket*> m_clientList;
};

#endif // SOCKETLISTENER_H
