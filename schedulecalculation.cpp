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

#include <QStandardPaths>

ScheduleCalculation::ScheduleCalculation(QObject *parent) :
    QObject(parent)
{
}

void ScheduleCalculation::sortPriorityRatio(QList<FlightData *> &flightData, int sizeFlightData)
{
    for (int u = 0; u < sizeFlightData - 1; u++) {
        for (int j = u; j < sizeFlightData; j++) {
            if (flightData[u]->priorityRatio > flightData[j]->priorityRatio) {
                qSwap(flightData[u], flightData[j]);
            }
        }
    }
}

void ScheduleCalculation::sortTimeDeparture(QList<FlightCalendar> &flightCalendar, int totalFlightSort)
{
    for (int i = 0; i < totalFlightSort - 1; i++) {
        for (int j = i; j < totalFlightSort; j++) {
            if (flightCalendar[i].timeDeparture > flightCalendar[j].timeDeparture) {
                qSwap(flightCalendar[i], flightCalendar[j]);
            }
        }
    }
}

QList<ScheduleCalculation::FlightCalendar> ScheduleCalculation::sortFlightCalendar(QList<FlightCalendar> &flightCalendar, int size)
{
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size; j++) {
           if (sortByTimeDeparture(flightCalendar.at(i), flightCalendar.at(j))) {
               qSwap(flightCalendar[i], flightCalendar[j]);
           }
        }
    }

    return flightCalendar;
}

bool ScheduleCalculation::sortByTimeDeparture(FlightCalendar lhs, FlightCalendar rhs)
{
    if (lhs.aircraftName < rhs.aircraftName) {
        return true;
    } else if (lhs.aircraftName > rhs.aircraftName) {
        return false;
    } else if (lhs.timeDeparture < rhs.timeDeparture) {
        return true;
    } else if (lhs.timeDeparture > rhs.timeDeparture) {
        return false;
    }

    return true;
}

