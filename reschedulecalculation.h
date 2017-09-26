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

#ifndef RESCHEDULECALCULATION_H
#define RESCHEDULECALCULATION_H

#include <QObject>
#include "flightobject.h"
#include "aircraftobject.h"


class Problems : public QObject {
public:
    QString name();
    void setName(const QString &name);
    QString time();
    void setTime(const QString &time);
private:
    QString _name;
    QString _time;
};

struct Crew {
    QString pre;
    QString aft;
};

struct FlightSchedule {
    int timeDeparture;
    int timeArrive;
    int timeDelay;

    QString flightNumber;
    QString aircraft;
    QString departure;
    QString arrive;
    QString aircraftOld;

    QString crew;
    QString crew1;
    QString crew2;
    QString crew3;
    QString crew4;
    QString crew5;
    QString crew6;
};

struct Problem4 {
    QString aircraftNumber;
    int flag;
    int time;
};

struct Aircraft {
    QString aircraftNumber;
    int timeDeparture;
    QString departure;
    bool flagInProcess; // Check aircraft is in process: 0: yes, 1: no
};

struct Flight {
    int timeDeparture;
    int timeFly;
    QString departure;
    QString arrive;
    bool check;
    QString flightNumber;
    QString aircraft;
};


class RescheduleCalculation : public QObject
{
    Q_OBJECT

public:
    explicit RescheduleCalculation(QObject *parent = 0);

    int countAircraft(QList <Aircraft> aircraft);
    QList <Flight> sortF(QList<Flight> F);
    QList <FlightSchedule *> sortFS(QList<FlightSchedule *> FS);

    bool sortByTimeDeparture(FlightSchedule *lhs, FlightSchedule *rhs);
    bool inArray(const QString value, QList <QString> array);
    Q_INVOKABLE void runReschedule(QList<QString> br1, QList<QObject *> br2, QList<QString> br3, QList<QString> AP,
                                                       QList<QObject *> br4, int GT, int TL, int TrL, QList <QObject *> data, QString outputpath);
    int nameToIndex(QList <Aircraft> array, QString name);



signals:

public slots:

private:

};

#endif // RESCHEDULECALCULATION_H
