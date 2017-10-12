#ifndef IOSTREAMS_H
#define IOSTREAMS_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QApplication>
#include <QDateTime>
#include <QDebug>
#include <QSettings>



class IOStreams : public QObject
{
    Q_OBJECT
public:
    explicit IOStreams(QObject *parent = 0);

    Q_INVOKABLE QStringList read();

    Q_INVOKABLE QString write(QStringList listData, QString key = "", QString value = "", QString group = "", QString url = "");

    Q_INVOKABLE QString writeObject(QList<QObject *> listData, QString key = "", QString group = "", QString url = "");

signals:

private:
    QString _path;
};

#endif // IOSTREAMS_H
