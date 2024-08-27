#include "cachemanager.h"

#include <QCoreApplication>
#include <QFile>
#include <QDir>

CacheManager::CacheManager(QObject *parent)
    : QObject{parent}
{
    m_cacheType = CacheType::NoCache; // 默认缓存类型为无缓存
}

QJsonObject CacheManager::loadCache(CacheType type)
{
    chechkCache();
    m_cacheType = type; // 设置缓存类型
    
    switch (m_cacheType)
    {
    case CacheType::SettingCache: // 加载setting缓存
    {
        QFile settingFile(QCoreApplication::applicationDirPath() + "/cache/setting.json");
        if (settingFile.open(QFile::ReadOnly))
        {
            m_jsonDoc = QJsonDocument::fromJson(settingFile.readAll());
            m_cache = m_jsonDoc.object();
        }
        settingFile.close();
        break;
    }
    case CacheType::SocketCache: // 加载socket缓存
    {
        QFile socketFile(QCoreApplication::applicationDirPath() + "/cache/socket.json");
        if (socketFile.open(QFile::ReadOnly))
        {
            m_jsonDoc = QJsonDocument::fromJson(socketFile.readAll());
            m_cache = m_jsonDoc.object();
        }
        socketFile.close();
        break;
    }
    default:
        break;
    }

    return m_cache;
}

void CacheManager::changeCache(QString key, QJsonValue value)
{
    m_cache[key] = value;
    
    switch (m_cacheType)
    {
    case CacheType::SettingCache: // 保存setting缓存
    {
        m_jsonDoc.setObject(m_cache);
        QFile settingFile(QCoreApplication::applicationDirPath() + "/cache/setting.json");
        if (!settingFile.open(QFile::WriteOnly))
        {
            qDebug() << settingFile.error();
            return;
        }
        QTextStream settingWirteStream(&settingFile);
        settingWirteStream.setEncoding(QStringConverter::Utf8); // 设置编码 UTF8
        settingWirteStream << m_jsonDoc.toJson();               // 写入文件
        settingFile.close();
        break;
    }
    case CacheType::SocketCache: // 保存socket缓存
    {
        m_jsonDoc.setObject(m_cache);
        QFile socketFile(QCoreApplication::applicationDirPath() + "/cache/socket.json");
        if (!socketFile.open(QFile::WriteOnly))
        {
            qDebug() << socketFile.error();
            return;
        }
        QTextStream socketWirteStream(&socketFile);
        socketWirteStream.setEncoding(QStringConverter::Utf8); // 设置编码 UTF8
        socketWirteStream << m_jsonDoc.toJson();               // 写入文件
        socketFile.close();
        break;
    }
    default:
        break;
    }
}

void CacheManager::chechkCache()
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/cache"; // 缓存文件夹路径
    QString settingFilePath = dirPath + "/setting.json"; // setting缓存文件路径
    QString SocketCachePath = dirPath + "/socket.json"; // socket缓存文件路径

    QDir dir;
    if (!dir.exists(dirPath)) // 如果缓存文件夹路径不存在则创建
        dir.mkpath(dirPath);

    if (!QFile::exists(settingFilePath)) // 如果setting缓存文件不存在则复制
    {
        QFile file(settingFilePath);
        QFile defaultFile(":/cache/setting.json");

        defaultFile.open(QFile::ReadOnly);
        QByteArray data = defaultFile.readAll();
        defaultFile.close();

        file.open(QFile::WriteOnly);
        file.write(data);
        file.close();
    }

    if (!QFile::exists(SocketCachePath)) // 如果socket缓存文件不存在则复制
    {
        QFile file(SocketCachePath);
        QFile defaultFile(":/cache/socket.json");

        defaultFile.open(QFile::ReadOnly);
        QByteArray data = defaultFile.readAll();
        defaultFile.close();

        file.open(QFile::WriteOnly);
        file.write(data);
        file.close();
    }
}
