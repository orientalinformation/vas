/****************************************************************************
**
** Copyright (C) 2017 Oriental.
** Contact: dongtp@dfm-engineering.com
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

#ifndef AIRPORTOBJECT_H
#define AIRPORTOBJECT_H

#include <QObject>

class AirportObject : public QObject
{
    Q_OBJECT

     Q_PROPERTY(QString departure READ departure WRITE setDeparture NOTIFY departureChanged)
     Q_PROPERTY(QString arrival READ arrival WRITE setArrival NOTIFY arrivalChanged)
     Q_PROPERTY(int timeFlight READ timeFlight WRITE setTimeFlight NOTIFY timeFlightChanged)
     Q_PROPERTY(int frequent READ frequent WRITE setFrequent NOTIFY frequentChanged)
public:
    AirportObject(QObject *parent = 0);
    AirportObject(const QString &departure, const QString &arrival, const int &timeFlight, const int &frequent, QObject *parent = 0);

    QString departure() const;
    void setDeparture(const QString &departure);

    QString arrival() const;
    void setArrival(const QString &arrival);

    int timeFlight() const;
    void setTimeFlight(const int &timeFlight);

    int frequent() const;
    void setFrequent(const int &frequent);

signals:
    void departureChanged();
    void arrivalChanged();
    void timeFlightChanged();
    void frequentChanged();

private:
    QString _departure;
    QString _arrival;
    int _timeFlight;
    int _frequent;

};

#endif // AIRPORTOBJECT_H
