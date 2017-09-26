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

#ifndef AIRCRAFTOBJECT_H
#define AIRCRAFTOBJECT_H

#include <QObject>
#include "dataobject.h"

class AircraftObject : public DataObject
{
    Q_OBJECT

    Q_PROPERTY(QString departure READ departure WRITE setDeparture NOTIFY departureChanged)

public:
    AircraftObject(DataObject *parent = 0);
    AircraftObject(const QString &name, const QString &departure, DataObject *parent = 0);

    QString departure() const;
    void setDeparture(const QString &departure);

signals:
    void departureChanged();

private:
    QString _departure;
};

#endif // AIRCRAFTOBJECT_H
