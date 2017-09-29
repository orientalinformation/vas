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

#include "schedulecalculation.h"
#include <time.h>
#include <QDebug>

ScheduleCalculation::ScheduleCalculation(QObject *parent) :
    QObject(parent)
{

}

void ScheduleCalculation::sortPriorityRatio(QList<FlightData*> &flightData, int sizeFlightData)
{
    for (int u = 0; u < sizeFlightData - 1; u++) {
        for (int j = u; j < sizeFlightData; j++) {
            if (flightData[u]->priorityRatio > flightData[j]->priorityRatio) {
                qSwap(flightData[u], flightData[j]);
            }
        }
    }
}

void ScheduleCalculation::sortTimeDeparture(QList<FlightCalendar> flightCalendar, int totalFlightSort)
{
    for (int i = 0; i < totalFlightSort - 1; i++) {
        for (int j = i; j < totalFlightSort; j++) {
            if (flightCalendar[i].timeDeparture > flightCalendar[j].timeDeparture) {
                qSwap(flightCalendar[i], flightCalendar[j]);
            }
        }
    }
}

int ScheduleCalculation::runSchedule(int timeStart, QList<QObject *> qmlAirportData, QList<QObject *> qmlAircraftData)
{
    int sizeFlightData =  qmlAirportData.size();
    int sizeAircraftData = qmlAircraftData.size();
    int timeDifferenceOneAircraft = 5;
    int timeDifferenceTwoAircraft = 35;
    int totalFlightSort = 0;

    QList<FlightData*> flightData;

    struct AircraftData {
        QString aircraftName;
        QString departure;
    };
    QList<AircraftData> aircraftData;

    QList<FlightCalendar> flightCalendar, aircraft;

    struct FlightCrew {
        int crewID;
        QString aircraftName;
        QString departure;
        QString arrival;
        int timeDeparture;
        int timeArrival;
        int t_duty;
        int frequent;
        bool isCompleted;
    };
    QList<FlightCrew> flightCrew;

    // add flight data
    for (int i = 0; i < sizeFlightData; i++) {
        FlightData *data = new FlightData();
        data->arrival = static_cast<AirportObject*>(qmlAirportData.at(i))->arrival();
        data->departure = static_cast<AirportObject*>(qmlAirportData.at(i))->departure();
        data->flightTime = static_cast<AirportObject*>(qmlAirportData.at(i))->timeFlight();
        data->frequent = static_cast<AirportObject*>(qmlAirportData.at(i))->frequent();
        data->isCompleted = true;
        data->numFlightCompleted = 0;
        data->priorityRatio = 0.0;
        flightData.push_back(data);
    }
    // add aircraft data
    for (int i = 0; i < sizeAircraftData; i++) {
        AircraftData data;
        data.aircraftName = static_cast<AircraftObject*>(qmlAircraftData.at(i))->name();
        data.departure = static_cast<AircraftObject*>(qmlAircraftData.at(i))->departure();
        aircraftData.push_back(data);
    }

    // Divide flight data
    int temp, sizeTemp = sizeFlightData - 1;

    for (int i = 0; i <= sizeFlightData - 1; i++) {
        if (flightData[i]->frequent >= 15) {
            temp = flightData[i]->frequent;
            sizeTemp = sizeTemp + 1;
            flightData[sizeTemp] = flightData[i];
            flightData[i]->frequent = (temp - (temp % 3)) / 3 + temp % 3;
            flightData[sizeTemp]->frequent = (temp - (temp % 3)) / 3;
            sizeTemp = sizeTemp + 1;
            flightData[sizeTemp] = flightData[i];
            flightData[sizeTemp]->frequent = (temp - (temp % 3)) / 3;
        }
    }

    for (int i = 0; i < sizeFlightData; i++) {
        if (flightData[i]->frequent >= 10) {
            temp = flightData[i]->frequent;
            sizeTemp = sizeTemp + 1;
            flightData[sizeTemp] = flightData[i];
            flightData[i]->frequent = (temp - (temp % 2)) / 2 + temp % 2;
            flightData[sizeTemp]->frequent = (temp - (temp % 2)) / 2;
        }
    }

    // Select radio
    srand(time(NULL));

    for (int i = 0; i < sizeFlightData; i++) {
        if (flightData[i]->frequent == 2) {
            flightData[i]->priorityRatio = 0.14;
        } else if (flightData[i]->frequent == 1) {
            flightData[i]->priorityRatio = 0.2;
        } else if (flightData[i]->frequent == 3) {
            flightData[i]->priorityRatio = 0.09;
        } else if (flightData[i]->frequent > 3) {
            flightData[i]->priorityRatio = 0.02;
        }
    }

    // add data aircracft
    for (int i = 0; i < sizeAircraftData; i++) {
        FlightCalendar data;
        data.aircraftName = aircraftData[i].aircraftName;
        data.departure = aircraftData[i].departure;
        aircraft.push_back(data);
    }

    // count total number flight
    for (int i = 0; i < sizeFlightData; i++) {
        totalFlightSort = totalFlightSort + flightData[i]->frequent;
    }

    // Arrangement flight data small -> large to priorityRatio
    // Arrangement aircraft name to departure
    for (int i = 0; i < sizeAircraftData - 1; i++) {
        for (int j = i + 1; j < sizeAircraftData; j++) {
            if (aircraft[i].departure == aircraft[j].departure) {
                qSwap(aircraft[i + 1], aircraft[j]);
                break;
            }
        }
    }

    // Arrangement first flight of aircracft
    for (int i = 0; i < sizeAircraftData; i++) {
        // Arrangement flight data to priority ratio
        sortPriorityRatio(flightData, sizeFlightData);

        for (int j = 0; j < sizeFlightData; j++) {
            if (aircraft[i].departure != flightData[j]->departure) {
                continue;
            }

            aircraft[i].arrival = flightData[j]->arrival;

            if (i == 0) { // if is the first flight
                aircraft[i].timeDeparture = timeStart;
                aircraft[i].timeArrival = timeStart + flightData[j]->flightTime;
                aircraft[i].crewID = 1;

                if (flightData[j]->arrival == "SGN" || flightData[j]->arrival == "HAN") {
                    aircraft[i].flag = 1;
                }

                if (flightData[j]->arrival == "CXR") {
                    aircraft[i].flag = 2;
                }

                flightData[j]->numFlightCompleted = 1;
                flightData[j]->priorityRatio = 1 / flightData[j]->frequent;

                FlightCalendar data(aircraft[i]);
                flightCalendar.push_back(data);

                aircraft[i].timeArrival = aircraft[i].timeArrival + timeDifferenceTwoAircraft;
                break;
            } else {
                if (aircraft[i].departure == aircraft[i - 1].departure) {
                    aircraft[i].timeDeparture = aircraft[i - 1].timeDeparture + timeDifferenceOneAircraft;
                    aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;

                    for (int k = 0; k < flightCalendar.size(); k++) {
                        if (aircraft[i].departure == flightCalendar[k].departure && abs(aircraft[i].timeDeparture - flightCalendar[k].timeDeparture) < 2 * timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                        } else if (aircraft[i].departure == flightCalendar[k].arrival && abs(aircraft[i].timeDeparture - flightCalendar[k].timeArrival) < 2 * timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                        } else if (aircraft[i].arrival == flightCalendar[k].arrival && abs(aircraft[i].timeArrival - flightCalendar[k].timeArrival) < 2 * timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                        }
                    }

                    aircraft[i].crewID = i + 1;

                    if (flightData[j]->arrival == "SGN" || flightData[j]->arrival == "HAN") {
                        aircraft[i].flag = 1;
                    }

                    if (flightData[j]->arrival == "CXR") {
                        aircraft[i].flag = 2;
                    }

                    flightData[j]->numFlightCompleted = flightData[j]->numFlightCompleted + 1;
                    flightData[j]->priorityRatio = flightData[j]->numFlightCompleted / flightData[j]->frequent;
                    FlightCalendar data(aircraft[i]);
                    flightCalendar.push_back(data);
                    aircraft[i].timeArrival = aircraft[i].timeArrival + timeDifferenceTwoAircraft;
                    break;
                } else {
                    aircraft[i].timeDeparture = timeStart;
                    aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;

                    for (int k = 0; k < flightCalendar.size(); k++) {
                        if (aircraft[i].departure == flightCalendar[k].departure && abs(aircraft[i].timeDeparture - flightCalendar[k].timeDeparture) < timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                        } else if (aircraft[i].departure == flightCalendar[k].arrival && abs(aircraft[i].timeDeparture - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                        } else if (aircraft[i].arrival == flightCalendar[k].arrival && abs(aircraft[i].timeArrival - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                        }
                    }

                    aircraft[i].crewID = i + 1;

                    if (flightData[j]->arrival == "SGN" || flightData[j]->arrival == "HAN") {
                        aircraft[i].flag = 1;
                    }

                    if (flightData[j]->arrival == "CXR") {
                        aircraft[i].flag = 2;
                    }

                    flightData[j]->numFlightCompleted = flightData[j]->numFlightCompleted + 1;
                    flightData[j]->priorityRatio = flightData[j]->numFlightCompleted / flightData[j]->frequent;
                    FlightCalendar data(aircraft[i]);
                    flightCalendar.push_back(data);
                    aircraft[i].timeArrival = aircraft[i].timeArrival + timeDifferenceTwoAircraft;
                    break;
                }
            }
        }
    }

    // Arrangement flight calendar
    int z = flightCalendar.size();

    while (z < totalFlightSort) {
        // Arrangement to priority radio
        sortPriorityRatio(flightData, sizeFlightData);

        // Arrangement aircraft data to timeArrival
        for (int i = 0; i < sizeAircraftData; i++) {
            for (int j = i; j < sizeAircraftData; j++) {
                if (aircraft[i].timeArrival > aircraft[j].timeArrival) {
                    qSwap(aircraft[i], aircraft[j]);
                }
            }
        }

        // Implement arrangememt flight calendar
        for (int i = 0; i < sizeAircraftData; i++) {
            bool isAircraft = false;
            for (int j = 0; j < sizeFlightData; j++) {
                if (flightData[j]->priorityRatio == 1) {
                    break;
                }

                if (aircraft[i].arrival != flightData[j]->departure) {
                    continue;
                }

                if (flightData[j]->arrival == "SGN" || flightData[j]->arrival == "HAN") {
                    aircraft[i].flag = 1;
                }

                if (flightData[j]->arrival == "CXR") {
                    aircraft[i].flag = 2;
                }

                if (flightData[j]->arrival != "SGN" && flightData[j]->arrival != "HAN" && flightData[j]->arrival != "CXR") {
                    aircraft[i].flag = 0;
                }

                flightData[j]->numFlightCompleted = flightData[j]->numFlightCompleted + 1;
                flightData[j]->priorityRatio = flightData[j]->numFlightCompleted / flightData[j]->frequent;
                aircraft[i].timeDeparture = aircraft[i].timeArrival;
                aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                aircraft[i].departure = flightData[j]->departure;
                aircraft[i].arrival = flightData[j]->arrival;
                // Check on the same runway, one or multi aircraft can't use takeoff avoid collisions
                for (int k = 0; k < flightCalendar.size(); k++) {
                    if (aircraft[i].departure == flightCalendar[k].departure && abs(aircraft[i].timeDeparture - flightCalendar[k].timeDeparture) < timeDifferenceOneAircraft) {
                        aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                        aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                    } else if (aircraft[i].departure == flightCalendar[k].arrival && abs(aircraft[i].timeDeparture - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                        aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                        aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                    } else if (aircraft[i].arrival == flightCalendar[k].arrival && abs(aircraft[i].timeArrival - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                        aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                        aircraft[i].timeArrival = aircraft[i].timeDeparture + flightData[j]->flightTime;
                    }
                }

                FlightCalendar data(aircraft[i]);
                flightCalendar.push_back(data);

                aircraft[i].timeArrival = aircraft[i].timeArrival + timeDifferenceTwoAircraft;
                z = z + 1;

                isAircraft = true;
                break;
            }
            if (isAircraft) {
                break;
            }
        }

        if (sizeAircraftData == -1) {
            break;
        }
    }

    // Arrangement flight calendar to timeDeparture
    sortTimeDeparture(flightCalendar, totalFlightSort);

    // Arrangement flight crew
    int countFlightCrew = 0; //countFlightCrew+1: is number flight crew used
    int flag_1 = 0;
    int flag_2 = 1;

    for (int i = 0; i < flightCalendar.size(); i++) {
        flightCalendar[i].crewID = 0;
    }

    for (int i = 0; i < sizeAircraftData; i++) {
        FlightCalendar AC_temp[300];
        int temp = 0;

        for (int j = 0; j < flightCalendar.size(); j++) {
            if (flightCalendar[j].aircraftName != aircraft[i].aircraftName) {
                continue;
            }

            AC_temp[temp] = flightCalendar[j];
            temp = temp + 1;
        }

        for (int j = 0; j < temp; j++) {
            if (j == 0) {
                FlightCrew dataCrew;
                dataCrew.crewID = countFlightCrew + 1;
                dataCrew.aircraftName = aircraft[i].aircraftName;
                dataCrew.departure = AC_temp[0].departure;
                dataCrew.timeDeparture = AC_temp[0].timeDeparture;
                dataCrew.t_duty = AC_temp[0].timeDeparture + 660;
                dataCrew.frequent = 1;
                dataCrew.isCompleted = 0;
                AC_temp[j].crewID = countFlightCrew + 1;
                flag_1 = 0;
                flightCrew.push_back(dataCrew);
                continue;
            }

            if (AC_temp[j].flag == 0) {
                AC_temp[j].crewID = flightCrew[countFlightCrew].crewID;
                continue;
            }

            if (AC_temp[j].flag != 0 && AC_temp[j].timeArrival <= flightCrew[countFlightCrew].t_duty) {
                AC_temp[j].crewID = flightCrew[countFlightCrew].crewID;
                flag_2 = j + 1;
                continue;
            }

            if (AC_temp[j].flag != 0 && AC_temp[j].timeArrival > flightCrew[countFlightCrew].t_duty) {
                for (int k = flag_1; k < flag_2; k++) {
                    AC_temp[k].crewID = flightCrew[countFlightCrew].crewID;
                }

                flightCrew[countFlightCrew].departure = AC_temp[flag_1].departure;
                flightCrew[countFlightCrew].arrival = AC_temp[flag_2 - 1].arrival;
                flightCrew[countFlightCrew].timeDeparture = AC_temp[flag_1].timeDeparture;
                flightCrew[countFlightCrew].timeArrival = AC_temp[flag_2 - 1].timeArrival;
                flightCrew[countFlightCrew].frequent = flag_2 - flag_1;
                flightCrew[countFlightCrew].isCompleted = 1;
                countFlightCrew = countFlightCrew + 1;

                FlightCrew dataCrew;
                dataCrew.crewID = countFlightCrew + 1;
                dataCrew.aircraftName = aircraft[i].aircraftName;
                dataCrew.departure = AC_temp[flag_2].departure;
                dataCrew.timeDeparture = AC_temp[flag_2].timeDeparture;
                dataCrew.t_duty = AC_temp[flag_2].timeDeparture + 660;
                dataCrew.frequent = 1;
                dataCrew.isCompleted = 0;
                flightCrew.push_back(dataCrew);
                flag_1 = flag_2;

                for (int k = flag_2; k < j + 1; k++) {
                    AC_temp[k].crewID = flightCrew[countFlightCrew].crewID;
                }

                flag_2 = j + 1;
                continue;
            }
        }

        flightCrew[countFlightCrew].arrival = AC_temp[temp - 1].arrival;
        flightCrew[countFlightCrew].timeArrival = AC_temp[temp - 1].timeArrival;

        for (int j = 0; j < temp; j++) {
            for (int k = 0; k < flightCalendar.size(); k++) {
                if (flightCalendar[k].timeDeparture == AC_temp[j].timeDeparture && flightCalendar[k].aircraftName == AC_temp[j].aircraftName) {
                    flightCalendar[k].crewID = AC_temp[j].crewID;
                }
            }
        }

        countFlightCrew = countFlightCrew + 1;
    }

    //Convert timeDeparture and timeArrival of struct flightCalendar from minutes to hour-minute
    for (int i = 0; i < totalFlightSort; i++) {
        flightCalendar[i].timeDeparture = flightCalendar[i].timeDeparture % 1440;
        flightCalendar[i].timeArrival = flightCalendar[i].timeArrival % 1440;
        flightCalendar[i].timeDeparture = (flightCalendar[i].timeDeparture % 60) + (flightCalendar[i].timeDeparture - (flightCalendar[i].timeDeparture % 60)) * 100 / 60;
        flightCalendar[i].timeArrival = (flightCalendar[i].timeArrival % 60) + (flightCalendar[i].timeArrival - (flightCalendar[i].timeArrival % 60)) * 100 / 60;
    }

    // Arrangement aircraft name random
    for (int i = 0; i < totalFlightSort; i++) {
        flightCalendar[i].flightNumber = "BL";
        flightCalendar[i].flightNumber.insert(2, QString::number(100 + i));
    }

    // sort flightCalendar: to name flight, hour timeDeparture.
    for (int i = 0; i < totalFlightSort - 1; i++) {
        for (int j = i; j < totalFlightSort; j++) {
            if (flightCalendar[i].crewID > flightCalendar[j].crewID) {
                qSwap(flightCalendar[i], flightCalendar[j]);
            }
        }

        sortTimeDeparture(flightCalendar, totalFlightSort);
    }

    // Write new data to file csv
    write(flightCalendar, "");

    return 0;
}

void ScheduleCalculation::write(QList<FlightCalendar> flightCalendar, QString path)
{
    if (path.isEmpty()) {
            path = QApplication::applicationDirPath() + QString("/data/flight_calendar %1.csv").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH_mm_ss"));
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

        if (!flightCalendar.isEmpty()) {
            if (file.pos() == 0) {
                out << "FN," << "AC," << "DEP," << "ARR," << "TD," << "TA," << "TEAM\n";
            }

            for (int i = 0; i < flightCalendar.size(); i++) {
                out << flightCalendar[i].flightNumber << "," << flightCalendar[i].aircraftName<< "," << flightCalendar[i].departure << ","
                    << flightCalendar[i].arrival << "," << flightCalendar[i].timeDeparture << "," << flightCalendar[i].timeArrival << ","
                    << flightCalendar[i].crewID << "\n";
            }

        } else {
            emit error(tr("Unable open file!"));
        }
    }
}
