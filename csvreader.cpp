/****************************************************************************
**
** Copyright (C) 2017 Thien Nguyen.
** Contact: thiennt@dfm-engineering.com
** Company: DFM-Engineering Vietnam
**
** This file is part of the VAA Airline Schedules project.
**
**All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
**
****************************************************************************/

#include "csvreader.h"

#include <QFile>
#include <QTextStream>

#include <QTime>
#include <QDate>

#include <QStandardPaths>

CSVReader::CSVReader(QObject *parent) : QObject(parent)
{
    _isFlight = true;

    _isAircraft = false;
    _isAirport = false;
}

QList<QObject *> CSVReader::read(bool isSingle)
{
    if (_source.isEmpty()) {
        emit error(tr("Source is empty"));
        return QList<QObject *>();
    }

    QFile file(_source);

    QList<QObject *> data;

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        in.readLine();

        QStringList lineContent;

        while (!in.atEnd()) {
            lineContent = in.readLine().split(QRegExp("\\,|\\;|\\||\\^"));

            if (_isFlight) {
                if (!isSingle) {
                    if (lineContent.size() >= 12 && lineContent.first() != "") {
                        FlightObject *flight = new FlightObject();

                        flight->setName(lineContent[0].trimmed());

                        flight->setCaptain(lineContent[1].trimmed());
                        flight->setCoPilot(lineContent[2].trimmed());

                        flight->setCabinManager(lineContent[3].trimmed());
                        flight->setCabinAgent1(lineContent[4].trimmed());
                        flight->setCabinAgent2(lineContent[5].trimmed());
                        flight->setCabinAgent3(lineContent[6].trimmed());

                        flight->setDeparture(lineContent[7].trimmed());
                        flight->setArrival(lineContent[8].trimmed());

                        int timeDeparture = lineContent[9].trimmed().toInt();
                        timeDeparture = timeDeparture / 100 * 60 + timeDeparture % 100;

                        int timeArrival = lineContent[10].trimmed().toInt();
                        timeArrival = timeArrival / 100 * 60 + timeArrival % 100;

                        flight->setTimeDeparture(timeDeparture);
                        flight->setTimeArrival(timeArrival);

                        flight->setNewAircraft(lineContent[11].trimmed());

                        if (lineContent.size() >= 13) {
                            flight->setOldAircraft(lineContent[12].trimmed());
                        } else {
                            flight->setOldAircraft("");
                        }

                        if (lineContent.size() >= 14) {
                            int status = lineContent[13].trimmed().toInt();

                            if (status == 1) {
                                flight->setStatus(FlightObject::OnlyChangedAirplane);
                            } else if (status == 2) {
                                flight->setStatus(FlightObject::OnlyChangedTime);
                            } else if (status == 3) {
                                flight->setStatus(FlightObject::BothChangedAirplaneAndTime);
                            } else {
                                flight->setStatus(FlightObject::Unchanged);
                            }
                        } else {
                            flight->setStatus(FlightObject::Unchanged);
                        }

                        data.append(flight);
                    }
                } else {
                    if (lineContent.size() >= 7 && lineContent.first() != "") {
                        FlightObject *flight = new FlightObject();

                        flight->setName(lineContent[0].trimmed());

                        flight->setCaptain(lineContent[6].trimmed());
                        flight->setCoPilot(lineContent[6].trimmed());

                        flight->setCabinManager(lineContent[6].trimmed());
                        flight->setCabinAgent1(lineContent[6].trimmed());
                        flight->setCabinAgent2(lineContent[6].trimmed());
                        flight->setCabinAgent3(lineContent[6].trimmed());

                        flight->setDeparture(lineContent[2].trimmed());
                        flight->setArrival(lineContent[3].trimmed());

                        int timeDeparture = lineContent[4].trimmed().toInt();
                        timeDeparture = timeDeparture / 100 * 60 + timeDeparture % 100;

                        int timeArrival = lineContent[5].trimmed().toInt();
                        timeArrival = timeArrival / 100 * 60 + timeArrival % 100;

                        flight->setTimeDeparture(timeDeparture);
                        flight->setTimeArrival(timeArrival);

                        flight->setNewAircraft(lineContent[1].trimmed());

                        flight->setOldAircraft("");

                        if (lineContent.size() >= 8) {
                            int status = lineContent[7].trimmed().toInt();

                            if (status == 1) {
                                flight->setStatus(FlightObject::OnlyChangedAirplane);
                            } else if (status == 2) {
                                flight->setStatus(FlightObject::OnlyChangedTime);
                            } else if (status == 3) {
                                flight->setStatus(FlightObject::BothChangedAirplaneAndTime);
                            } else {
                                flight->setStatus(FlightObject::Unchanged);
                            }
                        } else {
                            flight->setStatus(FlightObject::Unchanged);
                        }

                        data.append(flight);
                    }
                }
            } else if (_isAircraft) {
                if (lineContent.size() >= 2 && lineContent.first() != "") {
                    AircraftObject *aircraft = new AircraftObject();

                    aircraft->setName(lineContent[0].trimmed());
                    aircraft->setDeparture(lineContent[1].trimmed());

                    data.append(aircraft);
                }
            } else if (_isAirport) {
                if (lineContent.size() >= 4 && lineContent.first() != "") {
                    AirportObject *airport = new AirportObject();

                    airport->setDeparture(lineContent[0].trimmed());
                    airport->setArrival(lineContent[1].trimmed());
                    airport->setTimeFlight(lineContent[2].trimmed().toInt());
                    airport->setFrequent(lineContent[3].trimmed().toInt());

                    data.append(airport);
                }
            }
        }

        file.close();
    } else {
        emit error(tr("Unable to open the file"));
        return QList<QObject *>();
    }

    if (_isFlight) {
        QList<int> indexUniqueFlight;

        int numberOfFlight = data.length();

        // Filter get information of flight
        QStringList uniqueAircrafts;

        for (int i = 0; i < numberOfFlight; i++) {
            QString name = static_cast<FlightObject *>(data.at(i))->newAircraft();

            if (!uniqueAircrafts.contains(name, Qt::CaseInsensitive)) {
                indexUniqueFlight.push_back(i);
                uniqueAircrafts.append(name);
            }
        }

        indexUniqueFlight.push_back(numberOfFlight);

        // Time synchronous TD with default time Oh
        for (int j = 0; j < (indexUniqueFlight.size() - 1); j++) {
            for (int i = indexUniqueFlight[j]; i <= indexUniqueFlight[j + 1] - 2; i++) {
                if (static_cast<FlightObject *>(data.at(i))->timeDeparture() > static_cast<FlightObject *>(data.at(i + 1))->timeDeparture()) {
                    if (i < ((indexUniqueFlight[j + 1] + indexUniqueFlight[j] - 1) / 2)) {
                        for (int k = indexUniqueFlight[j]; k <= i; k++) {
                            static_cast<FlightObject *>(data.at(k))->setTimeDeparture((static_cast<FlightObject *>(data.at(k))->timeDeparture() - 1440));
                        }
                    } else {
                        for (int k = i + 1; k <= indexUniqueFlight[j + 1] - 1; k++) {
                            static_cast<FlightObject *>(data.at(k))->setTimeDeparture((static_cast<FlightObject *>(data.at(k))->timeDeparture() + 1440));
                        }
                    }
                }

                if (static_cast<FlightObject *>(data.at(i))->timeArrival() > static_cast<FlightObject *>(data.at(i + 1))->timeArrival()) {
                    if (i < ((indexUniqueFlight[j + 1] + indexUniqueFlight[j] - 1) / 2)) {
                        for (int k = indexUniqueFlight[j]; k <= i; k++) {
                            static_cast<FlightObject *>(data.at(k))->setTimeArrival((static_cast<FlightObject *>(data.at(k))->timeArrival() - 1440));
                        }
                    } else {
                        for (int k = i + 1; k <= indexUniqueFlight[j + 1] - 1; k++) {
                            static_cast<FlightObject *>(data.at(k))->setTimeArrival((static_cast<FlightObject *>(data.at(k))->timeArrival() + 1440));
                        }
                    }
                }
            }
        }
    }

    return data;
}

