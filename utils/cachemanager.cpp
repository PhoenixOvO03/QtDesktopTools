#include "cachemanager.h"

#include <QCoreApplication>
#include <QFile>
#include <QDir>

CacheManager::CacheManager(QObject *parent)
    : QObject{parent}
{
    chechkCache();
    loadCache();
}

void CacheManager::changeCache(CacheType type, QString key, QJsonValue value)
{
    // qDebug() << type << " " << key << " " << value;
    switch (type)
    {
    case CacheType::SettingCache:
    {
        m_settingCache[key] = value;
        break;
    }
    case CacheType::SocketCache:
    {
        m_socketCache[key] = value;
        break;
    }
    default:
        break;
    }
    saveCache(type);
}

void CacheManager::chechkCache()
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/cache"; // 缓存文件夹路径
    QString settingFilePath = dirPath + "/setting.json";                 // setting缓存文件路径
    QString SocketCachePath = dirPath + "/socket.json";                  // socket缓存文件路径

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

void CacheManager::loadCache()
{
    // 加载setting缓存
    QFile settingFile(QCoreApplication::applicationDirPath() + "/cache/setting.json");
    if (settingFile.open(QFile::ReadOnly))
    {
        m_jsonDoc = QJsonDocument::fromJson(settingFile.readAll());
        m_settingCache = m_jsonDoc.object();
    }
    settingFile.close();

    // 加载socket缓存
    QFile socketFile(QCoreApplication::applicationDirPath() + "/cache/socket.json");
    if (socketFile.open(QFile::ReadOnly))
    {
        m_jsonDoc = QJsonDocument::fromJson(socketFile.readAll());
        m_socketCache = m_jsonDoc.object();
    }
    socketFile.close();
}

void CacheManager::saveCache(CacheType type)
{
    switch (type)
    {
    case CacheType::SettingCache: // 保存setting缓存
    {
        m_jsonDoc.setObject(m_settingCache);
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
        m_jsonDoc.setObject(m_socketCache);
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