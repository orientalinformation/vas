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
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import "../theme"

import "../sections"
import "../widgets"
import "../scripts/setting.js" as Settings
import "../scripts/unitconvert.js" as UnitConverter

Dialog {
    id: flightDialog

    property bool isInserted: false

    property string flightCode: ""

    property bool isReadOnly: false

    property alias flightNumber: txtFN.text

    property alias aircraft: txtAC.text
    property alias aircraftOld: txtACOld.text

    property alias departure: txtDEP.text
    property alias arrival: txtARR.text

    property alias timeDeparture: txtETD.text
    property alias timeArrival: txtETA.text

    property alias captain: txtCAP.text
    property alias coPilot: txtFO.text

    property alias cabinManager: txtCM.text
    property alias cabinAgent1: txtCA1.text
    property alias cabinAgent2: txtCA2.text
    property alias cabinAgent3: txtCA3.text

    signal updated(var flightData, var isUpdated)

    focus: true
    modal: true

    width: AppTheme.hscale(400)
    height: AppTheme.vscale(570)

    x: (_mainWindow.width - width) / 2
    y: (_mainWindow.height - height) / 2

    padding: 0
    topPadding: 0

    ColumnLayout {
        width: parent.width
        height: parent.height

        Layout.fillWidth: true
        Layout.fillHeight: true

        TitleSection {
            title: isInserted ? flightCode : flightNumber

            backVisible: false
            homeVisible: false
            printVisible: false
            settingVisible: false
            quitVisible: false

            titleInCenter: true
        }

        Frame {
            Layout.fillWidth: true
            Layout.fillHeight: true

            background: Rectangle {
                border.color: "transparent"
                radius: 0
                color: "#eaeaea"
            }

            padding: AppTheme.tscale(5)

            leftPadding: AppTheme.screenPadding
            rightPadding: AppTheme.screenPadding

            ColumnLayout {
                anchors.fill: parent

                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    SwipeView {
                        id: flightSwipeView

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        currentIndex: tabBar.currentIndex

                        clip: true

                        interactive: false

                        Item {
                            id: flightDetail

                            GridLayout {
                                rowSpacing: AppTheme.rowSpacing
                                columnSpacing: AppTheme.columnSpacing

                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                anchors.fill: parent

                                Label {
                                    id: lblAC
                                    text: qsTr("A/C") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 0
                                    Layout.column: 0
                                }

                                TextField {
                                    id: txtAC
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText
                                    font.capitalization: Font.AllUppercase

                                    readOnly: isReadOnly

                                    Layout.row: 0
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblFN
                                    text: qsTr("FN") + translator.tr
                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 1
                                    Layout.column: 0

                                    visible: isInserted
                                }

                                TextField  {
                                    id: txtFN
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText
                                    font.capitalization: Font.AllUppercase

                                    readOnly: isReadOnly

                                    Layout.row: 1
                                    Layout.column: 1

                                    visible: isInserted
                                }

                                Label {
                                    id: lblACOld
                                    text: qsTr("A/C old") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 2
                                    Layout.column: 0

                                    visible: !isInserted
                                }

                                TextField  {
                                    id: txtACOld
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: true

                                    Layout.row: 2
                                    Layout.column: 1

                                    visible: !isInserted
                                }

                                Label {
                                    id: lblDEP
                                    text: qsTr("DEP") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 3
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtDEP
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText
                                    font.capitalization: Font.AllUppercase

                                    readOnly: isReadOnly

                                    Layout.row: 3
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblARR
                                    text: qsTr("ARR") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 4
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtARR
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText
                                    font.capitalization: Font.AllUppercase

                                    readOnly: isReadOnly

                                    Layout.row: 4
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblETD
                                    text: qsTr("ETD") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 5
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtETD
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    validator: IntValidator { bottom:0; top: 4759 }

                                    readOnly: isReadOnly

                                    Layout.row: 5
                                    Layout.column: 1

                                    onEditingFinished: {
                                    }
                                }

                                Label {
                                    id: lblETA
                                    text: qsTr("ETA") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 6
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtETA
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    validator: IntValidator { bottom:0; top: 4759 }

                                    readOnly: isReadOnly

                                    onEditingFinished: {
                                    }

                                    Layout.row: 6
                                    Layout.column: 1
                                }

                                Item {
                                    // vertical spacer item
                                    Layout.fillHeight: true

                                    Rectangle {
                                        anchors.fill: parent
                                        color: "transparent"
                                    } // to visualize the spacer

                                    Layout.row: 7
                                    Layout.column: 0
                                }
                            }
                        }

                        Item {
                            id: crewDetail

                            GridLayout {
                                rowSpacing: AppTheme.rowSpacing
                                columnSpacing: AppTheme.columnSpacing

                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                anchors.fill: parent

                                Label {
                                    id: lblCAP
                                    text: qsTr("CAP") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 0
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtCAP
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 0
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblFO
                                    text: qsTr("FO") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 1
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtFO
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 1
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblCM
                                    text: qsTr("CM") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 2
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtCM
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 2
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblCA1
                                    text: qsTr("CA 1") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 3
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtCA1
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 3
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblCA2
                                    text: qsTr("CA 2") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 4
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtCA2
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 4
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblCA3
                                    text: qsTr("CA 3") + translator.tr

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 5
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtCA3
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 5
                                    Layout.column: 1
                                } 

                                Item {
                                    // vertical spacer item
                                    Layout.fillHeight: true

                                    Rectangle {
                                        anchors.fill: parent
                                        color: "transparent"
                                    } // to visualize the spacer

                                    Layout.row: 6
                                    Layout.column: 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    RoundButton {
        text: qsTr("Update") + translator.tr

        property bool hoverButton: false

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.rightMargin: AppTheme.hscale(15)

        ToolTip.visible: hoverButton
        ToolTip.text: isInserted ? qsTr("Save values") + translator.tr : qsTr("Update values") + translator.tr

        contentItem: Image {
            id: updateIcon

            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter

            source: isInserted ? "qrc:/das/images/actions/save.png" : "qrc:/das/images/actions/update.png"
        }

        highlighted: true

        ColorOverlay {
            anchors.fill: updateIcon
            source: updateIcon
            color: "#94e9f0"
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: 0
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onEntered: parent.hoverButton = true

            onExited: parent.hoverButton = false

            onClicked: {
                if (isInserted && flightNumber == "") {
                    messages.displayMessage(qsTr("The flight code can not empty.") + translator.tr)

                    return
                }

                if (aircraft == "") {
                    messages.displayMessage(qsTr("The aircraft code can not empty.") + translator.tr)

                    return
                }

                if (departure == "") {
                    messages.displayMessage(qsTr("The departure port can not empty.") + translator.tr)

                    return
                }

                if (arrival == "") {
                    messages.displayMessage(qsTr("The arrival port can not empty.") + translator.tr)

                    return
                }

                if (timeDeparture == "" || timeArrival == "" || Number(timeDeparture) <= 0 || Number(timeArrival) <= 0) {
                    messages.displayMessage(qsTr("The estimated time is invalid.") + translator.tr)

                    return
                }

                if (Number(timeArrival) <= Number(timeDeparture)) {
                    messages.displayMessage(qsTr("Estimated time of arrival must be greater estimated time of departure.") + translator.tr)

                    return
                }

                var optimizedData = []

                var maxTimeArrival = 0
                var minTimeArrival = 2350

                var checkTed = true
                var checkTea = true
                var checkDep = true
                var checkArr = true

                var checkGroundtime = true

                var ted = Math.floor(timeDeparture / 100) * 60 + timeDeparture % 100;
                var tea = Math.floor(timeArrival / 100) * 60 + timeArrival % 100;

                for (var i = 0; i < optimizedDataModels.count; i++) {
                    for (var j = 0; j < optimizedDataModels.get(i).flights.count; j++) {
                        if (UnitConverter.compareString(optimizedDataModels.get(i).flights.get(j).name, flightNumber) && isInserted) {
                             messages.displayMessage(qsTr("The flight number was existed.") + translator.tr)

                            return
                        }

                        if (optimizedDataModels.get(i).flights.get(j).name !== "" &&
                                UnitConverter.compareString(optimizedDataModels.get(i).flights.get(j).newAircraft, aircraft)) {
                            if (UnitConverter.compareString(optimizedDataModels.get(i).flights.get(j).name, flightNumber)) {
                                var flightData = { "name": flightNumber, "captain": captain, "coPilot": coPilot, "cabinManager": cabinManager, "cabinAgent1": cabinAgent1,
                                               "cabinAgent2": cabinAgent2, "cabinAgent3": cabinAgent3, "departure": departure, "arrival": arrival, "aircraft": aircraft ,
                                               "oldAircraft": aircraftOld, "timeDeparture": Number(ted), "timeArrival": Number(tea), "status": 0 }

                                optimizedData.push(flightData)
                            } else {
                                optimizedData.push(optimizedDataModels.get(i).flights.get(j))
                            }
                        }
                    }
                }

                for (var i = 0; i < optimizedData.length; i++) {
                    if (Number(optimizedData[i].timeArrival) > maxTimeArrival) {
                        maxTimeArrival = Number(optimizedData[i].timeArrival)
                    }
                }

                for (var i = 0; i < optimizedData.length; i++) {
                    if (minTimeArrival > Number(optimizedData[i].timeArrival)) {
                        minTimeArrival = Number(optimizedData[i].timeArrival)
                    }
                }

                //sort time arrival
                for (var i = 0; i < optimizedData.length - 1 ; i++) {
                    for (var j = i; j < optimizedData.length ; j++ ) {
                        if (Number(optimizedData[i].timeArrival) > Number(optimizedData[j].timeArrival)) {
                            var temp =  optimizedData[i]
                            optimizedData[i] = optimizedData[j]
                            optimizedData[j] = temp
                        }
                    }
                }

                var optimizedLength = optimizedData.length

                for (var i = optimizedLength - 1; i >= 0; i--) {
                    if (Number(ted) > optimizedData[i].timeDeparture) {
                        if (Number(ted) < Number(optimizedData[i].timeArrival)) {
                            checkTed = false

                            break
                        } else if (Number(ted) < Number(optimizedData[i].timeArrival) + Settings.groundTime) {
                            checkGroundtime = false

                            break
                        }

                        if (!UnitConverter.compareString(optimizedData[i].arrival, departure)) {
                            checkDep = false

                            break
                        }

                        if ((i + 1) < optimizedLength && isInserted) {
                            if (!UnitConverter.compareString(optimizedData[i + 1].departure, arrival)) {
                                checkArr = false

                                break
                            }
                        }

                        if ((i + 2) < optimizedLength) {
                            if (Number(tea) > Number(optimizedData[i + 2].timeDeparture)) {
                                checkTea = false

                                break
                            } else if (Number(tea) > Number(optimizedData[i + 2].timeDeparture) - Settings.groundTime) {
                                checkGroundtime = false

                                break
                            }

                            if (!UnitConverter.compareString(optimizedData[i + 2].departure, arrival)) {
                                checkArr = false

                                break
                            }
                        }
                        break
                    }

                    if (Number(ted) < optimizedData[0].timeDeparture) {
                        if (Number(tea) > optimizedData[0].timeDeparture) {
                            checkTea = false

                            break
                        } else if (Number(tea) > optimizedData[0].timeDeparture - Settings.groundTime) {
                            checkGroundtime = false

                            break
                        }

                        if (!UnitConverter.compareString(arrival, optimizedData[0].departure)) {
                            checkArr = false

                            break
                        }
                    } else if (Number(ted) === optimizedData[0].timeDeparture && optimizedLength > 1) {
                        if (Number(tea) > optimizedData[1].timeDeparture) {
                            checkTea = false

                            break
                        } else if (Number(tea) > optimizedData[1].timeDeparture - Settings.groundTime) {
                            checkGroundtime = false

                            break
                        }

                        if (!UnitConverter.compareString(arrival, optimizedData[1].departure)) {
                            checkArr = false

                            break
                        }
                    }
                }

                if (!checkTed) {
                    messages.displayMessage(qsTr("The departure time is invalid.") + translator.tr)

                    return
                }

                if (!checkDep) {

                    messages.displayMessage(qsTr("The departure is invalid.") + translator.tr)

                    return
                }

                if (!checkGroundtime) {
                    messages.displayMessage(qsTr("The ground time is not enough.") + translator.tr)

                    return
                }

                if (!checkTea) {
                    messages.displayMessage(qsTr("The arrival time is invalid.") + translator.tr)

                    return
                }

                if (!checkArr) {
                    messages.displayMessage(qsTr("The arrival is invalid.") + translator.tr)

                    return
                }

                close()

                var flightData = []

                flightData = { "name": flightNumber.toUpperCase(), "CAP": captain, "FO": coPilot, "CM": cabinManager, "CA1": cabinAgent1,
                               "CA2": cabinAgent2, "CA3": cabinAgent3, "DEP": departure.toUpperCase(), "ARR": arrival.toUpperCase(),
                               "AC": aircraft.toUpperCase(), "ACO": aircraftOld.toUpperCase(), "TED": ted, "TEA": tea, "status": 0 }

                flightDialog.updated(flightData, isInserted)
            }
        }
    }

    DFMBanner {
        id: messages
    }

    footer: TabBar {
        id: tabBar
        currentIndex: flightSwipeView.currentIndex

        TabButton {
            text: qsTr("Flight details") + translator.tr

            font.pointSize: AppTheme.textSizeMenu
        }

        TabButton {
            text: qsTr("Crew") + translator.tr

            font.pointSize: AppTheme.textSizeMenu
        }
    }
}