QString CSVReader::write(QList<QObject *> data, QString path)
{
    if (path.isEmpty()) {
        if (!_source.isEmpty()) {
            path = _source.mid(0, (_source.lastIndexOf("/data/") + 1)) + QString("_optimized %1.csv").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH_mm_ss"));
        } else {
            path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/schedules_optimized %1.csv").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH_mm_ss"));
        }
    } else {
        if (path.startsWith("file:///", Qt::CaseInsensitive)) {
#ifdef Q_OS_WIN
            path = path.replace("file:///", "");
#else
            path = path.replace("file://", "");
#endif
        }
    }

    if (!path.endsWith(".csv", Qt::CaseInsensitive)) {
        path += ".csv";
    }

    QFile file(path);

    if (file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        QTextStream out(&file);

        out << "Fligt number, Full name captain, Full name FO, Full name CM, Full name CA, Full name CA, Full name CA,DEP,ARR,TD,TA,AC,ACo,STATUS" << endl;

        for (int i = 0; i < data.size(); i++) {
            int ted = data[i]->property("timeDeparture").toInt();
            int tea = data[i]->property("timeArrival").toInt();

            ted = ((ted % (24 * 60)) - (ted % (24 * 60)) % 60) / 60 * 100 + (ted % (24 * 60)) % 60;
            tea = ((tea % (24 * 60)) - (tea % (24 * 60)) % 60) / 60 * 100 + (tea % (24 * 60)) % 60;

            out << data[i]->property("name").toString() << "," << data[i]->property("captain").toString() << "," << data[i]->property("coPilot").toString() << ","
                << data[i]->property("cabinManager").toString() << "," << data[i]->property("cabinAgent1").toString() << "," << data[i]->property("cabinAgent2").toString() << ","
                << data[i]->property("cabinAgent3").toString() << "," << data[i]->property("departure").toString() << "," << data[i]->property("arrival").toString() << ","
                << QString::number(ted) << "," << QString::number(tea) << "," << data[i]->property("newAircraft").toString() << ","
                << data[i]->property("oldAircraft").toString() << "," << data[i]->property("status").toString() << endl;
        }
    } else {
        emit error(tr("Unable open file!"));
        return QString();
    }

    return path;
}

QString CSVReader::source() const
{
    return _source;
}

void CSVReader::setSource(QString &source)
{
    if (_source != source) {
        const QString value = "";

        if (source.startsWith("file:///")) {
#ifdef Q_OS_WIN
            _source = source.replace(0, 8, value);
#else
            _source = source.replace(0, 7, value);
#endif
        } else {
            _source = source;
        }

        emit sourceChanged();
    }
}

bool CSVReader::isFlight() const
{
    return _isFlight;
}

void CSVReader::setFlight(bool isFlight)
{
    if (isFlight != _isFlight) {
        _isFlight = isFlight;

        emit isFlightChanged();
    }
}

bool CSVReader::isAircraft() const
{
    return _isAircraft;
}

void CSVReader::setAircraft(bool isAircraft)
{
    if (isAircraft != _isAircraft) {
        _isAircraft = isAircraft;

        emit isAircraftChanged();
    }
}

bool CSVReader::isAirport() const
{
    return _isAirport;
}

void CSVReader::setAirport(bool isAirport)
{
    if (isAirport != _isAirport) {
        _isAirport = isAirport;

        emit isAirportChanged();
    }
}
