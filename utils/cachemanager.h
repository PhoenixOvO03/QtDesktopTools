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
        SettingCache,
        SocketCache
    };
    Q_ENUM(CacheType)

public:
    explicit CacheManager(QObject *parent = nullptr);

    Q_INVOKABLE QJsonObject settingCache(){return m_settingCache;}
    Q_INVOKABLE QJsonObject socketCache(){return m_socketCache;}

signals:

public slots:
    void changeCache(CacheType type, QString key, QJsonValue value); // 修改缓存

private:
    void chechkCache(); // 检查缓存文件是否存在
    void loadCache(); // 加载缓存文件
    void saveCache(CacheType type); // 保存缓存文件

private:
    QJsonDocument m_jsonDoc; // json文档
    QJsonObject m_settingCache; // 设置页面缓存
    QJsonObject m_socketCache; // socket页面缓存
};

#endif // CACHEMANAGER_H
