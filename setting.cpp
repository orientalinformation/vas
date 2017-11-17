#include "setting.h"

#include <QApplication>
#include <QSettings>
#include <QStandardPaths>

#include "version.h"

Setting::Setting(QObject *parent) :
    QObject (parent)
{
}

QString Setting::readSetting(QString key, QString group)
{
    QString path = "";

#ifdef Q_OS_WIN
    QSettings settings("HKEY_CURRENT_USER\\Software\\" + QString(VER_COMPANYNAME_STR) + "\\" + QString(VER_PRODUCTNAME_STR) + "\\Components", QSettings::NativeFormat);
    path = settings.value(key).toString();
#else
    QSettings settings(QApplication::applicationDirPath() + "/vas.ini", QSettings::IniFormat);

    settings.beginGroup(group);
    const QStringList childKeys = settings.childKeys();

    foreach(const QString &childKey, childKeys) {
        if (childKey == key) {
             path = settings.value(childKey).toString();
        }
    }

    settings.endGroup();
#endif

    if (path.isEmpty()) {
        path = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    }

    return path;
}

void Setting::writeSetting(QString key, QString value, QString group)
{
#ifdef Q_OS_WIN
    QSettings settings("HKEY_CURRENT_USER\\Software\\" + QString(VER_COMPANYNAME_STR) + "\\" + QString(VER_PRODUCTNAME_STR) + "\\Components", QSettings::NativeFormat);
    settings.setValue(key, value);
#else
    QSettings settings(QApplication::applicationDirPath() + "/vas.ini", QSettings::IniFormat);
    settings.beginGroup(group);
    settings.setValue(key, value);
    settings.endGroup();
#endif
}
