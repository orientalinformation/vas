/****************************************************************************
**
** Copyright (C) 2017 Eric Lee.
** Contact: levanhong05@gmail.com
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

#include "flightobject.h"

FlightObject::FlightObject(DataObject *parent) :
    DataObject(parent), _captain(""), _coPilot(""),
    _cabinManager(""), _cabinAgent1(""), _cabinAgent2(""), _cabinAgent3(""),
    _departure(""), _arrival(""), _timeDeparture(0), _timeArrival(0),
    _newAircraft(""), _oldAircraft("")
{
}

FlightObject::FlightObject(const QString &name, const QString &captain, const QString &coPilot,
                           const QString &cabinManager, const QString &cabinAgent1, const QString &cabinAgent2, const QString &cabinAgent3,
                           const QString &departure, const QString &arrival,const int &etd, const int &eta,
                           const QString &newAircraft, const QString &oldAircraft, DataObject *parent) :
    DataObject(parent), _captain(captain), _coPilot(coPilot),
    _cabinManager(cabinManager), _cabinAgent1(cabinAgent1), _cabinAgent2(cabinAgent2), _cabinAgent3(cabinAgent3),
    _departure(departure), _arrival(arrival), _timeDeparture(etd), _timeArrival(eta),
    _newAircraft(newAircraft), _oldAircraft(oldAircraft)
{
    _name = name;
}

QString FlightObject::captain() const
{
    return _captain;
}

void FlightObject::setCaptain(const QString &captain)
{
    if (captain != _captain) {
        _captain = captain;
        emit captainChanged();
    }
}

QString FlightObject::coPilot() const
{
    return _coPilot;
}

void FlightObject::setCoPilot(const QString &coPilot)
{
    if (coPilot != _coPilot) {
        _coPilot = coPilot;
        emit coPilotChanged();
    }
}

QString FlightObject::cabinManager() const
{
    return _cabinManager;
}

void FlightObject::setCabinManager(const QString &cabinManager)
{
    if (cabinManager != _cabinManager) {
        _cabinManager = cabinManager;
        emit cabinManagerChanged();
    }
}

QString FlightObject::cabinAgent1() const
{
    return _cabinAgent1;
}

void FlightObject::setCabinAgent1(const QString &cabinAgent)
{
    if (cabinAgent != _cabinAgent1) {
        _cabinAgent1 = cabinAgent;
        emit cabinAgent1Changed();
    }
}

QString FlightObject::cabinAgent2() const
{
    return _cabinAgent2;
}

void FlightObject::setCabinAgent2(const QString &cabinAgent)
{
    if (cabinAgent != _cabinAgent2) {
        _cabinAgent2 = cabinAgent;
        emit cabinAgent2Changed();
    }
}

QString FlightObject::cabinAgent3() const
{
    return _cabinAgent3;
}

void FlightObject::setCabinAgent3(const QString &cabinAgent)
{
    if (cabinAgent != _cabinAgent3) {
        _cabinAgent3 = cabinAgent;
        emit cabinAgent3Changed();
    }
}

QString FlightObject::departure() const
{
    return _departure;
}

void FlightObject::setDeparture(const QString &departure)
{
    if (departure != _departure) {
        _departure = departure;
        emit departureChanged();
    }
}

QString FlightObject::arrival() const
{
    return _arrival;
}

void FlightObject::setArrival(const QString &arrival)
{
    if (arrival != _arrival) {
        _arrival = arrival;
        emit arrivalChanged();
    }
}

int FlightObject::timeDeparture() const
{
    return _timeDeparture;
}

void FlightObject::setTimeDeparture(const int &etd)
{
    if (etd != _timeDeparture) {
        _timeDeparture = etd;
        emit timeDepartureChanged();
    }
}

int FlightObject::timeArrival() const
{
    return _timeArrival;
}

void FlightObject::setTimeArrival(const int &eta)
{
    if (eta != _timeArrival) {
        _timeArrival = eta;
        emit timeArrivalChanged();
    }
}

QString FlightObject::newAircraft() const
{
    return _newAircraft;
}

void FlightObject::setNewAircraft(const QString &aircraft)
{
    if (aircraft != _newAircraft) {
        _newAircraft = aircraft;
        emit newAircraftChanged();
    }
}

QString FlightObject::oldAircraft() const
{
    return _oldAircraft;
}

void FlightObject::setOldAircraft(const QString &aircraft)
{
    if (aircraft != _oldAircraft) {
        _oldAircraft = aircraft;
        emit oldAircraftChanged();
    }
}
