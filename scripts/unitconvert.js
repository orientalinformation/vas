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
function compareString(tr1, tr2) {
    if(tr1.toUpperCase() === tr2.toUpperCase()) {
        return true
    }
    return false
}

function convertAircraftModelToArray(model)
{
    var array = []
    var modelLenght = model.count;

    for (var i = 0; i < modelLenght; i++) {
        var flightLength = model.get(i).flights.count

        for (var j = 0; j < flightLength; j++) {
            var currentFlight = model.get(i).flights.get(j)

            if (currentFlight.name !== "") {
                array.push({    name: currentFlight.name,

                                CAP: currentFlight.captain,
                                FO: currentFlight.coPilot,

                                CM: currentFlight.cabinManager,
                                CA1: currentFlight.cabinAgent1,
                                CA2: currentFlight.cabinAgent2,
                                CA3: currentFlight.cabinAgent3,

                                DEP: currentFlight.departure,
                                ARR: currentFlight.arrival,

                                TED: currentFlight.timeDeparture,
                                TEA: currentFlight.timeArrival,

                                AC: currentFlight.newAircraft,
                                ACO: currentFlight.oldAircraft,

                                status: currentFlight.status})
            }
        }
    }

    array.sort(function(a, b) {
        return parseInt(a.TED) - parseInt(b.TED);
    });

    return array
}

function sortArray(field, descending, primer)
{
    var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};

       descending = !descending ? 1 : -1;

       return function (a, b) {
           return a = key(a), b = key(b), descending * ((a > b) - (b > a));
         }
}

function insertFlight(data, flight, row)
{
    var flightLength = data.get(row).flights.count

    for (var i = 0; i < flightLength; i++) {
        if (data.get(row).flights.get(i).name !== "" &&
                (data.get(row).flights.get(i).timeDeparture <= flight.TED &&
                data.get(row).flights.get(i).timeArrival >= flight.TED) ||
                (data.get(row).flights.get(i).timeDeparture <= flight.TEA &&
                data.get(row).flights.get(i).timeArrival >= flight.TEA)) {
            return false
        }
    }

    for (var i = 0; i < flightLength; i++) {
        data.get(row).flights.append( { "name": flight.name,
                                        "captain": flight.CAP,
                                        "coPilot": flight.FO,

                                        "cabinManager": flight.CM,
                                        "cabinAgent1": flight.CA1,
                                        "cabinAgent2": flight.CA2,
                                        "cabinAgent3": flight.CA3,

                                        "departure": flight.DEP,
                                        "arrival": flight.ARR,

                                        "timeDeparture": flight.TED,
                                        "timeArrival": flight.TEA,

                                        "newAircraft": flight.AC,
                                        "oldAircraft": flight.ACO })
    }

    return true
}

function updateFlight(data, flight, row, column)
{
    var bottomIndex = column - 1
    var topIndex = column + 1

    var bottomInvalid = false
    var topInvalid = false

    var flightLength = data.get(row).flights.count
    var currentFlights = data.get(row).flights

    while (bottomIndex > 0) {
        if (data.get(row).flights.get(bottomIndex).name !== "") {
            if (currentFlights.get(column).timeDeparture < data.get(row).flights.get(bottomIndex).timeArrival) {
                bottomInvalid = true
            } else {
                bottomInvalid = false
            }

            break;
        } else {
            // Node empty
            if (currentFlights.get(column).timeDeparture < data.get(row).flights.get(bottomIndex).timeDeparture) {
                bottomIndex--;
                continue;
            } else {
                bottomInvalid = false

                break;
            }
        }
    }

    while (topIndex < flightLength) {
        if (data.get(row).flights.get(topIndex).name !== "") {
            if (currentFlights.get(column).timeArrival > data.get(row).flights.get(topIndex).timeDeparture) {
                topInvalid = true
            } else {
                topInvalid = false
            }

            break;
        } else {
            // Node empty
            if (currentFlights.get(column).timeArrival > data.get(row).flights.get(topIndex).timeArrival) {
                topIndex++;
                continue;
            } else {
                topInvalid = false

                break;
            }
        }
    }

    if (bottomInvalid || topInvalid) {
        messages.displayMessage(qsTr("There is not enough space to perform this operation.") + translator.tr)
    } else {
        var temp = column - 1
        while (temp > bottomIndex) {
            if (data.get(row).flights.get(temp).name === "") {
                data.get(row).flights.remove(temp)
            }
        }

        temp = column + 1
        while (temp < topIndex) {
            if (data.get(row).flights.get(temp).name === "") {
                data.get(row).flights.remove(temp)
            }
        }

        data.get(row).flights.set(column, { "name": flight.name,
                                            "captain": flight.CAP,
                                           "coPilot": flight.FO,

                                           "cabinManager": flight.CM,
                                           "cabinAgent1": flight.CA1,
                                           "cabinAgent2": flight.CA2,
                                           "cabinAgent3": flight.CA3,

                                           "departure": flight.DEP,
                                           "arrival": flight.ARR,

                                           "timeDeparture": flight.TED,
                                           "timeArrival": flight.TEA,

                                           "newAircraft": flight.AC,
                                           "oldAircraft": flight.ACO })

        if (currentFlights.get(column).timeArrival > data.get(row).flights.get(topIndex).timeDeparture) {
            data.get(row).flights.get(topIndex).timeDeparture = currentFlights.get(column).timeArrival
        } else {
            var time = data.get(row).flights.get(topIndex).timeDeparture - currentFlights.get(column).timeArrival

            if (time > 0) {
                data.get(row).flights.insert(column + 1, {  "name": "",
                                                            "captain": "",
                                                            "coPilot": "",

                                                            "cabinManager": "",
                                                            "cabinAgent1": "",
                                                            "cabinAgent2": "",
                                                            "cabinAgent3": "",

                                                            "departure": "",
                                                            "arrival": "",

                                                            "timeDeparture": currentFlights.get(column).timeArrival,
                                                            "timeArrival": data.get(row).flights.get(topIndex).timeDeparture,

                                                            "newAircraft": "",
                                                            "oldAircraft": "" })
            }
        }

        if (currentFlights.get(column).timeDeparture < data.get(row).flights.get(bottomIndex).timeArrival) {
            data.get(row).flights.get(bottomIndex).timeArrival = currentFlights.get(column).timeDeparture
        } else {
            var time = currentFlights.get(column).timeDeparture - data.get(row).flights.get(bottomIndex).timeArrival

            if (time > 0) {
                data.get(row).flights.insert(column, {  "name": "",
                                                        "captain": "",
                                                        "coPilot": "",

                                                        "cabinManager": "",
                                                        "cabinAgent1": "",
                                                        "cabinAgent2": "",
                                                        "cabinAgent3": "",

                                                        "departure": "",
                                                        "arrival": "",

                                                        "timeDeparture": data.get(row).flights.get(bottomIndex).timeArrival,
                                                        "timeArrival": currentFlights.get(column).timeDeparture,

                                                        "newAircraft": "",
                                                        "oldAircraft": "" })
            }
        }
    }
}
