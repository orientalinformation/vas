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

#ifndef FLIGHTOBJECT_H
#define FLIGHTOBJECT_H

#include <QObject>

#include"dataobject.h"

class FlightObject : public DataObject
{
    Q_OBJECT

    Q_PROPERTY(QString CAP READ captain WRITE setCaptain NOTIFY captainChanged)
    Q_PROPERTY(QString FO READ coPilot WRITE setCoPilot NOTIFY coPilotChanged)

    Q_PROPERTY(QString CM READ cabinManager WRITE setCabinManager NOTIFY cabinManagerChanged)
    Q_PROPERTY(QString CA1 READ cabinAgent1 WRITE setCabinAgent1 NOTIFY cabinAgent1Changed)
    Q_PROPERTY(QString CA2 READ cabinAgent2 WRITE setCabinAgent2 NOTIFY cabinAgent2Changed)
    Q_PROPERTY(QString CA3 READ cabinAgent3 WRITE setCabinAgent3 NOTIFY cabinAgent3Changed)

    Q_PROPERTY(QString DEP READ departure WRITE setDeparture NOTIFY departureChanged)
    Q_PROPERTY(QString ARR READ arrival WRITE setArrival NOTIFY arrivalChanged)

    Q_PROPERTY(int TED READ timeDeparture WRITE setTimeDeparture NOTIFY timeDepartureChanged)
    Q_PROPERTY(int TEA READ timeArrival WRITE setTimeArrival NOTIFY timeArrivalChanged)

    Q_PROPERTY(QString AC READ newAircraft WRITE setNewAircraft NOTIFY newAircraftChanged)
    Q_PROPERTY(QString ACO READ oldAircraft WRITE setOldAircraft NOTIFY oldAircraftChanged)

    Q_PROPERTY(FlightStatus status READ status WRITE setStatus NOTIFY statusChanged
               )

    Q_ENUMS(FlightStatus)

public:
    enum FlightStatus {
        Unchanged = 0x0000,
        OnlyChangedAirplane = 0x0001,
        OnlyChangedTime = 0x0002,
        BothChangedAirplaneAndTime = 0x0003
    };

    FlightObject(DataObject *parent = 0);
    FlightObject(const QString &name, const QString &captain, const QString &coPilot, const QString &cabinManager,
                 const QString &cabinAgent1, const QString &cabinAgent2, const QString &cabinAgent3, const QString &departure,
                 const QString &arrival, const int &etd, const int &eta, const QString &newAircraft,
                 const QString &oldAircraft, const FlightStatus &status, DataObject *parent = 0);

    QString captain() const;
    void setCaptain(const QString &captain);

    QString coPilot() const;
    void setCoPilot(const QString &coPilot);

    QString cabinManager() const;
    void setCabinManager(const QString &cabinManager);

    QString cabinAgent1() const;
    void setCabinAgent1(const QString &cabinAgent);

    QString cabinAgent2() const;
    void setCabinAgent2(const QString &cabinAgent);

    QString cabinAgent3() const;
    void setCabinAgent3(const QString &cabinAgent);

    QString departure() const;
    void setDeparture(const QString &departure);

    QString arrival() const;
    void setArrival(const QString &arrival);

    int timeDeparture() const;
    void setTimeDeparture(const int &etd);

    int timeArrival() const;
    void setTimeArrival(const int &eta);

    QString newAircraft() const;
    void setNewAircraft(const QString &aircraft);

    QString oldAircraft() const;
    void setOldAircraft(const QString &aircraft);

    FlightStatus status() const;
    void setStatus(const FlightStatus &status);

signals:
    void nameChanged();

    void captainChanged();
    void coPilotChanged();

    void cabinManagerChanged();
    void cabinAgent1Changed();
    void cabinAgent2Changed();
    void cabinAgent3Changed();

    void departureChanged();
    void arrivalChanged();

    void timeDepartureChanged();
    void timeArrivalChanged();

    void newAircraftChanged();
    void oldAircraftChanged();

    void statusChanged();

private:
    QString _captain;
    QString _coPilot;

    QString _cabinManager;
    QString _cabinAgent1;
    QString _cabinAgent2;
    QString _cabinAgent3;

    QString _departure;
    QString _arrival;

    int _timeDeparture;
    int _timeArrival;

    QString _newAircraft;
    QString _oldAircraft;

    FlightStatus _status;

};

#endif // FLIGHTOBJECT_H
