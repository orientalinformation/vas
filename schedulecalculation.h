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

#ifndef SCHEDULECALCULATION_H
#define SCHEDULECALCULATION_H

#include <QFile>
#include <QTime>
#include <QObject>
#include <QtGlobal>
#include <QTextStream>
#include <QApplication>
#include <QtAlgorithms>

#include <aircraftobject.h>
#include <airportobject.h>

class ScheduleCalculation : public QObject
{
    Q_OBJECT

public:
    explicit ScheduleCalculation(QObject *parent = 0);

    struct FlightCalendar {
        QString flightNumber;
        QString aircraftName;
        QString departure;
        QString arrival;
        int timeDeparture;
        int timeArrival;
        int crewID;
        int flag;

        FlightCalendar(){}

        FlightCalendar (const FlightCalendar &data) {
            this->flightNumber = data.flightNumber;
            this->aircraftName = data.aircraftName;
            this->departure = data.departure;
            this->arrival = data.arrival;
            this->timeDeparture = data.timeDeparture;
            this->timeArrival = data.timeArrival;
            this->crewID = data.crewID;
            this->flag = data.flag;
        }
    };

    struct FlightData {
        QString departure;
        QString arrival;
        int flightTime;
        int frequent;
        int numFlightCompleted;
        bool isCompleted;
        double priorityRatio;

        FlightData(){}

        FlightData (const FlightData *data) {
            this->departure = data->departure;
            this->arrival = data->arrival;
            this->flightTime = data->flightTime;
            this->frequent = data->frequent;
            this->numFlightCompleted = data->numFlightCompleted;
            this->isCompleted = data->isCompleted;
            this->priorityRatio = data->priorityRatio;
        }
    };

    Q_INVOKABLE int execute(QList<QObject *> qmlAirportData, QList<QObject *> qmlAircraftData, int timeStart, int groundTime = 35);

    void write(QList<FlightCalendar> flightCalendar, QString path = "");

private:
    void sortPriorityRatio(QList<FlightData *> &flightData, int sizeFlightData);

    void sortTimeDeparture(QList<FlightCalendar> &flightCalendar, int totalFlightSort);

signals:
    void error(const QString& msg);

};

#endif // SCHEDULECALCULATION_H
