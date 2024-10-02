#ifndef CACHEMANAGER_H
#define CACHEMANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>

class CacheManager : public QObject
{
    Q_OBJECT
public:
    explicit CacheManager(QObject *parent = nullptr);

    Q_INVOKABLE QJsonObject loadCache(QString filename); // 加载缓存文件
    Q_INVOKABLE void changeCache(QString key, QJsonValue value); // 修改缓存

private:
    void checkCache(); // 检查缓存文件是否存在

private:
    QJsonDocument m_jsonDoc; // json文档
    QJsonObject m_cache; // 缓存
    QString m_cacheFilePath; // 缓存路径
    QString m_defaltCacheFilePath; // 默认缓存路径
};

#endif // CACHEMANAGER_H
