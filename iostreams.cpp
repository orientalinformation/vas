#include "iostreams.h"

IOStreams::IOStreams(QObject *parent) : QObject(parent)
{
    _path = QApplication::applicationDirPath() + QString("/data/settings.vas");
}

QStringList IOStreams::read()
{

    return QStringList();
}

QString IOStreams::write(QStringList listData, QString key, QString value, QString group, QString url)
{
    _path = url;

    if (_path.isEmpty()) {
        _path = QApplication::applicationDirPath() + QString("/data/settings.vas");
    } else {
        if (_path.startsWith("file:///", Qt::CaseInsensitive)) {
#ifdef Q_OS_WIN
            _path = _path.replace("file:///", "");
#else
            _path = _path.replace("file://", "");
#endif
        }
    }

    if (!_path.endsWith(".vas", Qt::CaseInsensitive)) {
        _path += ".vas";
    }

    QSettings settings(_path, QSettings::NativeFormat);

    if (value != "") {
        settings.beginGroup(group);
        settings.setValue(key, value);
        settings.endGroup();
    }

    if (listData.size() > 0) {
        settings.beginWriteArray(group);
        for (int i = 0; i < listData.size(); i++) {
            settings.setArrayIndex(i);
            settings.setValue(key, listData[i]);
        }
        settings.endArray();
    }
    return _path;
}

QString IOStreams::writeObject(QList<QObject *> listData, QString key, QString group, QString url)
{
    _path = url;

    if (_path.isEmpty()) {
        _path = QApplication::applicationDirPath() + QString("/data/settings.vas");
    } else {
        if (_path.startsWith("file:///", Qt::CaseInsensitive)) {
#ifdef Q_OS_WIN
            _path = _path.replace("file:///", "");
#else
            _path = _path.replace("file://", "");
#endif
        }
    }

    if (!_path.endsWith(".vas", Qt::CaseInsensitive)) {
        _path += ".vas";
    }

    QSettings settings(_path, QSettings::NativeFormat);

    if (listData.size() > 0) {
        settings.beginWriteArray(group);
        for (int i = 0; i < listData.size(); i++) {
            settings.setArrayIndex(i);
            settings.setValue(key, listData[i]->property("name").toString() + ":" + listData[i]->property("time").toString());
        }
        settings.endArray();
    }
    return _path;
}

