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
#include <QApplication>
#include <QDateTime>
#include "flightobject.h"
#include "aircraftobject.h"
#include "problem.h"

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

    int status;
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
    QList <Flight> sortFlightIncrease(QList<Flight> F);
    QList <FlightSchedule *> sortFlightSchedule(QList<FlightSchedule *> flightSchedule);

    int getIndexInArrayByName(QList <Aircraft> array, QString name);
    int getIndexInArrayByName(QStringList array, QString name);

    bool sortByTimeDeparture(FlightSchedule *lhs, FlightSchedule *rhs);
    bool isArrayContains(const QString value, QStringList array);

    Q_INVOKABLE void runReschedule(QStringList problem1, QList<QObject *> problem2, QStringList problem3, QStringList airports,
                                                       QList<QObject *> problem4, int groudTime, int sector, int dutyTime, QList <QObject *> flightObject);
signals:
    void error(const QString& msg);
private:
    void writeFlightSchedule(QString outputPath, QList <FlightSchedule *> flightSchedule);

};

#endif // RESCHEDULECALCULATION_H
