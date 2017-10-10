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

#include "reschedulecalculation.h"

#include <QtAlgorithms>

#include <QFile>
#include <QTextStream>
#include <QStandardPaths>

#include <QDebug>

RescheduleCalculation::RescheduleCalculation(QObject *parent) :
    QObject(parent)
{

}

int RescheduleCalculation::countAircraft(QList<Aircraft> aircraft) {
    int count = 0;

    for (int i = 0; i < aircraft.size(); i++) {
        if (aircraft[i].flagInProcess == false) {
            count = count + 1;
        }
    }

    return count;
}

QList <Flight> RescheduleCalculation::sortFlightIncrease(QList<Flight> &flight) {
    for (int i = 0; i < (flight.size() - 1); i++) {
         for (int j = i + 1; j < flight.size(); j++) {
             if (flight[i].timeDeparture > flight[j].timeDeparture) {
                 Flight tempFlight;
                 tempFlight = flight[i];
                 flight[i] = flight[j];
                 flight[j] = tempFlight;
             }
         }
     }

     return flight;
}

bool RescheduleCalculation::inArray(const QString value, QStringList array)
{
    return std::find(array.begin(), array.end(), value) != array.end();
}

bool RescheduleCalculation::sortByTimeDeparture(FlightSchedule *lhs, FlightSchedule *rhs)
{
    if (lhs->aircraft < rhs->aircraft) {
        return true;
    } else if (lhs->aircraft > rhs->aircraft) {
        return false;
    } else if (lhs->timeDeparture < rhs->timeDeparture) {
        return true;
    } else if (lhs->timeDeparture > rhs->timeDeparture) {
        return false;
    }

    return true;
}

QList<FlightSchedule *> RescheduleCalculation::sortFlightSchedule(QList <FlightSchedule *> &flightSchedule)
{
    int sizeflightSchedule = flightSchedule.size();
     for (int i = 0; i < sizeflightSchedule - 1; i++) {
         for (int j = 0; j < sizeflightSchedule; j++) {
            if (sortByTimeDeparture(flightSchedule.at(i), flightSchedule.at(j))) {
                qSwap(flightSchedule[i], flightSchedule[j]);
            }
         }
     }

    return flightSchedule;
}

void RescheduleCalculation::writeFlightSchedule(QString outputPath, QList <FlightSchedule *> flightSchedule)
{
    QFile file(outputPath);

    if (file.open(QIODevice::WriteOnly | QIODevice::Text |  QIODevice::Truncate)) {
        QTextStream out(&file);

        out << "FN,CREW1,CREW2,CREW3,CREW4,CREW5,CREW6,DEP,ARR,TD,TA,AC,ACo,STATUS" << endl;

        for (int i = 0; i < flightSchedule.size(); i++) {
            out << flightSchedule.at(i)->flightNumber << "," << flightSchedule.at(i)->crew1 << "," << flightSchedule.at(i)->crew2 << "," << flightSchedule.at(i)->crew3
                << "," << flightSchedule.at(i)->crew4 << "," << flightSchedule.at(i)->crew5 << "," << flightSchedule.at(i)->crew6 << "," << flightSchedule.at(i)->departure
                << "," << flightSchedule.at(i)->arrive <<  "," << flightSchedule.at(i)->timeDeparture << "," << flightSchedule.at(i)->timeArrive
                << "," << flightSchedule.at(i)->aircraft << "," << flightSchedule.at(i)->aircraftOld << "," << flightSchedule.at(i)->status << endl;
        }
    } else {
        emit error(tr("Can not write result file!"));
    }

}

