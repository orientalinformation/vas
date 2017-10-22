#include "iostreams.h"
#include "flightobject.h"

#include <QStandardPaths>

IOStreams::IOStreams(QObject *parent) : QObject(parent)
{
    _path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/settings.vas");
}

QString IOStreams::read(QString key, QString group, QString url)
{
    QString values;

    if (!url.isEmpty()) {
        if (url.startsWith("file:///", Qt::CaseInsensitive)) {
#ifdef Q_OS_WIN
            url = url.replace("file:///", "");
#else
            url = url.replace("file://", "");
#endif
        }

        QSettings settings(url, QSettings::IniFormat);
        settings.beginGroup(group);
        values = settings.value(key).toString();
        settings.endGroup();
    }

    return values;
}

QStringList IOStreams::readData(QString key, QString group, QString url)
{
    QStringList data;

    if (!url.isEmpty()) {
        if (url.startsWith("file:///", Qt::CaseInsensitive)) {
#ifdef Q_OS_WIN
            url = url.replace("file:///", "");
#else
            url = url.replace("file://", "");
#endif
        }

        QSettings settings(url, QSettings::IniFormat);
        settings.beginReadArray(group);

        int index = 0;
        QString item;

        do {
            settings.setArrayIndex(index);
            item = settings.value(key).toString();

            if (!item.isEmpty()) {
                data.append(item);
            }

            index++;
        } while (item.length() != 0);

        settings.endArray();
    }

    return data;
}

QList<QObject *> IOStreams::readObject(QString key, QString group, QString url)
{
    QList<QObject *> objects;

    if (!url.isEmpty()) {
        if (url.startsWith("file:///", Qt::CaseInsensitive)) {
#ifdef Q_OS_WIN
            url = url.replace("file:///", "");
#else
            url = url.replace("file://", "");
#endif
        }

        QSettings settings(url, QSettings::IniFormat);
        settings.beginReadArray(group);
        int index = 0;
        QString item;

        if (key.contains("inputFlights") || key.contains("resultFlights")) {
            do {
                settings.setArrayIndex(index);
                item = settings.value(key).toString();

                if (!item.isEmpty()) {
                    QStringList tmp = item.split(":");

                    FlightObject *data = new FlightObject();

                    data->setName(tmp.at(0));

                    data->setCaptain(tmp.at(1));
                    data->setCoPilot(tmp.at(2));

                    data->setCabinManager(tmp.at(3));
                    data->setCabinAgent1(tmp.at(4));
                    data->setCabinAgent2(tmp.at(5));
                    data->setCabinAgent3(tmp.at(6));

                    data->setDeparture(tmp.at(7));
                    data->setArrival(tmp.at(8));

                    data->setTimeDeparture(tmp.at(9).toInt());
                    data->setTimeArrival(tmp.at(10).toInt());

                    data->setNewAircraft(tmp.at(11));
                    data->setOldAircraft(tmp.at(12));

                    if (tmp.size() >= 14) {
                        int status = tmp[13].toInt();

                        if (status == 1) {
                            data->setStatus(FlightObject::OnlyChangedAirplane);
                        } else if (status == 2) {
                            data->setStatus(FlightObject::OnlyChangedTime);
                        } else if (status == 3) {
                            data->setStatus(FlightObject::BothChangedAirplaneAndTime);
                        } else {
                            data->setStatus(FlightObject::Unchanged);
                        }
                    } else {
                        data->setStatus(FlightObject::Unchanged);
                    }

                    objects.append(data);
                }

                index++;
            } while (item.length() != 0);
        } else {
            do {
                settings.setArrayIndex(index);
                item = settings.value(key).toString();
                TimeModel *data = new TimeModel();

                if (!item.isEmpty()) {
                    QStringList splitValue = item.split(":");

                    data->setName(splitValue.at(0));
                    data->setTime(splitValue.at(1).toInt());
                    objects.append(data);
                }

                index++;
            } while (item.length() != 0);
        }

        settings.endArray();
    }

    return objects;
}

void IOStreams::write(QString key, QString value, QString group, QString url)
{
    _path = url;

    if (_path.isEmpty()) {
        _path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/settings.vas");
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

    QSettings settings(_path, QSettings::IniFormat);

    if (!value.isEmpty()) {
        settings.beginGroup(group);
        settings.setValue(key, value);
        settings.endGroup();
        settings.sync();
    }
}

void IOStreams::write(QString key, QStringList datas, QString group, QString url)
{
    _path = url;

    if (_path.isEmpty()) {
        _path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/settings.vas");
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

    QSettings settings(_path, QSettings::IniFormat);

    if (!datas.isEmpty()) {
        settings.beginWriteArray(group);

        for (int i = 0; i < datas.size(); i++) {
            settings.setArrayIndex(i);
            settings.setValue(key, datas[i]);
        }

        settings.endArray();
        settings.sync();
    }
}

void IOStreams::writeData(QString key, QList<QObject *> listData, QString group, QString url)
{
    _path = url;

    if (_path.isEmpty()) {
        _path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/settings.vas");
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

    QSettings settings(_path, QSettings::IniFormat);

    if (listData.size() > 0) {
        settings.beginWriteArray(group);

        for (int i = 0; i < listData.size(); i++) {
            settings.setArrayIndex(i);
            settings.setValue(key, listData[i]->property("name").toString() + ":" + listData[i]->property("time").toString());
        }

        settings.endArray();
        settings.sync();
    }
}

void IOStreams::writeObject(QString key, QList<QObject *> listData, QString group, QString url)
{
    _path = url;

    if (_path.isEmpty()) {
        _path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/settings.vas");
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

    QString split = ":";
    QSettings settings(_path, QSettings::IniFormat);

    if (listData.size() > 0) {
        settings.beginWriteArray(group);

        for (int i = 0; i < listData.size(); i++) {
            settings.setArrayIndex(i);
            settings.setValue(key, listData.at(i)->property("name").toString() + split +
                              listData.at(i)->property("captain").toString() + split + listData.at(i)->property("coPilot").toString() + split +
                              listData.at(i)->property("cabinManager").toString() + split + listData.at(i)->property("cabinAgent1").toString() + split +
                              listData.at(i)->property("cabinAgent2").toString() + split + listData.at(i)->property("cabinAgent3").toString() + split +
                              listData.at(i)->property("departure").toString() + split + listData.at(i)->property("arrival").toString() + split +
                              listData.at(i)->property("timeDeparture").toString() + split + listData.at(i)->property("timeArrival").toString() + split +
                              listData.at(i)->property("newAircraft").toString() + split + listData.at(i)->property("oldAircraft").toString() + split +
                              listData.at(i)->property("status").toString());
        }

        settings.endArray();
        settings.sync();
    }
}

QString IOStreams::source() const
{
    return _source;
}

void IOStreams::setSource(const QString &source)
{
    if (_source != source) {
        const QString value = "";

        _source = source;

        if (source.startsWith("file:///")) {
#ifdef Q_OS_WIN
            _source = _source.replace(0, 8, value);
#else
            _source = _source.replace(0, 7, value);
#endif
        }

        emit sourceChanged();
    }
}

int TimeModel::time() const
{
    return _time;
}

void TimeModel::setTime(int time)
{
    if (_time != time) {
        _time = time;

        emit timeChanged();
    }
}

QString TimeModel::name() const
{
    return _name;
}

void TimeModel::setName(const QString &name)
{
    if (_name != name) {
        _name = name;

        emit nameChanged();
    }
}
