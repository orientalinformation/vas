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

#include "airportobject.h"

AirportObject::AirportObject(QObject *parent) :
    QObject(parent), _departure(""), _arrival(""), _timeFlight(0), _frequent(0)
{
}

AirportObject::AirportObject(const QString &departure, const QString &arrival, const int &timeFlight, const int &frequent, QObject *parent) :
    QObject(parent), _departure(departure), _arrival(arrival), _timeFlight(timeFlight), _frequent(frequent)
{
}

QString AirportObject::departure() const
{
    return _departure;
}

void AirportObject::setDeparture(const QString &departure)
{
    if (departure != _departure) {
        _departure = departure;

        emit departureChanged();
    }
}

QString AirportObject::arrival() const
{
    return _arrival;
}

void AirportObject::setArrival(const QString &arrival)
{
    if (arrival != _arrival) {
        _arrival = arrival;

        emit arrivalChanged();
    }
}

int AirportObject::timeFlight() const
{
    return _timeFlight;
}

void AirportObject::setTimeFlight(const int &timeFlight)
{
    if (timeFlight != _timeFlight) {
        _timeFlight = timeFlight;

        emit timeFlightChanged();
    }
}

int AirportObject::frequent() const
{
    return _frequent;
}

void AirportObject::setFrequent(const int &frequent)
{
    if (frequent != _frequent) {
        _frequent = frequent;

        emit frequentChanged();
    }
}
