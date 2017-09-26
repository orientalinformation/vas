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

#include "aircraftobject.h"

AircraftObject::AircraftObject(DataObject *parent) :
    DataObject(parent), _departure("")
{
}

AircraftObject::AircraftObject(const QString &name, const QString &departure, DataObject *parent):
    DataObject(parent), _departure(departure)
{
    _name = name;
}

QString AircraftObject::departure() const
{
    return _departure;
}

void AircraftObject::setDeparture(const QString &departure)
{
    if (departure != _departure) {
        _departure = departure;
        emit departureChanged();
    }
}
