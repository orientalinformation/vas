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

#include <QDateTime>

#include "version.h"

RescheduleCalculation::RescheduleCalculation(QObject *parent) :
    QObject(parent)
{
}

int RescheduleCalculation::countAircraft(QList<Aircraft> aircraft) {
    int count = 0;

    for (int i = 0; i < aircraft.size(); i++) {
        if (aircraft[i].flagInProcess == false) {
            count++;
        }
    }

    return count;
}

QList <Flight> RescheduleCalculation::sortFlightIncrease(QList<Flight> flight) {
    for (int i = 0; i < (flight.size() - 1); i++) {
         for (int j = i + 1; j < flight.size(); j++) {
             if (flight[i].timeDeparture > flight[j].timeDeparture) {
                 qSwap(flight[i], flight[j]);
             }
         }
     }

     return flight;
}

bool RescheduleCalculation::isArrayContains(const QString value, QStringList array)
{
    return array.contains(value, Qt::CaseInsensitive);
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

QList<FlightSchedule *> RescheduleCalculation::sortFlightSchedule(QList <FlightSchedule *> flightSchedule)
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
            out << flightSchedule.at(i)->flightNumber.toUpper() << "," << flightSchedule.at(i)->crew1 << "," << flightSchedule.at(i)->crew2 << "," << flightSchedule.at(i)->crew3
                << "," << flightSchedule.at(i)->crew4 << "," << flightSchedule.at(i)->crew5 << "," << flightSchedule.at(i)->crew6 << "," << flightSchedule.at(i)->departure
                << "," << flightSchedule.at(i)->arrive <<  "," << flightSchedule.at(i)->timeDeparture << "," << flightSchedule.at(i)->timeArrive
                << "," << flightSchedule.at(i)->aircraft << "," << flightSchedule.at(i)->aircraftOld << "," << flightSchedule.at(i)->status << endl;
        }

        file.close();
    } else {
        emit error(tr("Can not write result file!"));
    }
}