void RescheduleCalculation::runReschedule(QStringList problem1,
       QList<QObject *> problem2, QStringList problem3, QStringList airports, QList<QObject *> problem4,
       int groundTime, int sector, int dutyTime, QList <QObject *> flightObject)
{
    QList <FlightSchedule *> flightSchedule;
    QList <Aircraft> aircraft;
    QList <Flight> flight;

    QStringList P1SGN;
    QStringList P1HAN;
    QStringList P1CXR;
    QStringList P2SGN;
    QStringList P2HAN;
    QStringList P2CXR;
    QStringList P3SGN;
    QStringList P3HAN;
    QStringList P3CXR;
    QStringList P4SGN;
    QStringList P4HAN;
    QStringList P4CXR;
    QStringList P5SGN;
    QStringList P5HAN;
    QStringList P5CXR;
    QStringList P6SGN;
    QStringList P6HAN;
    QStringList P6CXR;

    int cP1SGN = 0, cP2SGN = 0, cP3SGN = 0, cP4SGN = 0, cP5SGN = 0, cP6SGN = 0; //Number crew to SGN
    int cP1HAN = 0, cP2HAN = 0, cP3HAN = 0, cP4HAN = 0, cP5HAN = 0, cP6HAN = 0; //Number crew to SGN
    int cP1CXR = 0, cP2CXR = 0, cP3CXR = 0, cP4CXR = 0, cP5CXR = 0, cP6CXR = 0; //Number crew to CXR
    int numberOfFlight = 0, n = 0;

    QList<int> indexDuplicateFlight;

    numberOfFlight = flightObject.length();

    //Exchange time
    for (int i = 0; i < numberOfFlight; i++) {
        int timeDeparture, timeArrival;
        timeDeparture = static_cast<FlightObject *>(flightObject.at(i))->timeDeparture();
        timeArrival = static_cast<FlightObject *>(flightObject.at(i))->timeArrival();
        timeDeparture = timeDeparture / 100 * 60 + timeDeparture % 100;
        timeArrival = timeArrival / 100 * 60 + timeArrival % 100;
        static_cast<FlightObject *>(flightObject.at(i))->setTimeDeparture(timeDeparture);
        static_cast<FlightObject *>(flightObject.at(i))->setTimeArrival(timeArrival);
    }

    // Filter get information of flight
    QStringList ACC;

    for (int i = 0; i < numberOfFlight; i++) {
        QString kt = static_cast<FlightObject *>(flightObject.at(i))->newAircraft();

        if (inArray(kt, ACC) == false) {
            indexDuplicateFlight.push_back(i);
            ACC.append(kt);
            n++;
        }
    }

    indexDuplicateFlight.push_back(numberOfFlight);

    // Time synchronous TD with default time Oh
    for (int j = 0; j < (indexDuplicateFlight.size() - 1); j++) {
        for (int i = indexDuplicateFlight[j]; i <= indexDuplicateFlight[j + 1] - 2; i++) {
            if (static_cast<FlightObject *>(flightObject.at(i))->timeDeparture() > static_cast<FlightObject *>(flightObject.at(i + 1))->timeDeparture()) {
                if (i < ((indexDuplicateFlight[j + 1] + indexDuplicateFlight[j] - 1) / 2)) {
                    for (int k = indexDuplicateFlight[j]; k <= i; k++) {
                        static_cast<FlightObject *>(flightObject.at(k))->setTimeDeparture((static_cast<FlightObject *>(flightObject.at(k))->timeDeparture() - 24 * 60));
                    }
                } else {
                    for (int k = i + 1; k <= indexDuplicateFlight[j + 1] - 1; k++) {
                        static_cast<FlightObject *>(flightObject.at(k))->setTimeDeparture((static_cast<FlightObject *>(flightObject.at(k))->timeDeparture() + 24 * 60));
                    }
                }
            }
        }
    }

    //Get info of crew
    // Crew1
    QStringList crew;

    for (int j = 0; j < numberOfFlight; j++) {
        QString captain = static_cast<FlightObject *>(flightObject.at(j))->captain();

        if (inArray(captain, crew) == false) {
            QString departure = static_cast<FlightObject *>(flightObject.at(j))->departure();

            if (departure == "SGN") {
                P1SGN.push_back(captain);
                cP1SGN++;
            } else if (departure == "HAN") {
                P1HAN.push_back(captain);
                cP1HAN++;
            } else if (departure == "CXR") {
                P1CXR.push_back(captain);
                cP1CXR++;
            }
            crew.push_back(captain);
        }
    }

    crew.clear();

    //crew2
    for (int j = 0; j < numberOfFlight; j++) {
        QString coPilot = static_cast<FlightObject *>(flightObject.at(j))->coPilot();

        if (inArray(coPilot, crew) == false) {
            QString departure = static_cast<FlightObject *>(flightObject.at(j))->departure();

            if (departure == "SGN") {
                P2SGN.push_back(coPilot);
                cP2SGN++;
            } else if (departure == "HAN") {
                P2HAN.push_back(coPilot);
                cP2HAN++;
            } else if (departure == "CXR") {
                P2CXR.push_back(coPilot);
                cP2CXR++;
            }
            crew.push_back(coPilot);
        }
    }

    crew.clear();

    // Crew3
    for (int j = 0; j < numberOfFlight; j++) {
        QString cabinManager = static_cast<FlightObject *>(flightObject.at(j))->cabinManager();

        if (inArray(cabinManager, crew) == false) {
            QString departure = static_cast<FlightObject *>(flightObject.at(j))->departure();

            if (departure == "SGN") {
                P3SGN.push_back(cabinManager);
                cP3SGN++;
            } else if (departure == "HAN") {
                P3HAN.push_back(cabinManager);
                cP3HAN++;
            } else if (departure == "CXR") {
                P3CXR.push_back(cabinManager);
                cP3CXR++;
            }
            crew.push_back(cabinManager);
        }
    }

    crew.clear();

    // Crew4
    for (int j = 0; j < numberOfFlight; j++) {
        QString cabinAgent = static_cast<FlightObject *>(flightObject.at(j))->cabinAgent1();

        if (inArray(cabinAgent, crew) == false) {
            QString departure = static_cast<FlightObject *>(flightObject.at(j))->departure();

            if (departure == "SGN") {
                P4SGN.push_back(cabinAgent);
                cP4SGN++;
            } else if (departure == "HAN") {
                P4HAN.push_back(cabinAgent);
                cP4HAN++;
            } else if (departure == "CXR") {
                P4CXR.push_back(cabinAgent);
                cP4CXR++;
            }
            crew.push_back(cabinAgent);
        }
    }

    crew.clear();

    // Crew5
    for (int j = 0; j < numberOfFlight; j++) {
        QString cabinAgent = static_cast<FlightObject *>(flightObject.at(j))->cabinAgent2();

        if (inArray(cabinAgent, crew) == false) {
            QString departure = static_cast<FlightObject *>(flightObject.at(j))->departure();

            if (departure == "SGN") {
                P5SGN.push_back(cabinAgent);
                cP5SGN++;
            } else if (departure == "HAN") {
                P5HAN.push_back(cabinAgent);
                cP5HAN++;
            } else if (departure == "CXR") {
                P5CXR.push_back(cabinAgent);
                cP5CXR++;
            }
            crew.push_back(cabinAgent);
        }
    }

    crew.clear();

    // Crew6
    for (int j = 0; j < numberOfFlight; j++) {
        QString cabinAgent = static_cast<FlightObject *>(flightObject.at(j))->cabinAgent3();

        if (inArray(cabinAgent, crew) == false) {
            QString departure = static_cast<FlightObject *>(flightObject.at(j))->departure();

            if (departure == "SGN") {
                P6SGN.push_back(cabinAgent);
                cP6SGN++;
            } else if (departure == "HAN") {
                P6HAN.push_back(cabinAgent);
                cP6HAN++;
            } else if (departure == "CXR") {
                P6CXR.push_back(cabinAgent);
                cP6CXR++;
            }
            crew.push_back(cabinAgent);
        }
    }

    // Time synchronous TA with default time Oh
    for (int j = 0; j < indexDuplicateFlight.size() - 1; j++) {
        for (int i = indexDuplicateFlight[j]; i <= indexDuplicateFlight[j + 1] - 2; i++) {
            if (static_cast<FlightObject *>(flightObject.at(i))->timeArrival() >static_cast<FlightObject *>(flightObject.at(i + 1))->timeArrival()) {
                if (i < ((indexDuplicateFlight[j + 1] + indexDuplicateFlight[j] - 1) / 2)) {
                    for (int k = indexDuplicateFlight[j]; k <= i; k++) {
                        static_cast<FlightObject *>(flightObject.at(k))->setTimeArrival(static_cast<FlightObject *>(flightObject.at(k))->timeArrival() - 24 * 60);
                    }
                } else {
                    for (int k = i + 1; k <= indexDuplicateFlight[j + 1] - 1; k++) {
                       static_cast<FlightObject *>(flightObject.at(k))->setTimeArrival(static_cast<FlightObject *>(flightObject.at(k))->timeArrival() + 24 * 60);
                    }
                }
            }
        }
    }

    // add data aircraft
    for (int i = 0; i < indexDuplicateFlight.size() - 1; i++) {
        Aircraft aircraft1;
        aircraft1.aircraftNumber = static_cast<FlightObject *>(flightObject.at(indexDuplicateFlight[i]))->newAircraft();
        aircraft1.timeDeparture = static_cast<FlightObject *>(flightObject.at(indexDuplicateFlight[i]))->timeDeparture();
        aircraft1.flagInProcess = false;
        aircraft1.status = 0;
        aircraft1.departure = static_cast<FlightObject *>(flightObject.at(indexDuplicateFlight[i]))->departure();
        aircraft.push_back(aircraft1);
    }

    // add data flight
    for (int i = 0; i < numberOfFlight; i++) {
        Flight fli;
        fli.aircraft = static_cast<FlightObject *>(flightObject.at(i))->newAircraft();
        fli.arrive = static_cast<FlightObject *>(flightObject.at(i))->arrival();
        fli.check = false;
        fli.departure = static_cast<FlightObject *>(flightObject.at(i))->departure();
        fli.flightNumber = static_cast<FlightObject *>(flightObject.at(i))->name();
        fli.timeDeparture = static_cast<FlightObject *>(flightObject.at(i))->timeDeparture();
        fli.timeFly = static_cast<FlightObject *>(flightObject.at(i))->timeArrival() - static_cast<FlightObject *>(flightObject.at(i))->timeDeparture() + groundTime;
        flight.push_back(fli);
    }

    for (int i = 0; i < problem1.size(); i++) {
        int maxAC = -2000, mAC, tg;
        int idx = nameToIndex(aircraft, problem1.at(i));
        for (int j = 0; j < aircraft.size(); j++) {

            if (aircraft[idx].departure == aircraft[j].departure && idx != -1) {
                if (aircraft[j].timeDeparture > maxAC) {
                    maxAC = aircraft[j].timeDeparture;
                    mAC = j;
                }
            }
        }

        tg = aircraft[idx].timeDeparture;
        aircraft[idx].timeDeparture = aircraft[mAC].timeDeparture;
        aircraft[mAC].timeDeparture = tg;
    }

    // write information flight crash
    for (int i = 0; i < problem1.size(); i++) {
        int idx = nameToIndex(aircraft, problem1.at(i));
        if (idx >= 0) {
            aircraft[idx].flagInProcess = true;
            aircraft[idx].status = 1;
        }
    }

    for (int i = 0; i < problem2.size(); i++) {
        problem2.at(i)->property("time").setValue(((
                     problem2.at(i)->property("time").toInt() - problem2.at(i)->property("time").toInt() % 100)
                                              / 100 * 60 + problem2.at(i)->property("time").toInt()));
    }

    for (int i = 0; i < problem4.size(); i++) {
        problem4.at(i)->property("time").setValue(((
                     problem4.at(i)->property("time").toInt() - problem4.at(i)->property("time").toInt() % 100)
                                              / 100 * 60 + problem4.at(i)->property("time").toInt()));
    }

    for (int i = 0; i < problem2.size(); i++) {
        QString name = problem2.at(i)->property("name").toString();

        int idx = nameToIndex(aircraft, name);
        if (idx >= 0) {
            aircraft[idx].timeDeparture = problem2.at(i)->property("time").toInt();
            aircraft[idx].status = 2;
        }
    }

    QStringList acProblem3;

    for (int i = 0; i < problem3.size(); i++) {
        int idx = nameToIndex(aircraft, problem3.at(i));
        if (idx >= 0) {
            acProblem3.push_back(aircraft[idx].aircraftNumber);
            aircraft[idx].status = 3;
        }
    }

    QStringList acProblem4;

    for (int i = 0; i < problem4.size(); i++) {
        int idx = nameToIndex(aircraft, problem4.at(i)->property("name").toString());
        if (idx >= 0) {
            acProblem4.push_back(aircraft[idx].aircraftNumber);
            aircraft[idx].status = 2;
        }
    }

    QList<Problem4> AC4;

    for (int i = 0; i < problem4.size(); i++) {
        Problem4 ac4;
        int idx = nameToIndex(aircraft, problem4.at(i)->property("name").toString());
        if (idx >= 0) {
            ac4.aircraftNumber = aircraft[idx].aircraftNumber;
            ac4.flag = 0;
            ac4.time = problem4.at(i)->property("time").toInt();
            AC4.push_back(ac4);
        }
    }

    // Handling
    do {
        int minimumTime = 10000;
        int m = 1;

        for (int i = 0; i < aircraft.size(); i++) {
            if ((aircraft[i].timeDeparture < minimumTime) && (aircraft[i].flagInProcess == false)) {
                minimumTime = aircraft[i].timeDeparture;
                m = i;
            }
        }

        // Find a flight fit
        QList<Flight> flight1;

        if (inArray(aircraft[m].aircraftNumber, acProblem3) == true) {
            for (int i = 0; i < flight.size(); i++) {
                if ((flight[i].departure == aircraft[m].departure) && (flight[i].check == false)) {
                    if (inArray(flight[i].arrive, airports) == true) {
                        flight1.push_back(flight[i]);
                    }
                }
            }
        } else {
            for (int i = 0; i < flight.size(); i++) {
                if ((flight[i].departure.compare(aircraft[m].departure) == 0) && (flight[i].check == false)) {
                    flight1.push_back(flight[i]);
                }
            }
        }

        if (flight1.size() > 0) {
            QList<Flight> flight2;
            flight1 = sortFlightIncrease(flight1);

            for (int i = 0; i < flight1.size(); i++) {
                if (flight1[i].aircraft == aircraft[m].aircraftNumber) {
                    flight2.push_back(flight1[i]);
                }
            }

            int k, cf = 0;

            for (k = 0; k < flight1.size(); k++) {
                for (int i = 0; i < flight.size(); i++) {
                    if (flight[i].departure == flight1[k].arrive) {
                        cf = cf + 1;
                    }
                }

                if (cf > 0) {
                    break;
                }
            }

            if (cf == 0) {
                k = 1;
            }

            if (flight2.size() > 0) {
                int cf = 0;
                int k1;

                for (k1 = 0; k1 < flight2.size(); k1++) {
                    for (int i = 0; i < flight.size(); i++) {
                        if (flight[i].departure == flight2[k].arrive) {
                            cf = cf + 1;
                        }
                    }

                    if (cf > 0) {
                        break;
                    }
                }

                if (cf == 0) {
                    k1 = 1;
                }

                for (int i = 0; i < flight1.size(); i++) {
                    if (flight2[k1].flightNumber == flight1[i].flightNumber) {
                        k1 = i;
                        break;
                    }
                }

                if ((flight1[k1].timeDeparture - flight1[k].timeDeparture) <= 15) {
                    k = k1;
                }
            }

            if (flight1[k].timeDeparture < aircraft[m].timeDeparture) {
                FlightSchedule  *flightSchedule1 = new FlightSchedule();
                flightSchedule1->aircraft = aircraft[m].aircraftNumber;
                flightSchedule1->arrive = flight1[k].arrive;
                flightSchedule1->aircraftOld = flight1[k].aircraft;
                flightSchedule1->departure = flight1[k].departure;
                flightSchedule1->flightNumber = flight1[k].flightNumber;
                flightSchedule1->timeArrive = aircraft[m].timeDeparture + flight1[k].timeFly - groundTime;
                flightSchedule1->timeDeparture = aircraft[m].timeDeparture;
                flightSchedule1->timeDelay = aircraft[m].timeDeparture - flight1[k].timeDeparture;
                flightSchedule1->status = aircraft[m].status;
                flightSchedule.push_back(flightSchedule1);
                aircraft[m].timeDeparture = aircraft[m].timeDeparture + flight1[k].timeFly;
                aircraft[m].departure = flight1[k].arrive;

                for (int i = 0; i < flight.size(); i++) {
                    if (flight1[k].flightNumber == flight[i].flightNumber) {
                        flight[i].check = true;
                        break;
                    }
                }
            } else {
                FlightSchedule *flightSchedule1 = new FlightSchedule();
                flightSchedule1->aircraft = aircraft[m].aircraftNumber;
                flightSchedule1->status = aircraft[m].status;
                flightSchedule1->aircraftOld = flight1[k].aircraft;
                flightSchedule1->arrive = flight1[k].arrive;
                flightSchedule1->departure = flight1[k].departure;
                flightSchedule1->flightNumber = flight1[k].flightNumber;
                flightSchedule1->timeArrive = flight1[k].timeDeparture + flight1[k].timeFly - groundTime;
                flightSchedule1->timeDeparture = flight1[k].timeDeparture;
                flightSchedule1->timeDelay = 0;
                flightSchedule.push_back(flightSchedule1);
                aircraft[m].timeDeparture = flight1[k].timeDeparture + flight1[k].timeFly;
                aircraft[m].departure = flight1[k].arrive;

                for (int i = 0; i < flight.size(); i++) {
                    if (flight1[k].flightNumber == flight[i].flightNumber) {
                        flight[i].check = true;
                        break;
                    }
                }
            }
        } else {
            aircraft[m].flagInProcess = true;
        }

        // Handle problem 4
        if (inArray(aircraft[m].aircraftNumber, acProblem4) == true) {
            if (aircraft[m].departure.compare(QString("SGN")) == 0 || aircraft[m].departure.compare(QString("HAN")) == 0 || aircraft[m].departure.compare(QString("CXR")) == 0) {
                int loc;

                for (int i = 0; i < AC4.size(); i++) {
                    if (aircraft[m].aircraftNumber.compare(AC4[i].aircraftNumber) == 0) {
                        loc = i;
                        break;
                    }
                }

                if (aircraft[m].timeDeparture <= AC4[loc].time) {
                    AC4[loc].flag = flightSchedule.size() - 1;
                } else {
                    for (int i = flightSchedule.size() - 1; i > AC4[loc].flag; i--) { //tra chuyen bay chua thuc hien
                        for (int j = 0; j < flight.size(); j++) {
                            if (flightSchedule[i]->flightNumber.compare(flight[j].flightNumber) == 0) {
                                flight[j].check = false;
                                break;
                            }
                        }
                    }

                    for (int i = 0; i < aircraft.size(); i++) {
                        for (int j = AC4[loc].flag; j >= 0; j--) {
                            if (flightSchedule[j]->aircraft.compare((aircraft[i].aircraftNumber)) == 0) {
                                aircraft[i].departure = flightSchedule[j]->arrive;
                                aircraft[i].timeDeparture = flightSchedule[j]->timeArrive + groundTime;
                                break;
                            }
                        }
                    }

                    flightSchedule.erase(flightSchedule.begin() + AC4[loc].flag + 1, flightSchedule.end());
                    aircraft[m].flagInProcess = true;

                    for (int i = 0; i < AC4.size(); i++) {
                        if (AC4[i].flag > AC4[loc].flag) {
                            for (int j = 0; j < aircraft.size(); j++) {
                                if (aircraft[j].aircraftNumber.compare(AC4[i].aircraftNumber) == 0) {
                                    aircraft[j].flagInProcess = false;
                                }
                            }

                            for (int j = AC4[loc].flag; j >= 0; j--) {
                                if (flightSchedule[j]->aircraft.compare(AC4[i].aircraftNumber) == 0) {
                                    if (flightSchedule[j]->arrive.compare(QString("SGN")) == 0 || flightSchedule[j]->arrive.compare(QString("HAN")) == 0 || flightSchedule[j]->arrive.compare(QString("CXR")) == 0) {
                                        AC4[i].flag = j;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    } while (countAircraft(aircraft) > 0);

    int stimeDelay = 0;

    for (int i = 0; i < flightSchedule.size(); i++) {
        stimeDelay = stimeDelay + flightSchedule[i]->timeDelay;
    }

    flightSchedule = sortFlightSchedule(flightSchedule);
    // Crew
    QStringList ACC2;
    indexDuplicateFlight.clear();

    for (int i = 0; i < flightSchedule.size(); i++) {
        if (inArray(flightSchedule[i]->aircraft, ACC2) == false) {
            ACC2.push_back(flightSchedule[i]->aircraft);
            indexDuplicateFlight.push_back(i);
        }
    }

    indexDuplicateFlight.push_back(flightSchedule.size());

    //Sort crew
    int crSGNused = 0, crHANused = 0, crCXRused = 0;

    for (int i = 0; i < indexDuplicateFlight.size() - 1; i++) {
        int mark = indexDuplicateFlight[i];
        int mark1 = mark;

        for (int j = indexDuplicateFlight[i]; j < indexDuplicateFlight[i + 1]; j++) {
            if (flightSchedule[j]->arrive == "HAN" || flightSchedule[j]->arrive == "SGN" || flightSchedule[j]->arrive == "CXR") {
                if (((flightSchedule[j]->timeArrive - flightSchedule[mark1]->timeDeparture) <= sector) && ((j - mark1 + 1) <= dutyTime)) {
                    mark = j + 1;
                } else {
                    for (int k = mark1; k < mark; k++) {
                        if (flightSchedule[mark1]->departure == "SGN") {
                            if (P1SGN.size() != 0) {
                                flightSchedule[k]->crew1 = P1SGN[0];
                            }

                            flightSchedule[k]->crew2 = P2SGN[0];
                            flightSchedule[k]->crew3 = P3SGN[0];
                            flightSchedule[k]->crew4 = P4SGN[0];
                            flightSchedule[k]->crew5 = P5SGN[0];
                            flightSchedule[k]->crew6 = P6SGN[0];
                        } else if (flightSchedule[mark1]->departure == "HAN") {
                            flightSchedule[k]->crew1 = P1HAN[0];
                            flightSchedule[k]->crew2 = P2HAN[0];
                            flightSchedule[k]->crew3 = P3HAN[0];
                            flightSchedule[k]->crew4 = P4HAN[0];
                            flightSchedule[k]->crew5 = P5HAN[0];
                            flightSchedule[k]->crew6 = P6HAN[0];
                        } else if (flightSchedule[mark1]->departure == "CXR") {
                            flightSchedule[k]->crew1 = P1CXR[0];
                            flightSchedule[k]->crew2 = P2CXR[0];
                            flightSchedule[k]->crew3 = P3CXR[0];
                            flightSchedule[k]->crew4 = P4CXR[0];
                            flightSchedule[k]->crew5 = P5CXR[0];
                            flightSchedule[k]->crew6 = P6CXR[0];
                        }
                    }

                    if (flightSchedule[mark1]->departure == "SGN") {
                        crSGNused++;
                    } else if (flightSchedule[mark1]->departure == "HAN") {
                        crHANused++;
                    } else if (flightSchedule[mark1]->departure == "CXR") {
                        crCXRused++;
                    }

                    mark1 = mark;
                }
            }

            if (j == indexDuplicateFlight[i + 1] - 1) {
                for (int k = mark1; k < indexDuplicateFlight[i + 1]; k++) {
                    if (flightSchedule[mark1]->departure == "SGN") {
                        flightSchedule[k]->crew1 = P1SGN[0];
                        flightSchedule[k]->crew2 = P2SGN[0];
                        flightSchedule[k]->crew3 = P3SGN[0];
                        flightSchedule[k]->crew4 = P4SGN[0];
                        flightSchedule[k]->crew5 = P5SGN[0];
                        flightSchedule[k]->crew6 = P6SGN[0];
                    } else if (flightSchedule[mark1]->departure == "HAN") {
                        flightSchedule[k]->crew1 = P1HAN[0];
                        flightSchedule[k]->crew2 = P2HAN[0];
                        flightSchedule[k]->crew3 = P3HAN[0];
                        flightSchedule[k]->crew4 = P4HAN[0];
                        flightSchedule[k]->crew5 = P5HAN[0];
                        flightSchedule[k]->crew6 = P6HAN[0];
                    } else if (flightSchedule[mark1]->departure == "CXR") {
                        flightSchedule[k]->crew1 = P1CXR[0];
                        flightSchedule[k]->crew2 = P2CXR[0];
                        flightSchedule[k]->crew3 = P3CXR[0];
                        flightSchedule[k]->crew4 = P4CXR[0];
                        flightSchedule[k]->crew5 = P5CXR[0];
                        flightSchedule[k]->crew6 = P6CXR[0];
                    }
                }

                if (flightSchedule[mark1]->departure == "SGN") {
                    crSGNused++;
                } else if (flightSchedule[mark1]->departure == "HAN") {
                    crHANused++;
                } else if (flightSchedule[mark1]->departure == "CXR") {
                    crCXRused++;
                }
            }
        }
    }


    for (int i = 0; i < flightSchedule.size(); i++) {
        flightSchedule[i]->timeDeparture = ((flightSchedule[i]->timeDeparture % (24 * 60)) - (flightSchedule[i]->timeDeparture % (24 * 60)) % 60) / 60 * 100 + (flightSchedule[i]->timeDeparture % (24 * 60)) % 60;
        flightSchedule[i]->timeArrive = ((flightSchedule[i]->timeArrive % (24 * 60)) - (flightSchedule[i]->timeArrive % (24 * 60)) % 60) / 60 * 100 + (flightSchedule[i]->timeArrive % (24 * 60)) % 60;
    }

    int countChangedAircraftAndTime = 0, countChangedAircraft = 0, maxx = flightSchedule[1]->timeDelay, convert = 0, flightCancel = 0;

    for (int i = 0; i < flightSchedule.size(); i++) {
        if (flightSchedule[i]->aircraft == flightSchedule[i]->aircraftOld) {
            countChangedAircraft++;
        }

        if ((flightSchedule[i]->timeDelay == 0) && flightSchedule[i]->aircraft != flightSchedule[i]->aircraftOld) {
            countChangedAircraftAndTime++;
        }

        if (flightSchedule[i]->timeDelay > maxx) {
            maxx = flightSchedule[i]->timeDelay;
        }

        if (flightSchedule[i]->timeDelay > 0) {
            convert++;
        }
    }

    for (int i = 0; i < flight.size(); i++) {
        if (flight[i].check == true) {
            flightCancel++;
        }
    }

    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/flight_reschedule.csv");

    // Write file output
    writeFlightSchedule(path, flightSchedule);

    // Write file log
    path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QString("/data/reschedule_log_%1.txt").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH_mm_ss"));

    QFile logFile(path);

    if (logFile.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        QTextStream out(&logFile);

        out << "             OPTIMAL AIRLINE SCHEDULE          " << endl;
        out << "*****************__FLIGHT__*********************" << endl;
        out << "Number of unchanged (aircraft and time) flights is " << countChangedAircraftAndTime << endl;
        out << "Number of unchanged (only aircraft) flights is " << countChangedAircraft << endl;
        out << "Number of canceled flights is " << flightCancel << endl;
        out << "Total delayed time is " << stimeDelay << endl;
        out << "Number of delayed flights is " << convert << endl;
        out << "Maximum of delayed time is " << maxx << endl;

        out << "*****************__CREW__*********************" << endl;
        out << "- Crew1 -" << endl;
        out << "Available crew 1: " << endl;
        out << "SGN: " << cP1SGN << endl;
        out << "HAN: " << cP1HAN << endl;
        out << "CXR: " << cP1CXR << endl;
        out << "Used crew 1:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl;

        out << "--Crew2--" << endl;
        out << "Available crew 2:" << endl;
        out << "SGN: " << cP2SGN << endl;
        out << "HAN: " << cP2HAN << endl;
        out << "CXR: " << cP2CXR << endl;
        out << "Used crew 2:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl;

        out << "Available crew 3:" << endl;
        out << "SGN: " << cP3SGN << endl;
        out << "HAN: " << cP3HAN << endl;
        out << "CXR: " << cP3CXR << endl;
        out << "Used crew 3:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl;

        out << "Available crew 4:" << endl;
        out << "SGN: " << cP4SGN << endl;
        out << "HAN: " << cP4HAN << endl;
        out << "CXR: " << cP4CXR << endl;
        out << "Used crew 4:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl;

        out << "Available crew 5:" << endl;
        out << "SGN: " << cP5SGN << endl;
        out << "HAN: " << cP5HAN << endl;
        out << "CXR: " << cP5CXR << endl;
        out << "Used crew 5:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl;

        out << "Available crew 6:" << endl;
        out << "SGN: " << cP6SGN << endl;
        out << "HAN: " << cP6HAN << endl;
        out << "CXR: " << cP6CXR << endl;
        out << "Used crew 6:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl;

    } else {
        emit error(tr("Unable open file!"));
    }
}

int RescheduleCalculation::nameToIndex(QList<Aircraft> array, QString name)
{
    for (int i = 0; i < array.length(); i++) {
        if (array[i].aircraftNumber == name) {
            return i;
        }
    }
    return -1;
}