int ScheduleCalculation::execute(QList<QObject *> qmlAirportData, QList<QObject *> qmlAircraftData, int timeStart, int groundTime)
{
    int airportSize =  qmlAirportData.size();
    int aircraftSize = qmlAircraftData.size();

    int timeDifferenceOneAircraft = 5;
    int totalFlightSort = 0;

    timeStart = timeStart / 100 * 60 + timeStart % 100;

    QList<FlightData *> airportData;

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
    for (int i = 0; i < airportSize; i++) {
        FlightData *data = new FlightData();
        data->arrival = static_cast<AirportObject *>(qmlAirportData.at(i))->arrival();
        data->departure = static_cast<AirportObject *>(qmlAirportData.at(i))->departure();
        data->flightTime = static_cast<AirportObject *>(qmlAirportData.at(i))->timeFlight();
        data->frequent = static_cast<AirportObject *>(qmlAirportData.at(i))->frequent();
        data->isCompleted = true;
        data->numFlightCompleted = 0;
        data->priorityRatio = 0.0;
        airportData.push_back(data);
    }

    // add aircraft data
    for (int i = 0; i < aircraftSize; i++) {
        AircraftData data;
        data.aircraftName = static_cast<AircraftObject *>(qmlAircraftData.at(i))->name();
        data.departure = static_cast<AircraftObject *>(qmlAircraftData.at(i))->departure();
        aircraftData.push_back(data);
    }

    // Divide flight data
    int temp, sizeTemp = airportSize - 1;

    for (int i = 0; i < airportSize; i++) {
        if (airportData[i]->frequent >= 15) {
            temp = airportData[i]->frequent;
            sizeTemp = sizeTemp + 1;

            FlightData *data = new FlightData(airportData[i]);
            airportData.push_back(data);

            airportData[i]->frequent = (temp - (temp % 3)) / 3 + temp % 3;
            airportData[sizeTemp]->frequent = (temp - (temp % 3)) / 3;

            sizeTemp = sizeTemp + 1;
            data = new FlightData(airportData[i]);
            airportData.push_back(data);

            airportData[sizeTemp]->frequent = (temp - (temp % 3)) / 3;
        }
    }

    airportSize = airportData.size();

    for (int i = 0; i < airportSize; i++) {
        if (airportData[i]->frequent >= 10) {
            temp = airportData[i]->frequent;

            sizeTemp = sizeTemp + 1;
            FlightData *data = new FlightData(airportData[i]);
            airportData.push_back(data);

            airportData[i]->frequent = (temp - (temp % 2)) / 2 + temp % 2;
            airportData[sizeTemp]->frequent = (temp - (temp % 2)) / 2;
        }
    }

    airportSize = airportData.size();

    // Select ratio
    for (int i = 0; i < airportSize; i++) {
        if (airportData[i]->frequent == 2) {
            airportData[i]->priorityRatio = 0.14;
        } else if (airportData[i]->frequent == 1) {
            airportData[i]->priorityRatio = 0.2;
        } else if (airportData[i]->frequent == 3) {
            airportData[i]->priorityRatio = 0.09;
        } else if (airportData[i]->frequent > 3) {
            airportData[i]->priorityRatio = 0.02;
        }
    }

    // add data aircracft
    for (int i = 0; i < aircraftSize; i++) {
        FlightCalendar data;
        data.aircraftName = aircraftData[i].aircraftName;
        data.departure = aircraftData[i].departure;
        aircraft.push_back(data);
    }

    // count total number flight
    for (int i = 0; i < airportSize; i++) {
        totalFlightSort = totalFlightSort + airportData[i]->frequent;
    }

    // Arrangement flight data small -> large to priorityRatio
    // Arrangement aircraft name to departure
    for (int i = 0; i < aircraftSize - 1; i++) {
        for (int j = i + 1; j < aircraftSize; j++) {
            if (aircraft[i].departure == aircraft[j].departure) {
                qSwap(aircraft[i + 1], aircraft[j]);
                break;
            }
        }
    }

    // Arrangement first flight of aircracft
    for (int i = 0; i < aircraftSize; i++) {
        // Arrangement flight data to priority ratio
        sortPriorityRatio(airportData, airportSize);

        for (int j = 0; j < airportSize; j++) {
            if (aircraft[i].departure != airportData[j]->departure) {
                continue;
            }

            aircraft[i].arrival = airportData[j]->arrival;

            if (i == 0) { // if is the first flight
                aircraft[i].timeDeparture = timeStart;
                aircraft[i].timeArrival = timeStart + airportData[j]->flightTime;
                aircraft[i].crewID = 1;

                if (airportData[j]->arrival == "SGN" || airportData[j]->arrival == "HAN") {
                    aircraft[i].flag = 1;
                }

                if (airportData[j]->arrival == "CXR") {
                    aircraft[i].flag = 2;
                }

                airportData[j]->numFlightCompleted = 1;
                airportData[j]->priorityRatio = 1.0 / airportData[j]->frequent;

                FlightCalendar data(aircraft[i]);
                flightCalendar.push_back(data);

                aircraft[i].timeArrival += groundTime;
                break;
            } else {
                if (aircraft[i].departure == aircraft[i - 1].departure) {
                    aircraft[i].timeDeparture = aircraft[i - 1].timeDeparture + timeDifferenceOneAircraft;
                    aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;

                    for (int k = 0; k < flightCalendar.size(); k++) {
                        if (aircraft[i].departure == flightCalendar[k].departure && abs(aircraft[i].timeDeparture - flightCalendar[k].timeDeparture) < 2 * timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                        } else if (aircraft[i].departure == flightCalendar[k].arrival && abs(aircraft[i].timeDeparture - flightCalendar[k].timeArrival) < 2 * timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                        } else if (aircraft[i].arrival == flightCalendar[k].arrival && abs(aircraft[i].timeArrival - flightCalendar[k].timeArrival) < 2 * timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                        }
                    }

                    aircraft[i].crewID = i + 1;

                    if (airportData[j]->arrival == "SGN" || airportData[j]->arrival == "HAN") {
                        aircraft[i].flag = 1;
                    }

                    if (airportData[j]->arrival == "CXR") {
                        aircraft[i].flag = 2;
                    }

                    airportData[j]->numFlightCompleted++;
                    airportData[j]->priorityRatio = (double)airportData[j]->numFlightCompleted / airportData[j]->frequent;

                    FlightCalendar data(aircraft[i]);
                    flightCalendar.push_back(data);

                    aircraft[i].timeArrival += groundTime;
                    break;
                } else {
                    aircraft[i].timeDeparture = timeStart;
                    aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;

                    for (int k = 0; k < flightCalendar.size(); k++) {
                        if (aircraft[i].departure == flightCalendar[k].departure && abs(aircraft[i].timeDeparture - flightCalendar[k].timeDeparture) < timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                        } else if (aircraft[i].departure == flightCalendar[k].arrival && abs(aircraft[i].timeDeparture - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                        } else if (aircraft[i].arrival == flightCalendar[k].arrival && abs(aircraft[i].timeArrival - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                            aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                            aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                        }
                    }

                    aircraft[i].crewID = i + 1;

                    if (airportData[j]->arrival == "SGN" || airportData[j]->arrival == "HAN") {
                        aircraft[i].flag = 1;
                    }

                    if (airportData[j]->arrival == "CXR") {
                        aircraft[i].flag = 2;
                    }

                    airportData[j]->numFlightCompleted++;
                    airportData[j]->priorityRatio = (double)airportData[j]->numFlightCompleted / airportData[j]->frequent;

                    FlightCalendar data(aircraft[i]);
                    flightCalendar.push_back(data);

                    aircraft[i].timeArrival += groundTime;
                    break;
                }
            }
        }
    }

    // Arrangement flight calendar
    int z = flightCalendar.size();

label_2:
    while (z < totalFlightSort) {
        // Arrangement to priority radio
        sortPriorityRatio(airportData, airportSize);

        // Arrangement aircraft data to timeArrival
        for (int i = 0; i < aircraftSize; i++) {
            for (int j = i; j < aircraftSize; j++) {
                if (aircraft[i].timeArrival > aircraft[j].timeArrival) {
                    qSwap(aircraft[i], aircraft[j]);
                }
            }
        }

        // Implement arrangememt flight calendar
        for (int i = 0; i < aircraftSize; i++) {
            for (int j = 0; j < airportSize; j++) {
                if (airportData[j]->priorityRatio == 1.0) {
                    break;
                }

                if (aircraft[i].arrival != airportData[j]->departure) {
                    continue;
                }

                if (airportData[j]->arrival == "SGN" || airportData[j]->arrival == "HAN") {
                    aircraft[i].flag = 1;
                }

                if (airportData[j]->arrival == "CXR") {
                    aircraft[i].flag = 2;
                }

                if (airportData[j]->arrival != "SGN" && airportData[j]->arrival != "HAN" && airportData[j]->arrival != "CXR") {
                    aircraft[i].flag = 0;
                }

                airportData[j]->numFlightCompleted++;
                airportData[j]->priorityRatio = (double)airportData[j]->numFlightCompleted / airportData[j]->frequent;

                aircraft[i].timeDeparture = aircraft[i].timeArrival;
                aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                aircraft[i].departure = airportData[j]->departure;
                aircraft[i].arrival = airportData[j]->arrival;

                // Check on the same runway, one or multi aircraft can't use takeoff avoid collisions
                for (int k = 0; k < flightCalendar.size(); k++) {
                    if (aircraft[i].departure == flightCalendar[k].departure && abs(aircraft[i].timeDeparture - flightCalendar[k].timeDeparture) < timeDifferenceOneAircraft) {
                        aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                        aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                    } else if (aircraft[i].departure == flightCalendar[k].arrival && abs(aircraft[i].timeDeparture - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                        aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                        aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                    } else if (aircraft[i].arrival == flightCalendar[k].arrival && abs(aircraft[i].timeArrival - flightCalendar[k].timeArrival) < timeDifferenceOneAircraft) {
                        aircraft[i].timeDeparture = aircraft[i].timeDeparture + timeDifferenceOneAircraft;
                        aircraft[i].timeArrival = aircraft[i].timeDeparture + airportData[j]->flightTime;
                    }
                }

                FlightCalendar data(aircraft[i]);
                flightCalendar.push_back(data);

                aircraft[i].timeArrival += groundTime;

                z = z + 1;

                goto label_2;
            }
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

    for (int i = 0; i < aircraftSize; i++) {
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

    // Arrangement aircraft name random
    for (int i = 0; i < totalFlightSort; i++) {
        flightCalendar[i].flightNumber = "VAA" + QString::number(101 + i);
    }

    flightCalendar = sortFlightCalendar(flightCalendar, totalFlightSort);

    //Convert timeDeparture and timeArrival of struct flightCalendar from minutes to hour-minute
    for (int i = 0; i < totalFlightSort; i++) {
//        flightCalendar[i].timeDeparture = flightCalendar[i].timeDeparture % 1440;
//        flightCalendar[i].timeArrival = flightCalendar[i].timeArrival % 1440;
//        flightCalendar[i].timeDeparture = (flightCalendar[i].timeDeparture % 60) + (flightCalendar[i].timeDeparture - (flightCalendar[i].timeDeparture % 60)) * 100 / 60;
//        flightCalendar[i].timeArrival = (flightCalendar[i].timeArrival % 60) + (flightCalendar[i].timeArrival - (flightCalendar[i].timeArrival % 60)) * 100 / 60;
        if (flightCalendar[i].timeDeparture < timeStart) {
            flightCalendar[i].timeDeparture += 1440;
            flightCalendar[i].timeArrival += 1440;
        }

        flightCalendar[i].timeDeparture = ((flightCalendar[i].timeDeparture % (24 * 60)) - (flightCalendar[i].timeDeparture % (24 * 60)) % 60) / 60 * 100 + (flightCalendar[i].timeDeparture % (24 * 60)) % 60;
        flightCalendar[i].timeArrival = ((flightCalendar[i].timeArrival % (24 * 60)) - (flightCalendar[i].timeArrival % (24 * 60)) % 60) / 60 * 100 + (flightCalendar[i].timeArrival % (24 * 60)) % 60;
    }

    // Write new data to file csv
    write(flightCalendar);

    return 0;
}

void ScheduleCalculation::write(QList<FlightCalendar> flightCalendar, QString path)
{
    if (path.isEmpty()) {
        path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/flight_schedule.csv");
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

        out << "FN,AC,DEP,ARR,TD,TA,TEAM,Status" << endl;

        for (int i = 0; i < flightCalendar.size(); i++) {
            out << flightCalendar[i].flightNumber << "," << flightCalendar[i].aircraftName << "," << flightCalendar[i].departure << ","
                << flightCalendar[i].arrival << "," << flightCalendar[i].timeDeparture << "," << flightCalendar[i].timeArrival << ","
                << flightCalendar[i].crewID << ",0" << endl;
        }
    } else {
        emit error(tr("Can not write result file!"));
    }
}
