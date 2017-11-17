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
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtQuick.Window 2.2

import CSVReader 1.0
import IOStreams 1.0
import DFMFileDialog 1.0

import ScheduleCalculation 1.0

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/branding.js" as Branding
import "../scripts/setting.js" as Settings

import "../sections"
import "../widgets"

Item {
    id: scheduleDialog

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property int parentIndex: Global.parentScheduleIndex

    property alias titleScheduleSection: titleSection

    signal built

    signal newCase()
    signal open(var path)
    signal save(var path)
    signal saveAs(var path)

    ScheduleCalculation {
        id: scheduleCalculation

        onError: messages.displayMessage(msg)
    }

    IOStreams {
        id: scheduleIostream
    }

    ColumnLayout {
        id: columnLayout

        width: parent.width
        height: parent.height

        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            id: columnLayoutTitle
            Layout.fillWidth: true
            anchors.fill: parent

            TitleSection {
                id: titleSection

                index: parentIndex
                currentIndex: 1

                iconSource: "qrc:/das/images/title/schedule.png"
                title: qsTr("Schedules") + translator.tr

                buildVisible: true
                settingVisible: true

                buildEnable: txtInputAircraftData.text !== "" && txtInputAirportData.text != ""

                onBuilt: {
                    if (txtStartTime.text === "") {
                        messages.displayMessage(qsTr("Please input start time") + translator.tr)
                    } else {
                        var csvAircraftModel = aircraftReader.read()
                        var csvAirportModel = airportReader.read()

                        if (csvAircraftModel.length === 0) {
                            txtInputAircraftData.text = ""
                            messages.displayMessage(qsTr("Please select correct data.") + translator.tr)

                            return;
                        }

                        if (csvAirportModel.length > 0) {
                            if (csvAirportModel[0].frequent === 0) {
                                txtInputAirportData.text = ""
                                messages.displayMessage(qsTr("Please select correct data.") + translator.tr)
                                return;
                            }
                        } else {
                            txtInputAirportData.text = ""
                            messages.displayMessage(qsTr("Please select correct data.") + translator.tr)
                            return;
                        }

                        scheduleCalculation.execute(csvAirportModel, csvAircraftModel, Number(txtStartTime.text), Settings.groundTime, Settings.sector, Settings.isDutyTime ? Settings.dutyTime : 999999, Settings.separationTime);

                        scheduleDialog.built()

                        isSplitScheduleView = false

                        swipeView.setCurrentIndex(0)
                    }
                }
            }
        }

        RowLayout {
            anchors.topMargin: 0
            anchors.leftMargin: AppTheme.screenPadding
            anchors.rightMargin: AppTheme.screenPadding

            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: AppTheme.hscale(10)

            Item {
                // vertical spacer item
                Layout.fillHeight: true
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
            }

            Frame {
                id: frameInput

                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: AppTheme.tscale(3)

                rightPadding: AppTheme.headerRightPadding
                leftPadding: AppTheme.headerRightPadding

                topPadding: 0
                bottomPadding: 0

                background: Rectangle {
                    border.color: "transparent"
                    radius: 0
                    color: "#eaeaea"
                }

                GridLayout {
                    rowSpacing: AppTheme.screenPadding
                    columnSpacing: AppTheme.screenPadding

                    anchors.fill: parent

                    Label {
                        id: lblInputACData

                        text: qsTr("Input aircraft data") + translator.tr
                        font.pointSize: AppTheme.textSizeText
                        verticalAlignment: Text.AlignVCenter

                        Layout.row: 0
                        Layout.column: 0
                    }

                    TextField  {
                        id: txtInputAircraftData

                        Layout.fillWidth: true

                        text: ""
                        font.pointSize: AppTheme.textSizeText
                        readOnly: true

                        horizontalAlignment: Text.AlignHCenter

                        Layout.row: 0
                        Layout.column: 1
                    }

                    DFMButton {
                        id: btnInputACData

                        text: qsTr("Browse") + translator.tr

                        onClicked: {
                            aircraftSelectDialog.open("dataPath")
                        }

                        Layout.row: 0
                        Layout.column: 2
                    }

                    Label {
                        id: lblInputFlightData

                        text: qsTr("Input airport data") + translator.tr
                        font.pointSize: AppTheme.textSizeText
                        verticalAlignment: Text.AlignVCenter

                        Layout.row: 1
                        Layout.column: 0
                    }

                    TextField  {
                        id: txtInputAirportData

                        Layout.fillWidth: true

                        text: ""
                        font.pointSize: AppTheme.textSizeText
                        readOnly: true

                        horizontalAlignment: Text.AlignHCenter

                        Layout.row: 1
                        Layout.column: 1
                    }

                    DFMButton {
                        id: btnInputFlightData

                        text: qsTr("Browse") + translator.tr

                        onClicked: {
                            airportSelectDialog.open("dataPath")
                        }

                        Layout.row: 1
                        Layout.column: 2
                    }

                    Label {
                        id: lblStartTime

                        text: qsTr("Start time") + translator.tr
                        font.pointSize: AppTheme.textSizeText
                        verticalAlignment: Text.AlignVCenter

                        Layout.row: 2
                        Layout.column: 0
                    }

                    TextField  {
                        id: txtStartTime

                        Layout.fillWidth: true

                        text: ""
                        placeholderText: qsTr("Enter start time") + translator.tr

                        font.pointSize: AppTheme.textSizeText

                        horizontalAlignment: Text.AlignHCenter

                        validator: IntValidator { bottom:0}

                        Layout.row: 2
                        Layout.column: 1
                    }

                    Item {
                        // vertical spacer item
                        Layout.fillHeight: true
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                        }

                        Layout.row: 3
                        Layout.column: 1
                    }
                }
            }

            Item {
                // vertical spacer item
                Layout.fillHeight: true
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
            }
        }
    }

    CSVReader {
        id: aircraftReader

        flight: false
        aircraft: true
        airport: false

        onError: messages.displayMessage(msg)
    }

    CSVReader {
        id: airportReader

        flight: false
        aircraft: false
        airport: true

        onError: messages.displayMessage(msg)
    }

    DFMFileDialog {
        id: aircraftSelectDialog
        title: qsTr("Select Aircraft Data") + translator.tr

        suffix: ".csv"
        qml: true

        nameFilters: qsTr("CSV File (*.csv)") + translator.tr

        onAccepted: {
            txtInputAircraftData.text = fileUrl
            aircraftReader.source = fileUrl
        }
    }

    DFMFileDialog {
        id: airportSelectDialog
        title: qsTr("Select Airport Data") + translator.tr

        suffix: ".csv"
        qml: true

        nameFilters: qsTr("CSV File (*.csv)") + translator.tr

        onAccepted: {
            txtInputAirportData.text = fileUrl
            airportReader.source = fileUrl
        }
    }

    DFMBanner {
        id: messages
    }

    onNewCase: {
        txtInputAirportData.text = ""
        txtInputAircraftData.text = ""

        txtStartTime.text = ""
    }

    onOpen: {
        var airportPath = scheduleIostream.read("airportPath", "schedules", path)
        var aircraftPath = scheduleIostream.read("aircraftPath", "schedules", path)

        txtStartTime.text = scheduleIostream.read("startTime", "schedules", path)

        txtInputAirportData.text = airportPath
        txtInputAircraftData.text = aircraftPath

        airportReader.source = airportPath
        aircraftReader.source = aircraftPath
    }

    onSave: {
        scheduleIostream.write("airportPath", airportReader.source, "schedules", path)
        scheduleIostream.write("aircraftPath", aircraftReader.source, "schedules", path)

        scheduleIostream.write("startTime", txtStartTime.text, "schedules", path)
    }

    onSaveAs: {
        scheduleIostream.write("airportPath", airportReader.source, "schedules", path)
        scheduleIostream.write("aircraftPath", aircraftReader.source, "schedules", path)

        scheduleIostream.write("startTime", txtStartTime.text, "schedules", path)
    }
}
