#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Setting : public QObject
{
    Q_OBJECT
public:
    explicit Setting(QObject *parent = 0);

    Q_INVOKABLE QString readSetting(QString key, QString group = "VAS");

    Q_INVOKABLE void writeSetting(QString key, QString value, QString group = "VAS");
};

#endif // SETTINGS_H
