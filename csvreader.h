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

#ifndef CSVREADER_H
#define CSVREADER_H

#include <QObject>

#include "dataobject.h"
#include "flightobject.h"
#include "aircraftobject.h"
#include "airportobject.h"

class CSVReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool flight READ isFlight WRITE setFlight NOTIFY isFlightChanged)
    Q_PROPERTY(bool aircraft READ isAircraft WRITE setAircraft NOTIFY isAircraftChanged)
    Q_PROPERTY(bool airport READ isAirport WRITE setAirport NOTIFY isAirportChanged)

public:
    explicit CSVReader(QObject *parent = 0);

    Q_INVOKABLE QList <QObject *> read();

    Q_INVOKABLE QString write(QList <FlightObject *> data, QString path = "");

    QString source() const;
    void setSource(QString &source);

    bool isFlight() const;
    void setFlight(bool isFlight);

    bool isAircraft() const;
    void setAircraft(bool isAircraft);

    bool isAirport() const;
    void setAirport(bool isAirport);

signals:
    void error(const QString& msg);
    void finished(bool success);

    void sourceChanged();

    void isFlightChanged();
    void isAircraftChanged();
    void isAirportChanged();

private:
    QString _source;

    bool _isFlight;
    bool _isAircraft;
    bool _isAirport;

};

#endif // CSVREADER_H
