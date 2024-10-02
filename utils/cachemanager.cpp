#include "cachemanager.h"

#include <QCoreApplication>
#include <QFile>
#include <QDir>

CacheManager::CacheManager(QObject *parent)
    : QObject{parent}
{
}

Q_INVOKABLE QJsonObject CacheManager::loadCache(QString filename)
{
    m_cacheFilePath = QString("%1/cache/%2").arg(QCoreApplication::applicationDirPath()).arg(filename);
    m_defaltCacheFilePath = QString(":/cache/%1").arg(filename);

    checkCache(); // 检查缓存文件是否存在
    QFile socketFile(m_cacheFilePath);  // 加载缓存
    if (socketFile.open(QFile::ReadOnly))
    {
        m_jsonDoc = QJsonDocument::fromJson(socketFile.readAll());
        m_cache = m_jsonDoc.object();
        socketFile.close();
    }
    return m_cache;
}

void CacheManager::changeCache(QString key, QJsonValue value)
{
    m_cache[key] = value; // 修改缓存

    m_jsonDoc.setObject(m_cache);
    QFile socketFile(m_cacheFilePath);
    if (!socketFile.open(QFile::WriteOnly))
    {
        qDebug() << socketFile.error();
        return;
    }
    QTextStream socketWirteStream(&socketFile);
    socketWirteStream.setEncoding(QStringConverter::Utf8); // 设置编码 UTF8
    socketWirteStream << m_jsonDoc.toJson(); // 写入文件
    socketFile.close();
}

void CacheManager::checkCache()
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/cache"; // 缓存文件夹路径

    QDir dir;
    if (!dir.exists(dirPath)) // 如果缓存文件夹路径不存在则创建
        dir.mkpath(dirPath);

    if (!QFile::exists(m_cacheFilePath)) // 如果缓存文件不存在则复制
    {
        QFile file(m_cacheFilePath);
        QFile defaultFile(m_defaltCacheFilePath);

        if (defaultFile.open(QFile::ReadOnly)) // 如果默认缓存文件存在则复制到缓存文件
        {
            QByteArray data = defaultFile.readAll();
            defaultFile.close();

            file.open(QFile::WriteOnly);
            file.write(data);
            file.close();
        }
        else // 不存在则创建新的缓存文件
        {
            file.open(QFile::WriteOnly);
            file.close();
        }
    }
}
