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
import ScheduleCalculation 1.0
import IOStreams 1.0

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/branding.js" as Branding

import "../sections"
import "../widgets"

Item {
    id: scheduleDialog

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property int parentIndex: Global.parentScheduleIndex

    property alias titleScheduleSection: titleSection

    property var csvAircraftModel

    property var csvAirportModel

    signal built

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
                title: qsTr("Schedules") + translator.emptyString

                buildVisible: true
                settingVisible: true

                buildEnable: txtInputAircraftData.text !== "" && txtInputAirportData.text != ""

                onBuilt: {
                    //Write code calculate here
                    scheduleCalculation.runSchedule(csvAirportModel, csvAircraftModel, Number(txtStartTime.text));

                    scheduleDialog.built()

                    isSplitScheduleView = false

                    swipeView.setCurrentIndex(0)
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

                        text: qsTr("Input aircraft data") + translator.emptyString
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

                        text: qsTr("Browse") + translator.emptyString

                        onClicked: {
                            aircraftSelectDialog.open()
                        }

                        Layout.row: 0
                        Layout.column: 2
                    }

                    Label {
                        id: lblInputFlightData

                        text: qsTr("Input airport data") + translator.emptyString
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

                        text: qsTr("Browse") + translator.emptyString

                        onClicked: {
                            airportSelectDialog.open()
                        }

                        Layout.row: 1
                        Layout.column: 2
                    }

                    Label {
                        id: lblStartTime

                        text: qsTr("Start time") + translator.emptyString
                        font.pointSize: AppTheme.textSizeText
                        verticalAlignment: Text.AlignVCenter

                        Layout.row: 2
                        Layout.column: 0
                    }

                    TextField  {
                        id: txtStartTime

                        Layout.fillWidth: true

                        text: ""
                        placeholderText: qsTr("Enter start time") + translator.emptyString

                        font.pointSize: AppTheme.textSizeText

                        horizontalAlignment: Text.AlignHCenter

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

    FileDialog {
        id: aircraftSelectDialog
        title: qsTr("Select Aircraft Data") + translator.emptyString

        folder: shortcuts.documents
        selectExisting: true
        selectMultiple: false

        nameFilters: [qsTr("CSV File (*.csv)")] + translator.emptyString

        onAccepted: {
            txtInputAircraftData.text = fileUrl
            aircraftReader.source = fileUrl
            csvAircraftModel = aircraftReader.read()
        }
    }

    FileDialog {
        id: airportSelectDialog
        title: qsTr("Select Airport Data") + translator.emptyString

        folder: shortcuts.documents
        selectExisting: true
        selectMultiple: false

        nameFilters: [qsTr("CSV File (*.csv)")] + translator.emptyString

        onAccepted: {
            txtInputAirportData.text = fileUrl
            airportReader.source = fileUrl
            csvAirportModel = airportReader.read()
        }
    }

    DFMBanner {
        id: messages
    }

    onOpen: {
        //open
    }

    onSave: {
        scheduleIostream.write("", "airport", aircraftReader.source, "schedules", path)
        scheduleIostream.write("", "aircraft", aircraftReader.source, "schedules", path)
        scheduleIostream.write("", "startTime", txtStartTime.text, "schedules", path)
    }

    onSaveAs: {
        scheduleIostream.write("", "airport", aircraftReader.source, "schedules", path)
        scheduleIostream.write("", "aircraft", aircraftReader.source, "schedules", path)
        scheduleIostream.write("", "startTime", txtStartTime.text, "schedules", path)
    }
}
