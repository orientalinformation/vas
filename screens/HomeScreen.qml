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

import QtQuick 2.9
import QtQuick.Extras 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.1

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/setting.js" as Settings
import "../scripts/branding.js" as Branding
import "../scripts/unitconvert.js" as UnitConverter

import "../dialogs"
import "../sections"
import "../widgets"

import CSVReader 1.0
import DFMPrinter 1.0
import FlightObject 1.0
import IOStreams 1.0

Item {
    id: root

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property alias timeLineCurrentPosition: currentTimeLine.x
    property double currentTimeLinePosition
    property double listViewCurrentX

    property alias timeLineOptimizedPosition: optimizedTimeLine.x
    property double optimizedTimeLinePosition
    property double listViewOptimizedX

    property alias currentDataModels: currentDataModels
    property alias optimizedDataModels: optimizedDataModels

    property int indexRow: 0
    property int indexColumn: 0

    property int timeCounter: 0

    property bool isInfoShowed: false

    signal reload(var path, var inputPath, var isSingleView)

    signal newCase()
    signal open(var path)
    signal save(var path)
    signal saveAs(var path)
    signal exportCSV(var path)

    function pad(num, size) {
        var s = num + "";

        while (s.length < size) {
            s = "0" + s;
        }

        return s;
    }

    IOStreams {
        id: homeIostreams
    }

    FlightDetail {
        id: flightDialog

        onUpdated: {
            var modelLenght = optimizedDataModels.count;

            var exited = false

            var optimizedData = []
            var minTimeDeparture = 2350

            var ted = Math.floor(timeDeparture / 100) * 60 + timeDeparture % 100;
            var tea = Math.floor(timeArrival / 100) * 60 + timeArrival % 100;

            for (var i = 0; i < modelLenght; i++) {
                var flightLength = optimizedDataModels.get(i).flights.count

                for (var j = 0; j < flightLength; j++) {
                    if (optimizedDataModels.get(i).flights.get(j).name !== "" &&
                         UnitConverter.compareString(optimizedDataModels.get(i).flights.get(j).newAircraft, aircraft)) {
                        optimizedData.push(optimizedDataModels.get(i).flights.get(j))
                    }
                }
            }

            for (var i = 0; i < optimizedData.length; i++) {
                if (minTimeDeparture > Number(optimizedData[i].timeDeparture)) {
                    minTimeDeparture = Number(optimizedData[i].timeDeparture)
                }
            }

            for (var i = 0; i < modelLenght; i++) {
                var flightLength = optimizedDataModels.get(i).flights.count

                for (var j = 0; j < flightLength; j++) {
                    var currentFlights = optimizedDataModels.get(i).flights

                    if (UnitConverter.compareString(flightData.name, currentFlights.get(j).name)) {
                        if (UnitConverter.compareString(optimizedDataModels.get(i).aircraft, aircraft)) {
                            if (currentFlights.get(j).timeDeparture === Number(ted) && currentFlights.get(j).timeArrival === Number(tea)) {
                                optimizedDataModels.get(i).flights.set(j, { "name": flightData.name,
                                                                            "captain": flightData.CAP,
                                                                            "coPilot": flightData.FO,

                                                                            "cabinManager": flightData.CM,
                                                                            "cabinAgent1": flightData.CA1,
                                                                            "cabinAgent2": flightData.CA2,
                                                                            "cabinAgent3": flightData.CA3,

                                                                            "departure": flightData.DEP,
                                                                            "arrival": flightData.ARR,

                                                                            "timeDeparture": flightData.TED,
                                                                            "timeArrival": flightData.TEA,

                                                                            "newAircraft": flightData.AC,
                                                                            "oldAircraft": flightData.ACO } )
                            } else {
                                UnitConverter.updateFlight(optimizedDataModels, flightData, i, j)
                            }
                        } else {
                            var aircraftExisted = false

                            var left = j - 1
                            var right = j + 1

                            while (left >= 0 && currentFlights.get(left).name === "") {
                                left--;
                            }

                            while (right < flightLength && currentFlights.get(right).name === "") {
                                right++;
                            }

                            if (right < flightLength && left >= 0) {
                                if(!UnitConverter.compareString(optimizedDataModels.get(i).flights.get(left).arrival, optimizedDataModels.get(i).flights.get(right).departure)) {
                                    messages.displayMessage(qsTr("Can not moving the flight.") + translator.tr)

                                    return
                                }
                            }

                            for (var k = 0; k < modelLenght; k++) {

                                if (UnitConverter.compareString(optimizedDataModels.get(k).aircraft, aircraft)) {

                                    aircraftExisted = true

                                    var currentAircraft = {   "name": "", "captain": "", "coPilot": "", "cabinManager": "",
                                                              "cabinAgent1": "", "cabinAgent2": "", "cabinAgent3": "",
                                                              "departure": "", "arrival": "", "newAircraft": "",
                                                              "oldAircraft": "", "status": FlightObject.Unchanged }

                                    if (!UnitConverter.compareString(optimizedDataModels.get(i).aircraft, aircraft)) {
                                        optimizedDataModels.get(i).flights.set(j, currentAircraft)
                                    }

                                    appendModel(optimizedDataModels, flightData, flightData.AC)

                                    break
                                }
                            }

                            if (!aircraftExisted) {
                                messages.displayMessage(aircraft + qsTr(" not existed.") + translator.tr)

                                return
                            }
                        }

                        exited = true
                        break
                    }
                }

                if (exited) {
                    break
                }
            }

            messages.displayMessage(flightNumber.toUpperCase() + qsTr(" was updated.") + translator.tr)
        }
    }

    FlightDetail {
        id: insertFlightDialog

        onUpdated: {
            var ted = Math.floor(timeDeparture / 100) * 60 + timeDeparture % 100;
            var tea = Math.floor(timeArrival / 100) * 60 + timeArrival % 100;

            var insertData  = { "name": flightNumber.toUpperCase(), "CAP": captain, "FO": coPilot, "CM": cabinManager, "CA1": cabinAgent1,
                           "CA2": cabinAgent2, "CA3": cabinAgent3, "DEP": departure.toUpperCase(), "ARR": arrival.toUpperCase(),
                           "AC": aircraft.toUpperCase(), "ACO": "", "TED": ted, "TEA": tea, "status": 0 }

            appendModel(optimizedDataModels, insertData, insertData.AC)
            messages.displayMessage(flightNumber + qsTr(" is inserted.") + translator.tr)
        }
    }

    DFMBanner {
        id: messages
    }

    Printer {
        id: printer

        window: _mainWindow
        filename: "VAS Airline Schedules.pdf"

        pageSize.width: 640
        pageSize.height: 400

        onFinished: {
            if (success) {
                messages.displayMessage(qsTr("Print PDF successfull") + translator.tr)
            }
        }
    }

    CSVReader {
        id: resultReader

        flight: true
        aircraft: false
        airport: false
    }

    CSVReader {
        id: inputReader

        flight: true
        aircraft: false
        airport: false
    }

    Timer {
        id: currentTimer

        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            timeLineCurrentPosition = timeLineCurrentPosition + AppTheme.listItemWidth / 3600
            timeLineOptimizedPosition = timeLineOptimizedPosition + AppTheme.listItemWidth / 3600

            currentTimeLinePosition = currentTimeLinePosition + AppTheme.listItemWidth / 3600
            optimizedTimeLinePosition = optimizedTimeLinePosition + AppTheme.listItemWidth / 3600

            timeCounter++

            if (timeCounter === 60) {
                timeLineCurrentPosition += 1
                timeLineOptimizedPosition += 1

                currentTimeLinePosition += 1
                optimizedTimeLinePosition += 1

                timeCounter = 0
            }
        }
    }

    Component.onCompleted: {
        var d = new Date()
        var hours = d.getHours()
        var minutes = d.getMinutes()
        var seconds = d.getSeconds()

        timeLineCurrentPosition = timeLineCurrentPosition + hours * AppTheme.listItemWidth + minutes * AppTheme.listItemWidth / 60 + seconds * AppTheme.listItemWidth / 3600 + hours
        timeLineOptimizedPosition = timeLineOptimizedPosition + hours * AppTheme.listItemWidth + minutes * AppTheme.listItemWidth / 60 + seconds * AppTheme.listItemWidth / 3600 + hours

        currentTimeLinePosition = timeLineCurrentPosition
        optimizedTimeLinePosition = timeLineOptimizedPosition
    }

    onNewCase: {
        inputReader.source = ""
        resultReader.source = ""

        currentDataModels.clear()
        optimizedDataModels.clear()

        isSplitScheduleView = false

        root.isInfoShowed = false

        numberFlightUnchanged = 0
        numberAircarftUnchanged = 0
        numberFlightCancel = 0
        totalTimeDelay = 0
        numberFlightDelay = 0
        maximumTimeDelay = 0

        indexRow = 0
        indexColumn = 0

        timeCounter = 0
    }

    onOpen: {
        var currentInputDatas = homeIostreams.readObject("inputFlights", "homepage", path)
        var optimizedInputDatas = homeIostreams.readObject("resultFlights", "homepage", path)

        var status = homeIostreams.read("isSplitScreen", "homepage", path)

        isSplitScheduleView = status === "true" ? true : false

        root.isInfoShowed = status === "true" ? true : false

        updateScreen(currentInputDatas, currentDataModels, optimizedInputDatas, optimizedDataModels)
    }

    onSave: {
        var optimizedData = []
        var currentData = []

        for (var i = 0; i < optimizedDataModels.count; i++) {
            for (var j = 0; j < optimizedDataModels.get(i).flights.count; j++) {
                if (optimizedDataModels.get(i).flights.get(j).name !== "") {
                    optimizedData.push(optimizedDataModels.get(i).flights.get(j))
                }
            }
        }

        for (var i = 0; i < currentDataModels.count; i++) {
            for (var j = 0; j < currentDataModels.get(i).flights.count; j++) {
                if (currentDataModels.get(i).flights.get(j).name !== "") {
                    currentData.push(currentDataModels.get(i).flights.get(j))
                }
            }
        }

        homeIostreams.writeObject("inputFlights", currentData, "homepage", path)
        homeIostreams.writeObject("resultFlights", optimizedData, "homepage", path)

        homeIostreams.write("isSplitScreen", isSplitScheduleView ? "true" : "false", "homepage", path)
    }

    onSaveAs: {
        var optimizedData = []
        var currentData = []

        for (var i = 0; i < optimizedDataModels.count; i++) {
            for (var j = 0; j < optimizedDataModels.get(i).flights.count; j++) {
                if (optimizedDataModels.get(i).flights.get(j).name !== "") {
                    optimizedData.push(optimizedDataModels.get(i).flights.get(j))
                }
            }
        }

        for (var i = 0; i < currentDataModels.count; i++) {
            for (var j = 0; j < currentDataModels.get(i).flights.count; j++) {
                if (currentDataModels.get(i).flights.get(j).name !== "") {
                    currentData.push(currentDataModels.get(i).flights.get(j))
                }
            }
        }

        homeIostreams.writeObject("inputFlights", currentData, "homepage", path)
        homeIostreams.writeObject("resultFlights", optimizedData, "homepage", path)

        homeIostreams.write("isSplitScreen", isSplitScheduleView ? "true" : "false", "homepage", path)
    }

    onExportCSV: {
        var optimizedModels = []
        for (var i = 0; i < optimizedDataModels.count; i++) {

            for (var j = 0; j < optimizedDataModels.get(i).flights.count; j++) {
                if (optimizedDataModels.get(i).flights.get(j).name !== "") {
                    optimizedModels.push(optimizedDataModels.get(i).flights.get(j))
                }
            }
        }

        resultReader.write(optimizedModels, path);

        messages.displayMessage(qsTr("Print CSV successfull") + translator.tr)
    }

    onReload: {
        var currentInputDatas = []

        if (isSingleView === false) {
            inputReader.source = inputPath
            currentInputDatas = inputReader.read()
        } else {
            inputReader.source = ""
        }

        resultReader.source = path

        var optimizedInputDatas = resultReader.read(isSingleView)

        updateScreen(currentInputDatas, currentDataModels, optimizedInputDatas, optimizedDataModels)
    }

    function updateScreen(currentData, currentModel, optimizedData, optimizedModel) {
        currentModel.clear()

        indexRow = 0;
        indexColumn = 0;

        for (var i = 0; i < currentData.length; i++) {
            for (var j = 0; j < optimizedData.length; j++) {
                if (currentData[i].name === optimizedData[j].name) {
                    currentData[i].status = optimizedData[j].status
                    break
                }
            }

            appendModel(currentModel, currentData[i], currentData[i].AC)
        }

        optimizedModel.clear()

        indexRow = 0;
        indexColumn = 0;

        for (var i = 0; i < optimizedData.length; i++) {
            appendModel(optimizedModel, optimizedData[i], optimizedData[i].AC)
        }
    }

    function findObjectInData(data, value) {
        //return index of aircraft
        if (data.count > 0 ) {
            var lenght = data.count

            for (var i = 0; i < lenght; i++) {
                if (data.get(i).aircraft.toUpperCase() === value.toUpperCase()) {
                    return [true, i];
                }
            }
        }

        return [false, -1];
    }

    function appendModel(array, data, name) {
        var codes = findObjectInData(array, name);

        if (!codes[0]) {
            indexColumn = 0;

            if (data.TED === 0) {
                array.append({
                    "aircraft": data.AC,

                    "flights": [
                        { "name": data.name,

                        "captain": data.CAP,
                        "coPilot": data.FO,

                        "cabinManager": data.CM,
                        "cabinAgent1": data.CA1,
                        "cabinAgent2": data.CA2,
                        "cabinAgent3": data.CA3,

                        "departure": data.DEP,
                        "arrival": data.ARR,

                        "timeDeparture": data.TED,
                        "timeArrival": data.TEA,

                        "newAircraft": data.AC,
                        "oldAircraft": data.ACO,

                        "status": data.status }
                    ]
                })

                indexColumn++;
            } else {
                array.append({
                    "aircraft": data.AC,

                    "flights": [
                        { "name": "",

                        "captain": "",
                        "coPilot": "",

                        "cabinManager": "",
                        "cabinAgent1": "",
                        "cabinAgent2": "",
                        "cabinAgent3": "",

                        "departure": "",
                        "arrival": "",

                        "timeDeparture": 0,
                        "timeArrival": data.TED,

                        "newAircraft": "",
                        "oldAircraft": "",

                        "status": data.status }
                    ]
                })

                indexColumn++;

                array.get(indexRow).flights.append({
                            "name": data.name,

                            "captain": data.CAP,
                            "coPilot": data.FO,

                            "cabinManager": data.CM,
                            "cabinAgent1": data.CA1,
                            "cabinAgent2": data.CA2,
                            "cabinAgent3": data.CA3,

                            "departure": data.DEP,
                            "arrival": data.ARR,

                            "timeDeparture": data.TED,
                            "timeArrival": data.TEA,

                            "newAircraft": data.AC,
                            "oldAircraft": data.ACO,

                            "status": data.status
                        })
                indexColumn++;
            }

            indexRow++;
        } else {
            var flightCount = array.get(codes[1]).flights.count

            var lastTEA = array.get(codes[1]).flights.get(flightCount - 1).timeArrival

//            if (lastTEA < data.TED) {
                array.get(codes[1]).flights.append({
                            "name": "",

                            "captain": "",
                            "coPilot": "",

                            "cabinManager": "",
                            "cabinAgent1": "",
                            "cabinAgent2": "",
                            "cabinAgent3": "",

                            "departure": "",
                            "arrival": "",

                            "timeDeparture": lastTEA,
                            "timeArrival": data.TED,

                            "newAircraft": "",
                            "oldAircraft": "",

                            "status": data.status
                        })


                indexColumn++;
            //}

            array.get(codes[1]).flights.append({
                        "name": data.name,

                        "captain": data.CAP,
                        "coPilot": data.FO,

                        "cabinManager": data.CM,
                        "cabinAgent1": data.CA1,
                        "cabinAgent2": data.CA2,
                        "cabinAgent3": data.CA3,

                        "departure": data.DEP,
                        "arrival": data.ARR,

                        "timeDeparture": data.TED,
                        "timeArrival": data.TEA,

                        "newAircraft": data.AC,
                        "oldAircraft": data.ACO,

                        "status": data.status
                    })
            indexColumn++;
        }
    }

    DFMInfoSheet {
        id: info

        anchors.right: root.right
        anchors.rightMargin: AppTheme.hscale(10)

        opacity: 0

        visible: isInfoShowed

        z: 3
    }

    function updateCalculationInfo() {
        if (isInfoShowed) {
            info.unchanged = numberFlightUnchanged
            info.aircraftUnchanged = numberAircarftUnchanged
            info.canceled = numberFlightCancel
            info.totalDelay = totalTimeDelay
            info.numberDelay = numberFlightDelay
            info.maximumDelay = maximumTimeDelay
        }
    }

    ColumnLayout {
        id: columnLayout

        width: parent.width
        height: parent.height

        Layout.fillWidth: true
        Layout.fillHeight: true

        TitleSection {
            id: titleSection

            index: 0
            currentIndex: 0

            iconSource: "qrc:/das/images/title/home.png"
            title: qsTr("Home") + translator.tr

            backVisible: false
            homeVisible: false
            printVisible: true
            settingVisible: false

            onPrinted: {
                var optimizedModels = []

                for (var i = 0; i < optimizedDataModels.count; i++) {
                    for (var j = 0; j < optimizedDataModels.get(i).flights.count; j++) {
                        if (optimizedDataModels.get(i).flights.get(j).name !== "") {
                            optimizedModels.push(optimizedDataModels.get(i).flights.get(j))
                        }
                    }
                }

                printer.printerPDF(optimizedModels)
            }
        }

        Frame {
            id: frameContent

            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: AppTheme.tscale(3)

            topPadding: 0
            bottomPadding: 0

            background: Rectangle {
                border.color: "transparent"
                radius: 0
                color: "#eaeaea"
            }

            ColumnLayout {
                id: columnLayoutTool
                Layout.fillWidth: true
                anchors.fill: parent

                Frame {
                    id: frameCurrentSchedules
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    padding: 0
                    topPadding: AppTheme.vscale(5)
                    leftPadding: AppTheme.screenPadding

                    Layout.preferredHeight: parent.height / 2

                    background: Rectangle {
                        color: "#dddddd"
                        border.color: "transparent"
                        radius: 0
                    }

                    visible: isSplitScheduleView

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        anchors.fill: parent

                        spacing: AppTheme.vscale(10)

                        Label {
                            id: lblCurrentSchedule

                            text: qsTr("Current Airline Schedules") + translator.tr

                            font.bold: true
                            font.weight: Font.Bold
                            font.pointSize: AppTheme.textSizeText
                            verticalAlignment: Text.AlignVCenter

                            Layout.fillWidth: true

                            color: "#00aaff"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: AppTheme.lineHeight
                            color: "#00aaff"
                        }

                        ListView {
                            id: listViewData

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            contentWidth: headerItem.width

                            clip: true

                            flickableDirection: Flickable.HorizontalAndVerticalFlick

                            headerPositioning: ListView.OverlayHeader

                            boundsBehavior: Flickable.StopAtBounds

                            Rectangle {
                                id: currentTimeLine

                                width: 3
                                height: parent.height

                                color: "#ff0000"
                                border.color: "#ff0000"

                                x: AppTheme.listItemWidth

                                z: 3
                            }

                            header: Row {
                                spacing: 1

                                function itemAt(index) { return repeater.itemAt(index) }

                                Repeater {
                                    id: repeater
                                    model: [qsTr("Aircraft N°") + translator.tr,
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00",
                                        "12h00", "13h00", "14h00", "15h00", "16h00", "17h00", "18h00", "19h00", "20h00", "21h00", "22h00", "23h00",
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00", "12h00",
                                        "13h00", "14h00", "15h00", "16h00", "17h00", "18h00", "19h00", "20h00", "21h00", "22h00", "23h00"]

                                    Label {
                                        text: modelData
                                        font.pointSize: AppTheme.textSizeSmall
                                        padding: AppTheme.screenPadding

                                        background: Rectangle {
                                            color: "silver"
                                        }

                                        width: AppTheme.listItemWidth

                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                z: 2
                            }

                            model: ListModel {
                                id: currentDataModels
                            }

                            delegate: Column {
                                id: delegate
                                property int row: index

                                spacing: 1

                                Row {
                                    Rectangle {
                                        color: "silver"
                                        height: parent.height
                                        width: 1
                                    }

                                    Label {
                                        id: flightCode

                                        text: aircraft

                                        font.pointSize: AppTheme.textSizeText
                                        font.capitalization: Font.AllUppercase
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter

                                        padding: AppTheme.tscale(5)

                                        anchors.verticalCenter: parent.verticalCenter

                                        width: listViewData.headerItem.itemAt(0).width
                                    }

                                    Rectangle {
                                        color: "silver"
                                        height: parent.height
                                        width: 1
                                    }

                                    Repeater {
                                        model: flights

                                        DFMFlightButton {
                                            id: control

                                            property int column: index

                                            flightNumber: name

                                            depAirport: departure
                                            arrAirport: arrival

                                            color: status === FlightObject.OnlyChangedAirplane ? Settings.colorChangedAirplane :
                                                                                          status === FlightObject.OnlyChangedTime ? Settings.colorChangedTime :
                                                                                          status === FlightObject.BothChangedAirplaneAndTime ? Settings.colorChangedAirplaneAndTime : Settings.colorUnchanged

                                            //color: "#444444"

                                            flightLenght: listViewData.headerItem.itemAt(column).width * (timeArrival - timeDeparture) / 60

                                            onClicked: {
                                                flightDialog.isInserted = false

                                                flightDialog.isReadOnly = true

                                                flightDialog.flightNumber = flightNumber

                                                flightDialog.aircraft = newAircraft
                                                flightDialog.aircraftOld = oldAircraft

                                                flightDialog.departure = departure
                                                flightDialog.arrival = arrival

                                                var ted = ((timeDeparture) - (timeDeparture) % 60) / 60 * 100 + (timeDeparture) % 60;
                                                var tea = ((timeArrival) - (timeArrival) % 60) / 60 * 100 + (timeArrival) % 60;

                                                flightDialog.timeDeparture = ted
                                                flightDialog.timeArrival = tea

                                                flightDialog.captain = captain
                                                flightDialog.coPilot = coPilot

                                                flightDialog.cabinManager = cabinManager
                                                flightDialog.cabinAgent1 = cabinAgent1
                                                flightDialog.cabinAgent2 = cabinAgent2
                                                flightDialog.cabinAgent3 = cabinAgent3

                                                flightDialog.open()
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    color: "silver"
                                    width: parent.width
                                    height: 1
                                }
                            }

                            ScrollIndicator.horizontal: ScrollIndicator { }
                            ScrollIndicator.vertical: ScrollIndicator { }

                            onContentXChanged: {
                                if (listViewCurrentX < contentX) {
                                    timeLineCurrentPosition = currentTimeLinePosition - contentX;
                                } else if (listViewCurrentX > contentX) {
                                    timeLineCurrentPosition = timeLineCurrentPosition + listViewCurrentX - contentX;
                                }

                                listViewCurrentX = contentX
                            }

                            Component.onCompleted: listViewCurrentX = listViewData.contentX
                        }
                    }
                }

                Frame {
                    id: frameOptimizedSchedules
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    padding: 0
                    topPadding: AppTheme.vscale(5)
                    leftPadding: AppTheme.screenPadding

                    Layout.preferredHeight: parent.height / 2

                    background: Rectangle {
                        color: "#dddddd"
                        border.color: "transparent"
                        radius: 0
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        anchors.fill: parent

                        spacing: AppTheme.vscale(10)

                        Label {
                            id: lblOptimizedSchedule

                            text: qsTr("Optimized Airline Schedules") + translator.tr

                            font.bold: true
                            font.weight: Font.Bold
                            font.pointSize: AppTheme.textSizeText
                            verticalAlignment: Text.AlignVCenter

                            Layout.fillWidth: true

                            color: "#00aaff"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: AppTheme.lineHeight
                            color: "#00aaff"
                        }

                        ListView {
                            id: listViewDataOptimized

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            contentWidth: headerItem.width

                            clip: true

                            flickableDirection: Flickable.HorizontalAndVerticalFlick

                            headerPositioning: ListView.OverlayHeader

                            boundsBehavior: Flickable.StopAtBounds

                            Rectangle {
                                id: optimizedTimeLine

                                width: 3
                                height: parent.height

                                color: "#ff0000"
                                border.color: "#ff0000"

                                x: AppTheme.listItemWidth

                                z: 3
                            }

                            header: Row {
                                spacing: 1

                                function itemAt(index) { return repeaterOptimized.itemAt(index) }

                                Repeater {
                                    id: repeaterOptimized

                                    model: [qsTr("Aircraft N°") + translator.tr,
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00",
                                        "12h00", "13h00", "14h00", "15h00", "16h00", "17h00", "18h00", "19h00", "20h00", "21h00", "22h00", "23h00",
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00",  "12h00",
                                        "13h00", "14h00", "15h00", "16h00", "17h00", "18h00", "19h00", "20h00", "21h00", "22h00", "23h00" ]

                                    Label {
                                        text: modelData
                                        font.pointSize: AppTheme.textSizeMenu
                                        padding: AppTheme.screenPadding

                                        background: Rectangle {
                                            color: "silver"
                                        }

                                        width: AppTheme.listItemWidth

                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                z: 2
                            }

                            model: ListModel {
                                id: optimizedDataModels
                            }

                            delegate: Column {
                                id: delegateOptimized

                                property int row: index

                                spacing: 1

                                Row {
                                    Rectangle {
                                        color: "silver"
                                        height: parent.height
                                        width: 1
                                    }

                                    Label {
                                        id: flightCodeOptimized

                                        text: aircraft

                                        font.pointSize: AppTheme.textSizeText
                                        verticalAlignment: Text.AlignVCenter
                                        font.capitalization: Font.AllUppercase
                                        horizontalAlignment: Text.AlignHCenter

                                        padding: AppTheme.tscale(5)

                                        anchors.verticalCenter: parent.verticalCenter

                                        width: listViewDataOptimized.headerItem.itemAt(0).width
                                    }

                                    Rectangle {
                                        color: "silver"
                                        height: parent.height
                                        width: 1
                                    }

                                    Repeater {
                                        model: flights

                                        DFMFlightButton {
                                            id: controlOptimized

                                            property int column: index

                                            flightNumber: name

                                            depAirport: departure
                                            arrAirport: arrival

                                            color: status === FlightObject.OnlyChangedAirplane ? Settings.colorChangedAirplane :
                                                                                          status === FlightObject.OnlyChangedTime ? Settings.colorChangedTime :
                                                                                          status === FlightObject.BothChangedAirplaneAndTime ? Settings.colorChangedAirplaneAndTime : Settings.colorUnchanged

                                            flightLenght: listViewDataOptimized.headerItem.itemAt(column).width * (timeArrival - timeDeparture) / 60

                                            onClicked: {
                                                flightDialog.isInserted = false

                                                flightDialog.isReadOnly = false

                                                flightDialog.flightNumber = flightNumber

                                                flightDialog.aircraft = newAircraft
                                                flightDialog.aircraftOld = oldAircraft

                                                flightDialog.departure = departure
                                                flightDialog.arrival = arrival

                                                var ted = ((timeDeparture) - (timeDeparture) % 60) / 60 * 100 + (timeDeparture) % 60;
                                                var tea = ((timeArrival) - (timeArrival) % 60) / 60 * 100 + (timeArrival) % 60;

                                                flightDialog.timeDeparture = ted
                                                flightDialog.timeArrival = tea

                                                flightDialog.captain = captain
                                                flightDialog.coPilot = coPilot

                                                flightDialog.cabinManager = cabinManager
                                                flightDialog.cabinAgent1 = cabinAgent1
                                                flightDialog.cabinAgent2 = cabinAgent2
                                                flightDialog.cabinAgent3 = cabinAgent3

                                                flightDialog.open()
                                            }

                                            onRightClicked: {
                                                contextMenu.flightCode = flightNumber
                                                contextMenu.row = delegateOptimized.row
                                                contextMenu.column = column
                                                contextMenu.open()
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    color: "silver"
                                    width: parent.width
                                    height: 1
                                }

                                // Animate adding and removing of items:
                                ListView.onRemove: SequentialAnimation {
                                    PropertyAction { target: delegateOptimized; property: "ListView.delayRemove"; value: true }
                                    NumberAnimation { target: delegateOptimized; property: "height"; to: 0; duration: 250; easing.type: Easing.InOutQuad }

                                    // Make sure delayRemove is set back to false so that the item can be destroyed
                                    PropertyAction { target: delegateOptimized; property: "ListView.delayRemove"; value: false }
                                }
                            }

                            ScrollIndicator.horizontal: ScrollIndicator { }
                            ScrollIndicator.vertical: ScrollIndicator { }

                            onContentXChanged: {
                                if (listViewOptimizedX < contentX) {
                                    timeLineOptimizedPosition = optimizedTimeLinePosition - contentX;
                                } else if (listViewOptimizedX > contentX) {
                                    timeLineOptimizedPosition = timeLineOptimizedPosition + listViewOptimizedX - contentX;
                                }

                                listViewOptimizedX = contentX
                            }

                            Component.onCompleted: listViewOptimizedX = listViewDataOptimized.contentX
                        }
                    }
                }
            }
        }
    }

    RoundButton {
        property bool hoverButton: false

        highlighted: true
        font.pointSize: AppTheme.textSizeMenu

        anchors.margins: 10
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        visible: isInfoShowed

        contentItem: Image {
            id: updateIcon

            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter

            source: "qrc:/das/images/actions/info.png"
        }

        ColorOverlay {
            anchors.fill: updateIcon
            source: updateIcon
            color: "#94e9f0"
        }

        z: 4

        onHoverButtonChanged: {
            if (!hoverButton) {
                info.opacity = 0;
            } else {

                info.opacity = 0.8;
            }

            updateCalculationInfo();
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: 0
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onEntered: parent.hoverButton = true

            onExited: parent.hoverButton = false
        }
    }

    RoundButton {
        property bool hoverButton: false

        ToolTip.visible: hoverButton
        ToolTip.text: qsTr("Insert block") + translator.tr

        text: qsTr("+")
        highlighted: true
        font.pointSize: AppTheme.textSizeMenu

        anchors.margins: 10
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        z: 4

        MouseArea {
            anchors.fill: parent
            anchors.margins: 0
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onEntered: parent.hoverButton = true

            onExited: parent.hoverButton = false

            onClicked: {
                insertFlightDialog.isInserted = true
                insertFlightDialog.flightCode = qsTr("Add new flight")

                insertFlightDialog.flightNumber = ""

                insertFlightDialog.aircraft = ""
                insertFlightDialog.aircraftOld = ""

                insertFlightDialog.departure = ""
                insertFlightDialog.arrival = ""

                insertFlightDialog.timeDeparture = ""
                insertFlightDialog.timeArrival = ""

                insertFlightDialog.captain = ""
                insertFlightDialog.coPilot = ""

                insertFlightDialog.cabinManager = ""
                insertFlightDialog.cabinAgent1 = ""
                insertFlightDialog.cabinAgent2 = ""
                insertFlightDialog.cabinAgent3 = ""

                insertFlightDialog.open();
            }
        }
    }

    Menu {
        id: contextMenu

        property alias flightCode: txtFlightCode.text

        property int row

        property int  column

        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2

        modal: true

        background: Rectangle {
            implicitWidth: AppTheme.hscale(180)
            implicitHeight: AppTheme.vscale(150)

            color: "#edf0f5"

            border.color: "#a9b8c0"
        }

        Label {
            id: txtFlightCode

            padding: 10
            font.bold: true
            font.pointSize: AppTheme.textSizeText

            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.fillWidth: true
            height: AppTheme.lineHeight
            color: "#dbdbdb"
        }

        MenuItem {
            id: itemDelete
            text: qsTr("Delete block") + translator.tr
            font.pointSize: AppTheme.textSizeMenu

            enabled: optimizedDataModels.count > 0

            onTriggered: {
                optimizedDataModels.get(contextMenu.row).flights.set(contextMenu.column, {   "name": "",

                                                                                             "captain": "",
                                                                                             "coPilot": "",

                                                                                             "cabinManager": "",
                                                                                             "cabinAgent1": "",
                                                                                             "cabinAgent2": "",
                                                                                             "cabinAgent3": "",

                                                                                             "departure": "",
                                                                                             "arrival": "",

                                                                                             "newAircraft": "",
                                                                                             "oldAircraft": "",

                                                                                             "status": FlightObject.Unchanged
                                                                     })

                messages.displayMessage(contextMenu.flightCode + qsTr(" is deleted.") + translator.tr)
            }
        }
    }
}
