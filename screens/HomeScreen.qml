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

import "../dialogs"
import "../sections"
import "../widgets"

import CSVReader 1.0
import DFMPrinter 1.0
import FlightObject 1.0

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

    property var currentInputDatas
    property var optimizedInputDatas

    property alias currentDataModels: currentDataModels
    property alias optimizedDataModels: optimizedDataModels

    property int indexRow: 0
    property int indexColumn: 0

    function pad(num, size) {
        var s = num + "";

        while (s.length < size) {
            s = "0" + s;
        }

        return s;
    }

    FlightDetail {
        id: flightDialog

        onUpdated: {
            messages.displayMessage(qsTr("Flight updated") + translator.emptyString)
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
            messages.displayMessage(qsTr("Print PDF successfull") + translator.emptyString)
        }
    }

    CSVReader {
        id: resultReader

        source: "file:///" + applicationDir + "/data/input.csv"

        flight: true
        aircraft: false
        airport: false
    }

    CSVReader {
        id: inputReader

        source: "file:///" + applicationDir + "/data/input.csv"

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
        }
    }

    Component.onCompleted: {
        var d = new Date()
        var hours = d.getHours()
        var minutes = d.getMinutes()
        var seconds = d.getSeconds()

        timeLineCurrentPosition = timeLineCurrentPosition + hours * AppTheme.listItemWidth + minutes * AppTheme.listItemWidth / 60 + seconds * AppTheme.listItemWidth / 3600
        timeLineOptimizedPosition = timeLineOptimizedPosition + hours * AppTheme.listItemWidth + minutes * AppTheme.listItemWidth / 60 + seconds * AppTheme.listItemWidth / 3600

        currentTimeLinePosition = timeLineCurrentPosition
        optimizedTimeLinePosition = timeLineOptimizedPosition

        currentInputDatas = inputReader.read()
        optimizedInputDatas = resultReader.read()

        currentDataModels.clear()

        indexRow = 0;
        indexColumn = 0;

        for (var i = 0; i < optimizedInputDatas.length; i++) {
            appendModel(currentDataModels, currentInputDatas[i], currentInputDatas[i].AC)
        }

        optimizedDataModels.clear()

        indexRow = 0;
        indexColumn = 0;

        for (var i = 0; i < optimizedInputDatas.length; i++) {
            appendModel(optimizedDataModels, optimizedInputDatas[i], optimizedInputDatas[i].AC)
        }
    }

    function findObjectInData(data, value) {
        if (data.count > 0 ) {
            var lenght = data.count

            for (var i = 0; i < lenght; i++) {
                if (data.get(i).aircraft === value) {
                    return [true, i];
                }
            }
        }

        return [false, -1];
    }

    function appendModel(array, data, name) {
        var codes = findObjectInData(array, name);

        var times = Math.floor(data.TED / 100);

        if (!codes[0]) {
            indexColumn = 0;

            if (times === 0) {
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
                        "timeArrival": 0,

                        "newAircraft": "",
                        "oldAircraft": "",

                        "status": data.status }
                    ]
                })

                indexColumn++;

                for (var i = 1; i < times; i++) {
                    array.get(indexRow).flights.append({
                                "name": "",

                                "captain": "",
                                "coPilot": "",

                                "cabinManager": "",
                                "cabinAgent1": "",
                                "cabinAgent2": "",
                                "cabinAgent3": "",

                                "departure": "",
                                "arrival": "",

                                "timeDeparture": 0,
                                "timeArrival": 0,

                                "newAircraft": "",
                                "oldAircraft": "",

                                "status": data.status
                            })
                    indexColumn++;
                }

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
            for (var i = indexColumn; i < times; i++) {
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

                            "timeDeparture": 0,
                            "timeArrival": 0,

                            "newAircraft": "",
                            "oldAircraft": "",

                            "status": data.status
                        })

                indexColumn++;
            }

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

    ColumnLayout {
        id: columnLayout

        width: parent.width
        height: parent.height

        Layout.fillWidth: true
        Layout.fillHeight: true

        HeaderSection {
            id: header
        }

        TitleSection {
            id: titleSection

            index: 0
            currentIndex: 0

            iconSource: "qrc:/das/images/title/home.png"
            title: qsTr("Home") + translator.emptyString

            backVisible: false
            homeVisible: false
            printVisible: true
            settingVisible: false

            onPrinted: {
                printer.beginPrinting();
                printer.printWindow();
                printer.endPrinting();
            }

            onBuilt: { //This is a temporary function
                //
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
                    leftPadding: AppTheme.screenPadding

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

                            text: qsTr("Current Airline Schedules") + translator.emptyString

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
                                    model: [qsTr("Aircraft N°") + translator.emptyString,
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00",
                                        "12h00", "13h00", "14h00", "15h00", "16h00", "17h00", "18h00", "19h00", "20h00", "21h00", "22h00", "23h00",
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00", "12h00"]

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

                                            color: "#444444"

                                            width: name === "" ? listViewData.headerItem.itemAt(column).width : listViewData.headerItem.itemAt(column).width *
                                                   (timeArrival / 100 > timeDeparture / 100 ? timeArrival / 100 - timeDeparture / 100 :
                                                                                              (timeArrival / 100 < timeDeparture / 100 ? timeArrival / 100 - timeDeparture / 100 + 24 : 1))

                                            onClicked: {
                                                flightDialog.flightCode = flightNumber

                                                flightDialog.aircraft = newAircraft
                                                flightDialog.aircraftOld = oldAircraft

                                                flightDialog.departure = departure
                                                flightDialog.arrival = arrival

                                                flightDialog.timeDeparture = timeDeparture
                                                flightDialog.timeArrival = timeArrival

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

                                    Rectangle {
                                        color: "silver"
                                        height: parent.height
                                        width: 1
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
                    leftPadding: AppTheme.screenPadding

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

                            text: qsTr("Optimized Airline Schedules") + translator.emptyString

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

                                    model: [qsTr("Aircraft N°") + translator.emptyString,
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00",
                                        "12h00", "13h00", "14h00", "15h00", "16h00", "17h00", "18h00", "19h00", "20h00", "21h00", "22h00", "23h00",
                                        "0h00", "1h00", "2h00", "3h00", "4h00", "5h00", "6h00", "7h00", "8h00", "9h00", "10h00", "11h00",  "12h00"]

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

                                            color: status === FlightObject.OnlyDelayDay ? "#4f51d8" : status === FlightObject.OnlyDelayTime ? "#eab71a" : status === FlightObject.DelayDate ? "#df522e" : "#444444"

                                            width: name === "" ? listViewDataOptimized.headerItem.itemAt(column).width : listViewDataOptimized.headerItem.itemAt(column).width *
                                                   (timeArrival / 100 > timeDeparture / 100 ? timeArrival / 100 - timeDeparture / 100 :
                                                                                              (timeArrival / 100 < timeDeparture / 100 ? timeArrival / 100 - timeDeparture / 100 + 24 : 1))

                                            onClicked: {
                                                flightDialog.flightCode = flightNumber

                                                flightDialog.aircraft = newAircraft
                                                flightDialog.aircraftOld = oldAircraft

                                                flightDialog.departure = departure
                                                flightDialog.arrival = arrival

                                                flightDialog.timeDeparture = timeDeparture
                                                flightDialog.timeArrival = timeArrival

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

                                                contextMenu.open()
                                            }
                                        }
                                    }

                                    Rectangle {
                                        color: "silver"
                                        height: parent.height
                                        width: 1
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

        ToolTip.visible: hoverButton
        ToolTip.text: qsTr("Insert block") + translator.emptyString

        text: qsTr("+")
        highlighted: true
        font.pointSize: AppTheme.textSizeMenu

        anchors.margins: 10
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        MouseArea {
            anchors.fill: parent
            anchors.margins: 0
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onEntered: parent.hoverButton = true

            onExited: parent.hoverButton = false

            onClicked: {
                //
            }
        }
    }

    Menu {
        id: contextMenu

        property alias flightCode: txtFlightCode.text

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
            text: qsTr("Delete block")
            font.pointSize: AppTheme.textSizeMenu

            enabled: optimizedDataModels.count > 0

            onTriggered: {
                //
            }
        }
    }
}
