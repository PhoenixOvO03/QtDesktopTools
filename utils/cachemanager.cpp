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
    m_cacheType = type; // 设置缓存类型
    
    switch (m_cacheType) // 设置路径
    {
    case CacheType::SettingCache:
    {
        m_cacheFilePath = QCoreApplication::applicationDirPath() + "/cache/setting.json";
        m_defaltCacheFilePath = ":/cache/setting.json";
        break;
    }
    case CacheType::SocketCache:
    {
        m_cacheFilePath = QCoreApplication::applicationDirPath() + "/cache/socket.json";
        m_defaltCacheFilePath = ":/cache/socket.json";
        break;
    }
    case CacheType::ThemeCache:
    {
        m_cacheFilePath = QCoreApplication::applicationDirPath() + "/cache/theme.json";
        m_defaltCacheFilePath = ":/cache/theme.json";
        break;
    }
    default:
        return m_cache;
        break;
    }

    chechkCache(); // 检查缓存文件是否存在
    QFile socketFile(m_cacheFilePath);  // 加载缓存
    if (socketFile.open(QFile::ReadOnly))
    {
        m_jsonDoc = QJsonDocument::fromJson(socketFile.readAll());
        m_cache = m_jsonDoc.object();
    }
    socketFile.close();
    return m_cache;
}

void CacheManager::changeCache(QString key, QJsonValue value)
{
    m_cache[key] = value;
    
    switch (m_cacheType)
    {
    case CacheType::SettingCache: // 保存setting缓存
    case CacheType::SocketCache: // 保存socket缓存
    case CacheType::ThemeCache: // 保存theme缓存
    {
        m_jsonDoc.setObject(m_cache);
        QFile socketFile(m_cacheFilePath);
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

    QDir dir;
    if (!dir.exists(dirPath)) // 如果缓存文件夹路径不存在则创建
        dir.mkpath(dirPath);

    if (!QFile::exists(m_cacheFilePath)) // 如果缓存文件不存在则复制
    {
        QFile file(m_cacheFilePath);
        QFile defaultFile(m_defaltCacheFilePath);

        defaultFile.open(QFile::ReadOnly);
        QByteArray data = defaultFile.readAll();
        defaultFile.close();

        file.open(QFile::WriteOnly);
        file.write(data);
        file.close();
    }
}
