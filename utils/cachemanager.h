#ifndef CACHEMANAGER_H
#define CACHEMANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>

class CacheManager : public QObject
{
    Q_OBJECT
public:
    enum CacheType{
        NoCache,
        SettingCache,
        SocketCache
    };
    Q_ENUM(CacheType)

public:
    explicit CacheManager(QObject *parent = nullptr);

    Q_INVOKABLE QJsonObject loadCache(CacheType type); // 加载缓存文件

signals:

public slots:
    void changeCache(QString key, QJsonValue value); // 修改缓存

private:
    void chechkCache(); // 检查缓存文件是否存在

private:
    CacheType m_cacheType; // 缓存类型
    QJsonDocument m_jsonDoc; // json文档
    QJsonObject m_cache; // 缓存
};

#endif // CACHEMANAGER_H
