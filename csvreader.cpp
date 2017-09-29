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

#include <QApplication>

CSVReader::CSVReader(QObject *parent) : QObject(parent)
{
    _isFlight = true;

    _isAircraft = false;
    _isAirport = false;
}

QList<QObject *> CSVReader::read()
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
                if (lineContent.size() >= 12 && lineContent.first() != "") {
                    FlightObject *flight = new FlightObject();

                    flight->setName(lineContent[0]);

                    flight->setCaptain(lineContent[1]);
                    flight->setCoPilot(lineContent[2]);

                    flight->setCabinManager(lineContent[3]);
                    flight->setCabinAgent1(lineContent[4]);
                    flight->setCabinAgent2(lineContent[5]);
                    flight->setCabinAgent3(lineContent[6]);

                    flight->setDeparture(lineContent[7]);
                    flight->setArrival(lineContent[8]);

                    flight->setTimeDeparture(lineContent[9].toInt());
                    flight->setTimeArrival(lineContent[10].toInt());

                    flight->setNewAircraft(lineContent[11]);

                    if (lineContent.size() >= 13) {
                        flight->setOldAircraft(lineContent[12]);
                    } else {
                        flight->setOldAircraft("");
                    }

                    if (lineContent.size() >= 14) {
                        int status = lineContent[13].toInt();

                        if (status == 1) {
                            flight->setStatus(FlightObject::OnlyDelayDay);
                        } else if (status == 2) {
                            flight->setStatus(FlightObject::OnlyDelayTime);
                        } else if (status == 3) {
                            flight->setStatus(FlightObject::DelayDate);
                        } else {
                            flight->setStatus(FlightObject::Unchanged);
                        }
                    } else {
                        flight->setStatus(FlightObject::Unchanged);
                    }

                    data.append(flight);
                }
            } else if (_isAircraft) {
                if (lineContent.size() >= 2 && lineContent.first() != "") {
                    AircraftObject *aircraft = new AircraftObject();

                    aircraft->setName(lineContent[0]);
                    aircraft->setDeparture(lineContent[1]);

                    data.append(aircraft);
                }
            } else if (_isAirport) {
                if (lineContent.size() >= 4 && lineContent.first() != "") {
                    AirportObject *airport = new AirportObject();

                    airport->setDeparture(lineContent[0]);
                    airport->setArrival(lineContent[1]);
                    airport->setTimeFlight(lineContent[2].toInt());
                    airport->setFrequent(lineContent[3].toInt());

                    data.append(airport);
                }
            }
        }

        file.close();
    } else {
        emit error(tr("Unable to open the file"));
        return QList<QObject *>();
    }

    return data;
}

QString CSVReader::write(QList<FlightObject *> data, QString path)
{
    if (path.isEmpty()) {
        if (!_source.isEmpty()) {
            path = _source.mid(0, (_source.lastIndexOf('/') + 1)) + QString("_optimized %1.csv").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH_mm_ss"));
        } else {
            path = QApplication::applicationDirPath() + QString("/schedules_optimized %1.csv").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH_mm_ss"));
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

    QFile file(path);

    if (file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        QTextStream out(&file);

        while (!data.isEmpty()) {
            FlightObject *flight = data.takeFirst();

            out << flight->name() << "," << flight->captain() << "," << flight->coPilot() << "," << flight->cabinManager() << "," << flight->cabinAgent1()  << ","
                << flight->cabinAgent2() << "," << flight->cabinAgent3() << "," << flight->departure() << "," << flight->arrival() << ","
                << flight->timeDeparture() << "," << flight->timeArrival() << "," << flight->newAircraft() << "," << flight->oldAircraft() << endl;
        }

        file.flush();
        file.close();
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

#ifdef Q_OS_WIN
        _source = source.replace(0, 8, value);
#else
        _source = source.replace(0, 7, value);
#endif

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
