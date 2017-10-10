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

    Q_INVOKABLE QList <QObject *> read();

    Q_INVOKABLE QString write(QList<QObject *> listData, QString key = "", QString value = "", QString group = "", QString url = "");

signals:

private:
    QString _path;
};

#endif // IOSTREAMS_H