void RescheduleCalculation::execute(QStringList problem1, QList<QObject *> problem2, QStringList problem3, QStringList airports, QList<QObject *> problem4,
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

    QList <Problem *> localProblem2;
    QList <Problem *> localProblem4;

    QList<int> indexUniqueFlight;

    numberOfFlight = flightObject.length();

    // Filter get information of flight
    QStringList uniqueAircrafts;

    for (int i = 0; i < numberOfFlight; i++) {
        QString name = static_cast<FlightObject *>(flightObject.at(i))->newAircraft();

        if (isArrayContains(name, uniqueAircrafts) == false) {
            indexUniqueFlight.push_back(i);
            uniqueAircrafts.append(name);
        }
    }

    indexUniqueFlight.push_back(numberOfFlight);

    //Get info of crew
    // Crew1
    QStringList crew;

    for (int j = 0; j < numberOfFlight; j++) {
        QString captain = static_cast<FlightObject *>(flightObject.at(j))->captain();

        if (isArrayContains(captain, crew) == false) {
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

        if (isArrayContains(coPilot, crew) == false) {
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

        if (isArrayContains(cabinManager, crew) == false) {
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

        if (isArrayContains(cabinAgent, crew) == false) {
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

        if (isArrayContains(cabinAgent, crew) == false) {
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

        if (isArrayContains(cabinAgent, crew) == false) {
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

    // add data aircraft
    for (int i = 0; i < indexUniqueFlight.size() - 1; i++) {
        Aircraft aircraft1;
        aircraft1.aircraftNumber = static_cast<FlightObject *>(flightObject.at(indexUniqueFlight[i]))->newAircraft();
        aircraft1.timeDeparture = static_cast<FlightObject *>(flightObject.at(indexUniqueFlight[i]))->timeDeparture();
        aircraft1.flagInProcess = false;
        aircraft1.departure = static_cast<FlightObject *>(flightObject.at(indexUniqueFlight[i]))->departure();
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
        int maximumTime = INT_MIN;
        int indexMaximum = 0;
        int tg = 0;

        int idx = getIndexInArrayByName(uniqueAircrafts, problem1.at(i));

        for (int j = 0; j < aircraft.size(); j++) {
            if (idx != -1 && aircraft[idx].departure == aircraft[j].departure) {
                if (aircraft[j].timeDeparture > maximumTime) {
                    maximumTime = aircraft[j].timeDeparture;
                    indexMaximum = j;
                }
            }
        }

        tg = aircraft[idx].timeDeparture;
        aircraft[idx].timeDeparture = aircraft[indexMaximum].timeDeparture;
        aircraft[indexMaximum].timeDeparture = tg;
    }

    // write information flight crash
    for (int i = 0; i < problem1.size(); i++) {
        int idx = getIndexInArrayByName(uniqueAircrafts, problem1.at(i));

        if (idx != -1) {
            aircraft[idx].flagInProcess = true;
        }
    }

    Problem *value = new Problem;

    for (int i = 0; i < problem2.size(); i++) {

        value->setTime(problem2.at(i)->property("time").toInt() / 100 * 60 + problem2.at(i)->property("time").toInt() % 100);
        value->setName(problem2.at(i)->property("name").toString());

        localProblem2.append(value);

        int idx = getIndexInArrayByName(uniqueAircrafts, localProblem2.at(i)->name());

        if (idx != -1) {
            aircraft[idx].timeDeparture = localProblem2.at(i)->time();
        }
    }

    QStringList acProblem3;

    for (int i = 0; i < problem3.size(); i++) {
        int idx = getIndexInArrayByName(uniqueAircrafts, problem3.at(i));

        if (idx != -1) {
            acProblem3.push_back(aircraft[idx].aircraftNumber);
        }
    }

    QStringList acProblem4;
    QList<Problem4> AC4;

    for (int i = 0; i < problem4.size(); i++) {
        value->setTime(problem4.at(i)->property("time").toInt() / 100 * 60 + problem4.at(i)->property("time").toInt() % 100);
        value->setName(problem4.at(i)->property("name").toString());

        localProblem4.append(value);

        int idx = getIndexInArrayByName(uniqueAircrafts, localProblem4.at(i)->name());

        if (idx != -1) {
            acProblem4.push_back(aircraft[idx].aircraftNumber);

            Problem4 ac4;

            ac4.aircraftNumber = aircraft[idx].aircraftNumber;
            ac4.flag = 0;
            ac4.time = localProblem4.at(i)->time();
            AC4.push_back(ac4);
        }
    }

    delete value;

    QList <Aircraft> aircraft1 = aircraft;
    QStringList acProblem41;

    // Processing
    do {
        int minimumTime = INT_MAX;
        int indexMinimum = 0;

        for (int i = 0; i < aircraft.size(); i++) {
            if ((aircraft[i].timeDeparture < minimumTime) && !aircraft[i].flagInProcess) {
                minimumTime = aircraft[i].timeDeparture;
                indexMinimum = i;
            }
        }

        // Find a flight fit
        QList<Flight> flight1;

        if (isArrayContains(aircraft[indexMinimum].aircraftNumber, acProblem3)) {
            for (int i = 0; i < flight.size(); i++) {
                if (flight[i].departure == aircraft[indexMinimum].departure && !flight[i].check) {
                    if (isArrayContains(flight[i].arrive, airports)) {
                        flight1.push_back(flight[i]);
                    }
                }
            }
        } else {
            for (int i = 0; i < flight.size(); i++) {
                if (flight[i].departure == aircraft[indexMinimum].departure && !flight[i].check) {
                    flight1.push_back(flight[i]);
                }
            }
        }

        if (flight1.size() > 0) {
            QList<Flight> flight2;
            flight1 = sortFlightIncrease(flight1);

            for (int i = 0; i < flight1.size(); i++) {
                if (flight1[i].aircraft == aircraft[indexMinimum].aircraftNumber) {
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

            if (flight1[k].timeDeparture < aircraft[indexMinimum].timeDeparture) {
                n = n + 1;

                FlightSchedule  *flightSchedule1 = new FlightSchedule();
                flightSchedule1->aircraft = aircraft[indexMinimum].aircraftNumber;
                flightSchedule1->aircraftOld = flight1[k].aircraft;
                flightSchedule1->arrive = flight1[k].arrive;
                flightSchedule1->departure = flight1[k].departure;
                flightSchedule1->flightNumber = flight1[k].flightNumber;
                flightSchedule1->timeArrive = aircraft[indexMinimum].timeDeparture + flight1[k].timeFly - groundTime;
                flightSchedule1->timeDeparture = aircraft[indexMinimum].timeDeparture;
                flightSchedule1->timeDelay = aircraft[indexMinimum].timeDeparture - flight1[k].timeDeparture;
                flightSchedule.push_back(flightSchedule1);

                aircraft[indexMinimum].timeDeparture = aircraft[indexMinimum].timeDeparture + flight1[k].timeFly;
                aircraft[indexMinimum].departure = flight1[k].arrive;

                for (int i = 0; i < flight.size(); i++) {
                    if (flight1[k].flightNumber == flight[i].flightNumber) {
                        flight[i].check = true;
                        break;
                    }
                }
            } else {
                n = n + 1;

                FlightSchedule *flightSchedule1 = new FlightSchedule();
                flightSchedule1->aircraft = aircraft[indexMinimum].aircraftNumber;
                flightSchedule1->aircraftOld = flight1[k].aircraft;
                flightSchedule1->arrive = flight1[k].arrive;
                flightSchedule1->departure = flight1[k].departure;
                flightSchedule1->flightNumber = flight1[k].flightNumber;
                flightSchedule1->timeArrive = flight1[k].timeDeparture + flight1[k].timeFly - groundTime;
                flightSchedule1->timeDeparture = flight1[k].timeDeparture;
                flightSchedule1->timeDelay = 0;
                flightSchedule.push_back(flightSchedule1);

                aircraft[indexMinimum].timeDeparture = flight1[k].timeDeparture + flight1[k].timeFly;
                aircraft[indexMinimum].departure = flight1[k].arrive;

                for (int i = 0; i < flight.size(); i++) {
                    if (flight1[k].flightNumber == flight[i].flightNumber) {
                        flight[i].check = true;
                        break;
                    }
                }
            }
        } else {
            aircraft[indexMinimum].flagInProcess = true;
        }

        // Handle problem 4
        if (isArrayContains(aircraft[indexMinimum].aircraftNumber, acProblem4) == true) {
            int loc;
            for (int i = 0; i < AC4.size(); i++) {
                if (aircraft[indexMinimum].aircraftNumber == AC4[i].aircraftNumber) {
                    loc = i;
                    break;
                }
            }

            if ((aircraft[indexMinimum].timeDeparture - groundTime) <= AC4[loc].time) {
                if (aircraft[indexMinimum].departure == "SGN" || aircraft[indexMinimum].departure == "HAN") {
                    AC4[loc].flag = n;
                }
            } else {
                for (int i = n - 1; i >= AC4[loc].flag; i--) { //test flights not fly
                    for (int j = 0; j < flight.size(); j++) {
                        if (flightSchedule[i]->flightNumber == flight[j].flightNumber) {
                            flight[j].check = false;
                            break;
                        }
                    }
                    flightSchedule.removeAt(i);
                    n = i - 1;
                }

                aircraft = aircraft1;

                for (int i = 0; i < aircraft.size(); i++) {
                    for (int j = AC4[loc].flag - 1; j >= 0; j--) {
                        if (flightSchedule[j]->aircraft == aircraft[i].aircraftNumber) {
                            aircraft[i].departure = flightSchedule[j]->arrive;
                            aircraft[i].timeDeparture = flightSchedule[j]->timeArrive + groundTime;
                            break;
                        }
                    }
                }

                acProblem41.append(aircraft[indexMinimum].aircraftNumber);

                for (int i = 0; i < AC4.size(); i++) {
                    if (AC4[i].flag > AC4[loc].flag) {
                        for (int j = 0; j < acProblem41.size(); j++) {
                            if (acProblem4[i] == acProblem41[j]) {
                                acProblem41.removeAt(j);
                            }
                        }
                    }
                }

                for (int i = 0; i < acProblem41.size(); i++) {
                    for (int j = 0; j < aircraft.size(); j++) {
                        if (acProblem41.at(i) == aircraft.at(j).aircraftNumber) {
                            aircraft[j].flagInProcess = true;
                        }
                    }
                }
            }
        }
        // End problem 4
    } while (countAircraft(aircraft) > 0);

    int stimeDelay = 0;

    for (int i = 0; i < flightSchedule.size(); i++) {
        stimeDelay = stimeDelay + flightSchedule[i]->timeDelay;
    }

    flightSchedule = sortFlightSchedule(flightSchedule);
    // Crew
    QStringList ACC2;
    indexUniqueFlight.clear();

    for (int i = 0; i < flightSchedule.size(); i++) {
        if (isArrayContains(flightSchedule[i]->aircraft, ACC2) == false) {
            ACC2.push_back(flightSchedule[i]->aircraft);
            indexUniqueFlight.push_back(i);
        }
    }

    indexUniqueFlight.push_back(flightSchedule.size());

    // add some crew
    for (int i = 0; i < 50; i++) {
        P1SGN.push_back("0");
        P1HAN.push_back("0");
        P1CXR.push_back("0");

        P2SGN.push_back("0");
        P2HAN.push_back("0");
        P2CXR.push_back("0");

        P3SGN.push_back("0");
        P3HAN.push_back("0");
        P3CXR.push_back("0");

        P4SGN.push_back("0");
        P4HAN.push_back("0");
        P4CXR.push_back("0");

        P5SGN.push_back("0");
        P5HAN.push_back("0");
        P5CXR.push_back("0");

        P6SGN.push_back("0");
        P6HAN.push_back("0");
        P6CXR.push_back("0");
    }
    //Sort crew
    int crSGNused = 0, crHANused = 0, crCXRused = 0;

    for (int i = 0; i < indexUniqueFlight.size() - 1; i++) {
        int mark = indexUniqueFlight[i];
        int mark1 = mark;

        for (int j = indexUniqueFlight[i]; j < indexUniqueFlight[i + 1]; j++) {
            if (flightSchedule[j]->arrive == "HAN" || flightSchedule[j]->arrive == "SGN" || flightSchedule[j]->arrive == "CXR") {
                if (((flightSchedule[j]->timeArrive - flightSchedule[mark1]->timeDeparture) <= dutyTime) && ((j - mark1 + 1) <= sector)) {
                    mark = j + 1;
                } else {
                    for (int k = mark1; k < mark; k++) {
                        if (flightSchedule[mark1]->departure == "SGN" && !P1SGN.isEmpty() && !P2SGN.isEmpty() && !P3SGN.isEmpty()
                                && !P4SGN.isEmpty() && !P5SGN.isEmpty() && !P6SGN.isEmpty()) {
                            if (P1SGN.size() != 0) {
                                flightSchedule[k]->crew1 = P1SGN[0];
                            }

                            flightSchedule[k]->crew2 = P2SGN[0];
                            flightSchedule[k]->crew3 = P3SGN[0];
                            flightSchedule[k]->crew4 = P4SGN[0];
                            flightSchedule[k]->crew5 = P5SGN[0];
                            flightSchedule[k]->crew6 = P6SGN[0];
                        } else if (flightSchedule[mark1]->departure == "HAN" && !P1HAN.isEmpty() && !P2HAN.isEmpty() && !P3HAN.isEmpty()
                                   && !P4HAN.isEmpty() && !P5HAN.isEmpty() && !P6HAN.isEmpty()) {
                            flightSchedule[k]->crew1 = P1HAN[0];
                            flightSchedule[k]->crew2 = P2HAN[0];
                            flightSchedule[k]->crew3 = P3HAN[0];
                            flightSchedule[k]->crew4 = P4HAN[0];
                            flightSchedule[k]->crew5 = P5HAN[0];
                            flightSchedule[k]->crew6 = P6HAN[0];
                        } else if (flightSchedule[mark1]->departure == "CXR" && !P1CXR.isEmpty() && !P2CXR.isEmpty() && !P3CXR.isEmpty()
                                   && !P4CXR.isEmpty() && !P5CXR.isEmpty() && !P6CXR.isEmpty()) {
                            flightSchedule[k]->crew1 = P1CXR[0];
                            flightSchedule[k]->crew2 = P2CXR[0];
                            flightSchedule[k]->crew3 = P3CXR[0];
                            flightSchedule[k]->crew4 = P4CXR[0];
                            flightSchedule[k]->crew5 = P5CXR[0];
                            flightSchedule[k]->crew6 = P6CXR[0];
                        }
                    }

                    if (flightSchedule[mark1]->departure == "SGN" && !P1SGN.isEmpty() && !P2SGN.isEmpty() && !P3SGN.isEmpty()
                                 && !P4SGN.isEmpty() && !P5SGN.isEmpty() && !P6SGN.isEmpty()) {
                        crSGNused++;
                        P1SGN.pop_front();
                        P2SGN.pop_front();
                        P3SGN.pop_front();
                        P4SGN.pop_front();
                        P5SGN.pop_front();
                        P6SGN.pop_front();
                    } else if (flightSchedule[mark1]->departure == "HAN" && !P1HAN.isEmpty() && !P2HAN.isEmpty() && !P3HAN.isEmpty()
                               && !P4HAN.isEmpty() && !P5HAN.isEmpty() && !P6HAN.isEmpty()) {
                        crHANused++;
                        P1HAN.pop_front();
                        P2HAN.pop_front();
                        P3HAN.pop_front();
                        P4HAN.pop_front();
                        P5HAN.pop_front();
                        P6HAN.pop_front();
                    } else if (flightSchedule[mark1]->departure == "CXR" && !P1CXR.isEmpty() && !P2CXR.isEmpty() && !P3CXR.isEmpty()
                               && !P4CXR.isEmpty() && !P5CXR.isEmpty() && !P6CXR.isEmpty()) {
                        crCXRused++;
                        P1CXR.pop_front();
                        P2CXR.pop_front();
                        P3CXR.pop_front();
                        P4CXR.pop_front();
                        P5CXR.pop_front();
                        P6CXR.pop_front();
                    }

                    mark1 = mark;
                }
            }

            if (j == indexUniqueFlight[i + 1] - 1) {
                for (int k = mark1; k < indexUniqueFlight[i + 1]; k++) {
                    if (flightSchedule[mark1]->departure == "SGN" && !P1SGN.isEmpty() && !P2SGN.isEmpty() && !P3SGN.isEmpty()
                            && !P4SGN.isEmpty() && !P5SGN.isEmpty() && !P6SGN.isEmpty()) {
                        flightSchedule[k]->crew1 = P1SGN[0];
                        flightSchedule[k]->crew2 = P2SGN[0];
                        flightSchedule[k]->crew3 = P3SGN[0];
                        flightSchedule[k]->crew4 = P4SGN[0];
                        flightSchedule[k]->crew5 = P5SGN[0];
                        flightSchedule[k]->crew6 = P6SGN[0];
                    } else if (flightSchedule[mark1]->departure == "HAN" && !P1HAN.isEmpty() && !P2HAN.isEmpty() && !P3HAN.isEmpty()
                               && !P4HAN.isEmpty() && !P5HAN.isEmpty() && !P6HAN.isEmpty()) {
                        flightSchedule[k]->crew1 = P1HAN[0];
                        flightSchedule[k]->crew2 = P2HAN[0];
                        flightSchedule[k]->crew3 = P3HAN[0];
                        flightSchedule[k]->crew4 = P4HAN[0];
                        flightSchedule[k]->crew5 = P5HAN[0];
                        flightSchedule[k]->crew6 = P6HAN[0];
                    } else if (flightSchedule[mark1]->departure == "CXR" && !P1CXR.isEmpty() && !P2CXR.isEmpty() && !P3CXR.isEmpty()
                               && !P4CXR.isEmpty() && !P5CXR.isEmpty() && !P6CXR.isEmpty()) {
                        flightSchedule[k]->crew1 = P1CXR[0];
                        flightSchedule[k]->crew2 = P2CXR[0];
                        flightSchedule[k]->crew3 = P3CXR[0];
                        flightSchedule[k]->crew4 = P4CXR[0];
                        flightSchedule[k]->crew5 = P5CXR[0];
                        flightSchedule[k]->crew6 = P6CXR[0];
                    }
                }

                if (flightSchedule[mark1]->departure == "SGN" && !P1SGN.isEmpty() && !P2SGN.isEmpty() && !P3SGN.isEmpty()
                             && !P4SGN.isEmpty() && !P5SGN.isEmpty() && !P6SGN.isEmpty()) {
                    crSGNused++;
                    P1SGN.pop_front();
                    P2SGN.pop_front();
                    P3SGN.pop_front();
                    P4SGN.pop_front();
                    P5SGN.pop_front();
                    P6SGN.pop_front();
                } else if (flightSchedule[mark1]->departure == "HAN" && !P1HAN.isEmpty() && !P2HAN.isEmpty() && !P3HAN.isEmpty()
                           && !P4HAN.isEmpty() && !P5HAN.isEmpty() && !P6HAN.isEmpty()) {
                    crHANused++;
                    P1HAN.pop_front();
                    P2HAN.pop_front();
                    P3HAN.pop_front();
                    P4HAN.pop_front();
                    P5HAN.pop_front();
                    P6HAN.pop_front();
                } else if (flightSchedule[mark1]->departure == "CXR" && !P1CXR.isEmpty() && !P2CXR.isEmpty() && !P3CXR.isEmpty()
                           && !P4CXR.isEmpty() && !P5CXR.isEmpty() && !P6CXR.isEmpty()) {
                    crCXRused++;
                    P1CXR.pop_front();
                    P2CXR.pop_front();
                    P3CXR.pop_front();
                    P4CXR.pop_front();
                    P5CXR.pop_front();
                    P6CXR.pop_front();
                }

            }
        }
    }


    for (int i = 0; i < flightSchedule.size(); i++) {
        flightSchedule[i]->timeDeparture = ((flightSchedule[i]->timeDeparture % (24 * 60)) - (flightSchedule[i]->timeDeparture % (24 * 60)) % 60) / 60 * 100 + (flightSchedule[i]->timeDeparture % (24 * 60)) % 60;
        flightSchedule[i]->timeArrive = ((flightSchedule[i]->timeArrive % (24 * 60)) - (flightSchedule[i]->timeArrive % (24 * 60)) % 60) / 60 * 100 + (flightSchedule[i]->timeArrive % (24 * 60)) % 60;
    }

    int countUnchangedAircraftAndTime = 0;
    int countUnchangedAircraft = 0;
    int maxx = flightSchedule[0]->timeDelay;
    int convert = 0, flightCancel = 0;

    for (int i = 0; i < flightSchedule.size(); i++) {
        if (flightSchedule[i]->aircraft == flightSchedule[i]->aircraftOld) {
            countUnchangedAircraft++;
        }

        if ((flightSchedule[i]->timeDelay == 0) && flightSchedule[i]->aircraft == flightSchedule[i]->aircraftOld) {
            countUnchangedAircraftAndTime++;
        }

        if (flightSchedule[i]->timeDelay > maxx) {
            maxx = flightSchedule[i]->timeDelay;
        }

        if (flightSchedule[i]->timeDelay > 0) {
            convert++;
        }
    }

    for (int i = 0; i < flight.size(); i++) {
        if (!flight[i].check) {
            flightCancel++;
        }
    }

    // Write status
    for (int i = 0; i < flightSchedule.size(); i++) {
        QString flightNameOut = flightSchedule[i]->flightNumber;
        QString aircraftNameOut = flightSchedule[i]->aircraft;
        int timeDepartureOut = flightSchedule[i]->timeDeparture;
        int timeArrivalOut = flightSchedule[i]->timeArrive;

        for (int j = 0; j < flightObject.size(); j++) {
            if (flightNameOut == static_cast<FlightObject *>(flightObject.at(j))->name()) {
                QString aircraftNameIn = static_cast<FlightObject *>(flightObject.at(j))->newAircraft();
                int timeDepartureIn = static_cast<FlightObject *>(flightObject.at(j))->timeDeparture();
                int timeArrivalIn = static_cast<FlightObject *>(flightObject.at(j))->timeArrival();

                timeDepartureIn = ((timeDepartureIn % (24 * 60)) - (timeDepartureIn % (24 * 60)) % 60) / 60 * 100 + (timeDepartureIn % (24 * 60)) % 60;
                timeArrivalIn = ((timeArrivalIn % (24 * 60)) - (timeArrivalIn % (24 * 60)) % 60) / 60 * 100 + (timeArrivalIn % (24 * 60)) % 60;

                if (aircraftNameIn != aircraftNameOut && (timeArrivalIn != timeArrivalOut || timeDepartureIn != timeDepartureOut)) {
                    flightSchedule[i]->status = 3;
                    break;
                } else if (aircraftNameIn != aircraftNameOut) {
                    flightSchedule[i]->status = 1;
                    break;
                } else if (timeArrivalIn != timeArrivalOut || timeDepartureIn != timeDepartureOut) {
                    flightSchedule[i]->status = 2;
                    break;
                } else {
                    flightSchedule[i]->status = 0;
                }
            }
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

        out << "\"VAS Calculation Logging File\"" << endl << endl;

        out << "\"VAS version " << QString(APP_VERSION_SHORT) << "\"" << endl;
        out << "\"File created by VAS " << QDateTime::currentDateTime().toString("ddd MMM dd HH:mm:ss yyyy") << "\"" << endl << endl;

        out << "             OPTIMAL AIRLINE SCHEDULE          " << endl;
        out << "*****************__FLIGHT__*********************" << endl;
        out << "Number of unchanged (aircraft and time) flights is " << countUnchangedAircraftAndTime << endl;
        out << "Number of unchanged (only aircraft) flights is " << countUnchangedAircraft << endl;
        out << "Number of canceled flights is " << flightCancel << endl;
        out << "Total delayed time is " << stimeDelay << endl;
        out << "Number of delayed flights is " << convert << endl;
        out << "Maximum of delayed time is " << maxx << endl << endl;

        out << "*****************__CREW__*********************" << endl;
        out << "- Crew1 -" << endl;
        out << "Available crew 1: " << endl;
        out << "SGN: " << cP1SGN << endl;
        out << "HAN: " << cP1HAN << endl;
        out << "CXR: " << cP1CXR << endl;
        out << "Used crew 1:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl << endl;

        out << "--Crew2--" << endl;
        out << "Available crew 2:" << endl;
        out << "SGN: " << cP2SGN << endl;
        out << "HAN: " << cP2HAN << endl;
        out << "CXR: " << cP2CXR << endl;
        out << "Used crew 2:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl << endl;

        out << "Available crew 3:" << endl;
        out << "SGN: " << cP3SGN << endl;
        out << "HAN: " << cP3HAN << endl;
        out << "CXR: " << cP3CXR << endl;
        out << "Used crew 3:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl << endl;

        out << "Available crew 4:" << endl;
        out << "SGN: " << cP4SGN << endl;
        out << "HAN: " << cP4HAN << endl;
        out << "CXR: " << cP4CXR << endl;
        out << "Used crew 4:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl << endl;

        out << "Available crew 5:" << endl;
        out << "SGN: " << cP5SGN << endl;
        out << "HAN: " << cP5HAN << endl;
        out << "CXR: " << cP5CXR << endl;
        out << "Used crew 5:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl << endl;

        out << "Available crew 6:" << endl;
        out << "SGN: " << cP6SGN << endl;
        out << "HAN: " << cP6HAN << endl;
        out << "CXR: " << cP6CXR << endl;
        out << "Used crew 6:" << endl;
        out << "SGN: " << crSGNused << endl;
        out << "HAN: " << crHANused << endl;
        out << "CXR: " << crCXRused << endl;

        logFile.close();
    }

    emit successfull(countUnchangedAircraftAndTime, countUnchangedAircraft, flightCancel, stimeDelay, convert, maxx);
}

int RescheduleCalculation::getIndexInArrayByName(QList<Aircraft> array, QString name)
{
    for (int i = 0; i < array.length(); i++) {
        if (array[i].aircraftNumber == name) {
            return i;
        }
    }

    return -1;
}

int RescheduleCalculation::getIndexInArrayByName(QStringList array, QString name)
{
    return array.indexOf(name);
}
