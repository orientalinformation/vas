#ifndef IOSTREAMS_H
#define IOSTREAMS_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QApplication>
#include <QDateTime>
#include <QDebug>
#include <QSettings>

class TimeModel : public QObject{

    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int time READ time WRITE setTime NOTIFY timeChanged)

public:
    QString name() const;
    void setName(const QString &name);

    int time() const;
    void setTime(int time);

signals:
    void nameChanged();
    void timeChanged();

private:
    QString _name;
    int _time;
};

class IOStreams : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
public:
    explicit IOStreams(QObject *parent = 0);

    Q_INVOKABLE QString read(QString key, QString group, QString url);

    Q_INVOKABLE QStringList readData(QString key, QString group, QString url);

    Q_INVOKABLE QList<QObject *> readObject(QString key, QString group, QString url);

    Q_INVOKABLE void write(QString key, QString value, QString group = "", QString url = "");

    Q_INVOKABLE void write(QString key, QStringList datas, QString group = "", QString url = "");

    Q_INVOKABLE void writeData( QString key, QList<QObject *> listData, QString group = "", QString url = "");

    Q_INVOKABLE void writeObject(QString key, QList<QObject *> listData, QString group = "", QString url = "");

    Q_INVOKABLE void writeObject2(QString key, QList<QObject *> listData, QString group = "", QString url = "");

    Q_INVOKABLE void clear(QString url = "");

    QString source() const;
    void setSource(const QString &source);

signals:
    void sourceChanged();

private:
    QString _path;

    QString _source;
};

#endif // IOSTREAMS_H
