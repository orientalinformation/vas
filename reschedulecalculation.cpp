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

QList <Flight> RescheduleCalculation::sortF(QList<Flight> flight) {
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

bool RescheduleCalculation::inArray(const QString value, QList <QString> array)
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

QList<FlightSchedule *> RescheduleCalculation::sortFS(QList <FlightSchedule *> FS)
{
    int sizeFS = FS.size();
     for (int i = 0; i < sizeFS - 1; i++) {
         for (int j = 0; j < sizeFS; j++) {
            if (sortByTimeDeparture(FS.at(i), FS.at(j))) {
                qSwap(FS[i], FS[j]);
            }
         }
     }

    return FS;
}

void RescheduleCalculation::runReschedule(QList <QString> br1,
       QList<QObject *> br2, QList<QString> br3, QList<QString> AP, QList<QObject *> br4,
       int GT, int TL, int TrL, QList <QObject *> data, QString outputPath)
{
    QList <FlightSchedule *> FS;
    QList <Aircraft> aircraft;
    QList <Flight> F;

    QList <QString> P1SGN;
    QList <QString> P1HAN;
    QList <QString> P1CXR;
    QList <QString> P2SGN;
    QList <QString> P2HAN;
    QList <QString> P2CXR;
    QList <QString> P3SGN;
    QList <QString> P3HAN;
    QList <QString> P3CXR;
    QList <QString> P4SGN;
    QList <QString> P4HAN;
    QList <QString> P4CXR;
    QList <QString> P5SGN;
    QList <QString> P5HAN;
    QList <QString> P5CXR;
    QList <QString> P6SGN;
    QList <QString> P6HAN;
    QList <QString> P6CXR;

    int cP1SGN = 0, cP2SGN = 0, cP3SGN = 0, cP4SGN = 0, cP5SGN = 0, cP6SGN = 0; //so luong crew tu SGN
    int cP1HAN = 0, cP2HAN = 0, cP3HAN = 0, cP4HAN = 0, cP5HAN = 0, cP6HAN = 0; //so luong crew tu SGN
    int cP1CXR = 0, cP2CXR = 0, cP3CXR = 0, cP4CXR = 0, cP5CXR = 0, cP6CXR = 0; //so luong crew tu CXR
    int numberOfFlight = 0, n = 0;

    QList<int> indexDuplicateFlight;

    numberOfFlight = data.length();

    for (int i = 0; i < numberOfFlight; i++) {
        int timeDep, timeArr;
        timeDep = static_cast<FlightObject *>(data.at(i))->timeDeparture();
        timeArr = static_cast<FlightObject *>(data.at(i))->timeArrival();
        timeDep = timeDep / 100 * 60 + timeDep % 100;
        timeArr = (timeArr - timeArr % 100) / 100 * 60 + timeArr % 100;
        static_cast<FlightObject *>(data.at(i))->setTimeDeparture(timeDep);
        static_cast<FlightObject *>(data.at(i))->setTimeArrival(timeArr);
    }

    QList <QString> ACC;

    for (int i = 0; i < numberOfFlight; i++) {
        QString kt = static_cast<FlightObject *>(data.at(i))->newAircraft();

        if (inArray(kt, ACC) == false) {
            indexDuplicateFlight.push_back(i);
            ACC.append(kt);
            n++;
        }
    }

    indexDuplicateFlight.push_back(numberOfFlight);

    for (int j = 0; j < (indexDuplicateFlight.size() - 1); j++) {
        for (int i = indexDuplicateFlight[j]; i <= indexDuplicateFlight[j + 1] - 2; i++) {
            if (static_cast<FlightObject *>(data.at(i))->timeDeparture() > static_cast<FlightObject *>(data.at(i + 1))->timeDeparture()) {
                if (i < ((indexDuplicateFlight[j + 1] + indexDuplicateFlight[j] - 1) / 2)) {
                    for (int k = indexDuplicateFlight[j]; k <= i; k++) {
                        static_cast<FlightObject *>(data.at(k))->setTimeDeparture((static_cast<FlightObject *>(data.at(k))->timeDeparture() - 24 * 60));
                    }
                } else {
                    for (int k = i + 1; k <= indexDuplicateFlight[j + 1] - 1; k++) {
                        static_cast<FlightObject *>(data.at(k))->setTimeDeparture((static_cast<FlightObject *>(data.at(k))->timeDeparture() + 24 * 60));
                    }
                }
            }
        }
    }


    // Crew1
    QList<QString> crew;

    for (int j = 0; j < numberOfFlight; j++) {
        QString s = static_cast<FlightObject *>(data.at(j))->captain();

        if (inArray(s, crew) == false) {
            QString s1 = static_cast<FlightObject *>(data.at(j))->departure();

            if (s1 == "SGN") {
                P1SGN.push_back(s);
                cP1SGN++;
            } else if (s1 == "HAN") {
                P1HAN.push_back(s);
                cP1HAN++;
            } else if (s1 == "CXR") {
                P1CXR.push_back(s);
                cP1CXR++;
            }

            crew.push_back(s);
        }
    }

    crew.clear();

    //crew2
    for (int j = 0; j < numberOfFlight; j++) {
        QString s = static_cast<FlightObject *>(data.at(j))->coPilot();

        if (inArray(s, crew) == false) {
            QString s1 = static_cast<FlightObject *>(data.at(j))->departure();

            if (s1 == "SGN") {
                P2SGN.push_back(s);
                cP2SGN++;
            } else if (s1 == "HAN") {
                P2HAN.push_back(s);
                cP2HAN++;
            } else if (s1 == "CXR") {
                P2CXR.push_back(s);
                cP2CXR++;
            }

            crew.push_back(s);
        }
    }

    crew.clear();

    // Crew3
    for (int j = 0; j < numberOfFlight; j++) {
        QString s = static_cast<FlightObject *>(data.at(j))->cabinManager();

        if (inArray(s, crew) == false) {
            QString s1 = static_cast<FlightObject *>(data.at(j))->departure();

            if (s1 == "SGN") {
                P3SGN.push_back(s);
                cP3SGN++;
            } else if (s1 == "HAN") {
                P3HAN.push_back(s);
                cP3HAN++;
            } else if (s1 == "CXR") {
                P3CXR.push_back(s);
                cP3CXR++;
            }

            crew.push_back(s);
        }
    }

    crew.clear();

    // Crew4
    for (int j = 0; j < numberOfFlight; j++) {
        QString s = static_cast<FlightObject *>(data.at(j))->cabinAgent1();

        if (inArray(s, crew) == false) {
            QString s1 = static_cast<FlightObject *>(data.at(j))->departure();

            if (s1 == "SGN") {
                P4SGN.push_back(s);
                cP4SGN++;
            } else if (s1 == "HAN") {
                P4HAN.push_back(s);
                cP4HAN++;
            } else if (s1 == "CXR") {
                P4CXR.push_back(s);
                cP4CXR++;
            }

            crew.push_back(s);
        }
    }

    crew.clear();

    // Crew5
    for (int j = 0; j < numberOfFlight; j++) {
        QString s = static_cast<FlightObject *>(data.at(j))->cabinAgent2();

        if (inArray(s, crew) == false) {
            QString s1 = static_cast<FlightObject *>(data.at(j))->departure();

            if (s1 == "SGN") {
                P5SGN.push_back(s);
                cP5SGN++;
            } else if (s1 == "HAN") {
                P5HAN.push_back(s);
                cP5HAN++;
            } else if (s1 == "CXR") {
                P5CXR.push_back(s);
                cP5CXR++;
            }

            crew.push_back(s);
        }
    }

    crew.clear();

    // Crew6
    for (int j = 0; j < numberOfFlight; j++) {
        QString s = static_cast<FlightObject *>(data.at(j))->cabinAgent3();

        if (inArray(s, crew) == false) {
            QString s1 = static_cast<FlightObject *>(data.at(j))->departure();

            if (s1 == "SGN") {
                P6SGN.push_back(s);
                cP6SGN++;
            } else if (s1 == "HAN") {
                P6HAN.push_back(s);
                cP6HAN++;
            } else if (s1 == "CXR") {
                P6CXR.push_back(s);
                cP6CXR++;
            }

            crew.push_back(s);
        }
    }

    for (int j = 0; j < indexDuplicateFlight.size() - 1; j++) {
        for (int i = indexDuplicateFlight[j]; i <= indexDuplicateFlight[j + 1] - 2; i++) {
            if (static_cast<FlightObject *>(data.at(i))->timeArrival() >static_cast<FlightObject *>(data.at(i + 1))->timeArrival()) {
                if (i < ((indexDuplicateFlight[j + 1] + indexDuplicateFlight[j] - 1) / 2)) {
                    for (int k = indexDuplicateFlight[j]; k <= i; k++) {
                        static_cast<FlightObject *>(data.at(k))->setTimeArrival(static_cast<FlightObject *>(data.at(k))->timeArrival() - 24 * 60);
                    }
                } else {
                    for (int k = i + 1; k <= indexDuplicateFlight[j + 1] - 1; k++) {
                       static_cast<FlightObject *>(data.at(k))->setTimeArrival(static_cast<FlightObject *>(data.at(k))->timeArrival() + 24 * 60);
                    }
                }
            }
        }
    }

    for (int i = 0; i < indexDuplicateFlight.size() - 1; i++) {
        Aircraft arr;
        arr.aircraftNumber = static_cast<FlightObject *>(data.at(indexDuplicateFlight[i]))->newAircraft();
        arr.timeDeparture = static_cast<FlightObject *>(data.at(indexDuplicateFlight[i]))->timeDeparture();
        arr.flagInProcess = false;
        arr.departure = static_cast<FlightObject *>(data.at(indexDuplicateFlight[i]))->departure();
        aircraft.push_back(arr);
    }

    for (int i = 1; i < numberOfFlight; i++) {
        Flight fli;
        fli.aircraft = static_cast<FlightObject *>(data.at(i))->newAircraft();
        fli.arrive = static_cast<FlightObject *>(data.at(i))->arrival();
        fli.check = false;
        fli.departure = static_cast<FlightObject *>(data.at(i))->departure();
        fli.flightNumber = static_cast<FlightObject *>(data.at(i))->name();
        fli.timeDeparture = static_cast<FlightObject *>(data.at(i))->timeDeparture();
        fli.timeFly = static_cast<FlightObject *>(data.at(i))->timeArrival() - static_cast<FlightObject *>(data.at(i))->timeDeparture() + GT;
        F.push_back(fli);
    }

    for (int i = 0; i < br1.size(); i++) {
        int maxAC = -2000, mAC, tg;
        int idx = nameToIndex(aircraft, br1[i]);
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

    for (int i = 0; i < br1.size(); i++) {
        aircraft[i].flagInProcess = true;
    }

    for (int i = 0; i < br2.size(); i++) {
        //br2[i].time = QString::number((br2[i].time.toInt() - br2[i].time.toInt() % 100) / 100 * 60 +
        //br2[i].time.toInt() % 100);
        static_cast <Problems *> (br2.at(i))->setTime(QString::number((static_cast <Problems *> (br2.at(i))->time().toInt() - static_cast <Problems *> (br2.at(i))->time().toInt() % 100) / 100 * 60 +
                                                                      static_cast <Problems *> (br2.at(i))->time().toInt() ));
    }

    for (int i = 0; i < br4.size(); i++) {
       // br4[i].time = QString::number((br4[i].time.toInt() - br4[i].time.toInt() % 100) / 100 * 60 + br4[i].time.toInt() % 100);
        static_cast <Problems *> (br4.at(i))->setTime(QString::number((static_cast <Problems *> (br4.at(i))->time().toInt() - static_cast <Problems *> (br4.at(i))->time().toInt() % 100) / 100 * 60 +
                                                                      static_cast <Problems *> (br4.at(i))->time().toInt() ));
    }

    for (int i = 0; i < br2.size(); i++) {
        aircraft[nameToIndex(aircraft, static_cast <Problems *> (br2.at(i))->name())].timeDeparture = static_cast <Problems *> (br2.at(i))->time().toInt();
    }

    QList<QString> ACbr3;

    for (int i = 0; i < br3.size(); i++) {
        ACbr3.push_back(aircraft[nameToIndex(aircraft, br3[i])].aircraftNumber);
    }

    QList<QString> ACbr4;

    for (int i = 0; i < br4.size(); i++) {
        ACbr4.push_back(aircraft[nameToIndex(aircraft, static_cast <Problems *> (br4.at(i))->name())].aircraftNumber);
    }

    QList<Problem4> AC4;

    for (int i = 0; i < br4.size(); i++) {
        Problem4 ac4;
        ac4.aircraftNumber = aircraft[nameToIndex(aircraft,static_cast <Problems *> (br4.at(i))->name())].aircraftNumber;
        ac4.flag = 0;
        ac4.time = static_cast <Problems *> (br2.at(i))->name().toInt();
        AC4.push_back(ac4);
    }

    //xu li
    do {
        int minimumTime = INT_MIN;
        int m = 1;

        for (int i = 0; i < aircraft.size(); i++) {
            if ((aircraft[i].timeDeparture < minimumTime) && (aircraft[i].flagInProcess == false)) {
                minimumTime = aircraft[i].timeDeparture;
                m = i;
            }
        }

        //Tim ra chuyen bay phu hop
        QList<Flight> F1;

        if (inArray(aircraft[m].aircraftNumber, ACbr3) == true) {
            for (int i = 0; i < F.size(); i++) {
                if ((F[i].departure == aircraft[m].departure) && (F[i].check == false)) {
                    if (inArray(F[i].arrive, AP) == true) {
                        F1.push_back(F[i]);
                    }
                }
            }
        } else {
            for (int i = 0; i < F.size(); i++) {
                if ((F[i].departure.compare(aircraft[m].departure) == 0) && (F[i].check == false)) {
                    F1.push_back(F[i]);
                }
            }
        }

        if (F1.size() > 0) {
            QList<Flight> F2;
            F1 = sortF(F1);

            for (int i = 0; i < F1.size(); i++) {
                if (F1[i].aircraft == aircraft[m].aircraftNumber) {
                    F2.push_back(F1[i]);
                }
            }

            int k, cf = 0;

            for (k = 0; k < F1.size(); k++) {
                for (int i = 0; i < F.size(); i++) {
                    if (F[i].departure == F1[k].arrive) {
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

            if (F2.size() > 0) {
                int cf = 0;
                int k1;

                for (k1 = 0; k1 < F2.size(); k1++) {
                    for (int i = 0; i < F.size(); i++) {
                        if (F[i].departure == F2[k].arrive) {
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

                for (int i = 0; i < F1.size(); i++) {
                    if (F2[k1].flightNumber == F1[i].flightNumber) {
                        k1 = i;
                        break;
                    }
                }

                if ((F1[k1].timeDeparture - F1[k].timeDeparture) <= 15) {
                    k = k1;
                }
            }

            if (F1[k].timeDeparture < aircraft[m].timeDeparture) {
                FlightSchedule fs1;
                fs1.aircraft = aircraft[m].aircraftNumber;
                fs1.aircraftOld = F1[k].aircraft;
                fs1.arrive = F1[k].arrive;
                fs1.departure = F1[k].departure;
                fs1.flightNumber = F1[k].flightNumber;
                fs1.timeArrive = aircraft[m].timeDeparture + F1[k].timeFly - GT;
                fs1.timeDeparture = aircraft[m].timeDeparture;
                fs1.timeDelay = aircraft[m].timeDeparture - F1[k].timeDeparture;
                FS.push_back(&fs1);
                aircraft[m].timeDeparture = aircraft[m].timeDeparture + F1[k].timeFly;
                aircraft[m].departure = F1[k].arrive;

                for (int i = 0; i < F.size(); i++) {
                    if (F1[k].flightNumber == F[i].flightNumber) {
                        F[i].check = true;
                        break;
                    }
                }
            } else {
                FlightSchedule fs1;
                fs1.aircraft = aircraft[m].aircraftNumber;
                fs1.aircraftOld = F1[k].aircraft;
                fs1.arrive = F1[k].arrive;
                fs1.departure = F1[k].departure;
                fs1.flightNumber = F1[k].flightNumber;
                fs1.timeArrive = F1[k].timeDeparture + F1[k].timeFly - GT;
                fs1.timeDeparture = F1[k].timeDeparture;
                fs1.timeDelay = 0;
                FS.push_back(&fs1);
                aircraft[m].timeDeparture = F1[k].timeDeparture + F1[k].timeFly;
                aircraft[m].departure = F1[k].arrive;

                for (int i = 0; i < F.size(); i++) {
                    if (F1[k].flightNumber == F[i].flightNumber) {
                        F[i].check = true;
                        break;
                    }
                }
            }
        } else {
            aircraft[m].flagInProcess = true;
        }

        // Handle problem 4
        if (inArray(aircraft[m].aircraftNumber, ACbr4) == true) {
            if (aircraft[m].departure.compare(QString("SGN")) == 0 || aircraft[m].departure.compare(QString("HAN")) == 0 || aircraft[m].departure.compare(QString("CXR")) == 0) {
                int loc;

                for (int i = 0; i < AC4.size(); i++) {
                    if (aircraft[m].aircraftNumber.compare(AC4[i].aircraftNumber) == 0) {
                        loc = i;
                        break;
                    }
                }

                if (aircraft[m].timeDeparture <= AC4[loc].time) {
                    AC4[loc].flag = FS.size() - 1;
                } else {
                    for (int i = FS.size() - 1; i > AC4[loc].flag; i--) { //tra chuyen bay chua thuc hien
                        for (int j = 0; j < F.size(); j++) {
                            if (FS[i]->flightNumber.compare(F[j].flightNumber) == 0) {
                                F[j].check = false;
                                break;
                            }
                        }
                    }

                    for (int i = 0; i < aircraft.size(); i++) {
                        for (int j = AC4[loc].flag; j >= 0; j--) {
                            if (FS[j]->aircraft.compare((aircraft[i].aircraftNumber)) == 0) {
                                aircraft[i].departure = FS[j]->arrive;
                                aircraft[i].timeDeparture = FS[j]->timeArrive + GT;
                                break;
                            }
                        }
                    }

                    FS.erase(FS.begin() + AC4[loc].flag + 1, FS.end());
                    aircraft[m].flagInProcess = true;

                    for (int i = 0; i < AC4.size(); i++) {
                        if (AC4[i].flag > AC4[loc].flag) {
                            for (int j = 0; j < aircraft.size(); j++) {
                                if (aircraft[j].aircraftNumber.compare(AC4[i].aircraftNumber) == 0) {
                                    aircraft[j].flagInProcess = false;
                                }
                            }

                            for (int j = AC4[loc].flag; j >= 0; j--) {
                                if (FS[j]->aircraft.compare(AC4[i].aircraftNumber) == 0) {
                                    if (FS[j]->arrive.compare(QString("SGN")) == 0 || FS[j]->arrive.compare(QString("HAN")) == 0 || FS[j]->arrive.compare(QString("CXR")) == 0) {
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

    for (int i = 0; i < FS.size(); i++) {
        stimeDelay = stimeDelay + FS[i]->timeDelay;
    }

    //FS = sortFS(FS);
    //To bay
    QList <QString> ACC2;
    indexDuplicateFlight.clear();

    for (int i = 0; i < FS.size(); i++) {
        if (inArray(FS[i]->aircraft, ACC2) == false) {
            ACC2.push_back(FS[i]->aircraft);
            indexDuplicateFlight.push_back(i);
        }
    }

    indexDuplicateFlight.push_back(FS.size());

    for (int i = 0; i < 100; i++) {
        P1SGN.push_back("to bay them SGN " + QString::number(i + 1));
        P1HAN.push_back("to bay them HAN " + QString::number(i + 1));
        P1CXR.push_back("to bay them CXR " + QString::number(i + 1));
        P2SGN.push_back("to bay them SGN " + QString::number(i + 1));
        P2HAN.push_back("to bay them HAN " + QString::number(i + 1));
        P2CXR.push_back("to bay them CXR " + QString::number(i + 1));
        P3SGN.push_back("to bay them SGN " + QString::number(i + 1));
        P3HAN.push_back("to bay them HAN " + QString::number(i + 1));
        P3CXR.push_back("to bay them CXR " + QString::number(i + 1));
        P4SGN.push_back("to bay them SGN " + QString::number(i + 1));
        P4HAN.push_back("to bay them HAN " + QString::number(i + 1));
        P4CXR.push_back("to bay them CXR " + QString::number(i + 1));
        P5SGN.push_back("to bay them SGN " + QString::number(i + 1));
        P5HAN.push_back("to bay them HAN " + QString::number(i + 1));
        P5CXR.push_back("to bay them CXR " + QString::number(i + 1));
        P6SGN.push_back("to bay them SGN " + QString::number(i + 1));
        P6HAN.push_back("to bay them HAN " + QString::number(i + 1));
        P6CXR.push_back("to bay them CXR " + QString::number(i + 1));
    }

    //sap xep to bay
    int crSGNused = 0, crHANused = 0, crCXRused = 0;

    for (int i = 0; i < indexDuplicateFlight.size() - 1; i++) {
        int mark = indexDuplicateFlight[i];
        int mark1 = mark;

        for (int j = indexDuplicateFlight[i]; j < indexDuplicateFlight[i + 1]; j++) {
            if (FS[j]->arrive == "HAN" || FS[j]->arrive == "SGN" || FS[j]->arrive == "CXR") {
                if (((FS[j]->timeArrive - FS[mark1]->timeDeparture) <= TL) && ((j - mark1 + 1) <= TrL)) {
                    mark = j + 1;
                } else {
                    for (int k = mark1; k < mark; k++) {
                        if (FS[mark1]->departure == "SGN") {
                            if (P1SGN.size() != 0) {
                                FS[k]->crew1 = P1SGN[0];
                            }

                            FS[k]->crew2 = P2SGN[0];
                            FS[k]->crew3 = P3SGN[0];
                            FS[k]->crew4 = P4SGN[0];
                            FS[k]->crew5 = P5SGN[0];
                            FS[k]->crew6 = P6SGN[0];
                        } else if (FS[mark1]->departure == "HAN") {
                            FS[k]->crew1 = P1HAN[0];
                            FS[k]->crew2 = P2HAN[0];
                            FS[k]->crew3 = P3HAN[0];
                            FS[k]->crew4 = P4HAN[0];
                            FS[k]->crew5 = P5HAN[0];
                            FS[k]->crew6 = P6HAN[0];
                        } else if (FS[mark1]->departure == "CXR") {
                            FS[k]->crew1 = P1CXR[0];
                            FS[k]->crew2 = P2CXR[0];
                            FS[k]->crew3 = P3CXR[0];
                            FS[k]->crew4 = P4CXR[0];
                            FS[k]->crew5 = P5CXR[0];
                            FS[k]->crew6 = P6CXR[0];
                        }
                    }

                    if (FS[mark1]->departure == "SGN") {
                        crSGNused++;
                        P1SGN.erase(P1SGN.begin());
                        P2SGN.erase(P2SGN.begin());
                        P3SGN.erase(P3SGN.begin());
                        P4SGN.erase(P4SGN.begin());
                        P5SGN.erase(P5SGN.begin());
                        P6SGN.erase(P6SGN.begin());
                    } else if (FS[mark1]->departure == "HAN") {
                        crHANused++;
                        P1HAN.erase(P1HAN.begin());
                        P2HAN.erase(P2HAN.begin());
                        P3HAN.erase(P3HAN.begin());
                        P4HAN.erase(P4HAN.begin());
                        P5HAN.erase(P5HAN.begin());
                        P6HAN.erase(P6HAN.begin());
                    } else if (FS[mark1]->departure == "CXR") {
                        crCXRused++;
                        P1CXR.erase(P1CXR.begin());
                        P2CXR.erase(P2CXR.begin());
                        P3CXR.erase(P3CXR.begin());
                        P4CXR.erase(P4CXR.begin());
                        P5CXR.erase(P5CXR.begin());
                        P6CXR.erase(P6CXR.begin());
                    }

                    mark1 = mark;
                }
            }

            if (j == indexDuplicateFlight[i + 1] - 1) {
                for (int k = mark1; k < indexDuplicateFlight[i + 1]; k++) {
                    if (FS[mark1]->departure == "SGN") {
                        FS[k]->crew1 = P1SGN[0];
                        FS[k]->crew2 = P2SGN[0];
                        FS[k]->crew3 = P3SGN[0];
                        FS[k]->crew4 = P4SGN[0];
                        FS[k]->crew5 = P5SGN[0];
                        FS[k]->crew6 = P6SGN[0];
                    } else if (FS[mark1]->departure == "HAN") {
                        FS[k]->crew1 = P1HAN[0];
                        FS[k]->crew2 = P2HAN[0];
                        FS[k]->crew3 = P3HAN[0];
                        FS[k]->crew4 = P4HAN[0];
                        FS[k]->crew5 = P5HAN[0];
                        FS[k]->crew6 = P6HAN[0];
                    } else if (FS[mark1]->departure == "CXR") {
                        FS[k]->crew1 = P1CXR[0];
                        FS[k]->crew2 = P2CXR[0];
                        FS[k]->crew3 = P3CXR[0];
                        FS[k]->crew4 = P4CXR[0];
                        FS[k]->crew5 = P5CXR[0];
                        FS[k]->crew6 = P6CXR[0];
                    }
                }

                if (FS[mark1]->departure == "SGN") {
                    crSGNused++;
                    P1SGN.erase(P1SGN.begin());
                    P2SGN.erase(P2SGN.begin());
                    P3SGN.erase(P3SGN.begin());
                    P4SGN.erase(P4SGN.begin());
                    P5SGN.erase(P5SGN.begin());
                    P6SGN.erase(P6SGN.begin());
                } else if (FS[mark1]->departure == "HAN") {
                    crHANused++;
                    P1HAN.erase(P1HAN.begin());
                    P2HAN.erase(P2HAN.begin());
                    P3HAN.erase(P3HAN.begin());
                    P4HAN.erase(P4HAN.begin());
                    P5HAN.erase(P5HAN.begin());
                    P6HAN.erase(P6HAN.begin());
                } else if (FS[mark1]->departure == "CXR") {
                    crCXRused++;
                    P1CXR.erase(P1CXR.begin());
                    P2CXR.erase(P2CXR.begin());
                    P3CXR.erase(P3CXR.begin());
                    P4CXR.erase(P4CXR.begin());
                    P5CXR.erase(P5CXR.begin());
                    P6CXR.erase(P6CXR.begin());
                }
            }
        }
    }


    for (int i = 0; i < FS.size(); i++) {
        FS[i]->timeDeparture = ((FS[i]->timeDeparture % (24 * 60)) - (FS[i]->timeDeparture % (24 * 60)) % 60) / 60 * 100 + (FS[i]->timeDeparture % (24 * 60)) % 60;
        FS[i]->timeArrive = ((FS[i]->timeArrive % (24 * 60)) - (FS[i]->timeArrive % (24 * 60)) % 60) / 60 * 100 + (FS[i]->timeArrive % (24 * 60)) % 60;
    }


    ACC2.clear();
    bool ch = true;

    for (int i = 0; i < FS.size(); i++) {
        if (inArray(FS[i]->aircraft, ACC2) == false) {
            ch = !ch;
            ACC2.push_back(FS[i]->aircraft);
        }

        if (ch) {

        } else {

        }
    }


    int countChangedAircraftAndTime = 0, countChangedAircraft = 0, maxx = FS[1]->timeDelay, convert = 0, flightCancel = 0;

    for (int i = 0; i < FS.size(); i++) {
        if (FS[i]->aircraft == FS[i]->aircraftOld) {
            countChangedAircraft++;
        }

        if ((FS[i]->timeDelay == 0) && FS[i]->aircraft != FS[i]->aircraftOld) {
            countChangedAircraftAndTime++;
        }

        if (FS[i]->timeDelay > maxx) {
            maxx = FS[i]->timeDelay;
        }

        if (FS[i]->timeDelay > 0) {
            convert++;
        }
    }

    for (int i = 0; i < F.size(); i++) {
        if (F[i].check == true) {
            flightCancel++;
        }
    }


    // Write file log


    QFile file(outputPath);

    if (file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        QTextStream out(&file);

        out << flightCancel << " : " << endl;
    }
    file.close();




    //return FS;
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

QString Problems::name()
{
    return _name;
}

void Problems::setName(const QString &name)
{
    if (_name != name) {
        _name = name;
    }
}

QString Problems::time()
{
    return _time;
}

void Problems::setTime(const QString &time)
{
    if (_time != time) {
        _time = time;
    }
}
