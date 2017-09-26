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
import RescheduleCalculation 1.0

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/branding.js" as Branding

import "../sections"
import "../widgets"

import "../problems"

Item {
    id: rescheduleDialog

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property int parentIndex: Global.parentScheduleIndex

    property alias titleReScheduleSection: titleSection

    property var csvFlightModel

    property alias airportModel: arrivalLimitedProblem.airportModel

    property alias aircraftArrivalLimitModel: arrivalLimitedProblem.aircraftArrivalLimitModel

    property alias dayDelayModel: dayDelayProblem.dayDelayModel

    property alias timeDelayModel: timeDelayProblem.timeDelayModel

    property alias timeLimitedModel: timeLimitedProblem.timeLimitedModel

    property var actionModel: [
        { "name": qsTr("Airline Day Delay") + translator.emptyString, "title": qsTr("Day Delay") + translator.emptyString, "image": "day.png", "index": 0 },
        { "name": qsTr("Airline Time Delay") + translator.emptyString, "title": qsTr("Time Delay") + translator.emptyString, "image": "time.png", "index": 1 },
        { "name": qsTr("Airline Arrival Limited") + translator.emptyString, "title": qsTr("Arrival Limited") + translator.emptyString, "image": "arrival.png", "index": 2 },
        { "name": qsTr("Airline Time Limited") + translator.emptyString, "title": qsTr("Time Limited") + translator.emptyString, "image": "itinerary.png", "index": 3 },
    ]

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

            HeaderSection {
                id: header
            }

            TitleSection {
                id: titleSection

                index: parentIndex
                currentIndex: 2

                iconSource: "qrc:/das/images/title/departure.png"
                title: qsTr("Rescheduled") + translator.emptyString

                buildVisible: true
                settingVisible: true

                onBuilt: {
                    //Write code calculate here
                    rescheduleCalculation.runReschedule(dayDelayModel.modelData, timeDelayModel, aircraftArrivalLimitModel, airportModel, timeLimitedModel,10, 10, 10, csvFlightModel, "/home/thiennt/Desktop/log.txt")
                    //
                    isSplitScheduleView = true

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

                Layout.fillHeight: true

                Layout.preferredWidth: rescheduleDialog.width / 9 * 4

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

                ColumnLayout {
                    spacing: AppTheme.screenPadding

                    anchors.fill: parent

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: AppTheme.hscale(20)

                        Label {
                            id: lblInputData

                            text: qsTr("Input data") + translator.emptyString
                            font.pointSize: AppTheme.textSizeText
                            verticalAlignment: Text.AlignVCenter
                        }

                        TextField  {
                            id: txtInputData

                            Layout.fillWidth: true

                            text: ""
                            font.pointSize: AppTheme.textSizeText
                            readOnly: true

                            horizontalAlignment: Text.AlignHCenter
                        }

                        DFMButton {
                            id: btnInputData

                            text: qsTr("Browse") + translator.emptyString

                            onClicked: {
                                fileSelectDialog.open()
                            }
                        }
                    }

                    Label {
                        id: lblAircraftTitle
                        text: qsTr("Aircraft list") + translator.emptyString
                        font.pointSize: AppTheme.textSizeText
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: AppTheme.vscale(3)
                        color: "#00aaff"
                    }

                    ListView {
                        id: listAircraft

                        width: AppTheme.hscale(350)
                        Layout.fillHeight: true

                        anchors.horizontalCenter: parent.horizontalCenter

                        contentWidth: headerItem.width

                        clip: true

                        flickableDirection: Flickable.HorizontalAndVerticalFlick

                        headerPositioning: ListView.OverlayHeader

                        boundsBehavior: Flickable.StopAtBounds

                        header: Row {
                            spacing: 1

                            function itemAt(index) { return repeater.itemAt(index) }

                            Repeater {
                                id: repeater
                                model: [qsTr("Aircraft name") + translator.emptyString ]

                                Label {
                                    text: modelData
                                    font.pointSize: AppTheme.textSizeSmall
                                    padding: AppTheme.screenPadding

                                    background: Rectangle {
                                        color: "silver"
                                    }

                                    width: AppTheme.hscale(350)

                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            z: 3
                        }

                        model: ListModel {
                            id: rescheduleModel
                        }

                        delegate: Column {
                            id: delegate

                            property int row: index

                            Row {
                                spacing: 1

                                Label {
                                    text: modelData
                                    font.pointSize: AppTheme.textSizeText

                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter

                                    padding: AppTheme.tscale(5)

                                    anchors.verticalCenter: parent.verticalCenter

                                    width: listAircraft.headerItem.itemAt(0).width

                                    background: Rectangle  {
                                        color: "white"
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked:  {
                                            listAircraft.currentIndex = row
                                            currentAircraft = modelData
                                        }
                                    }
                                }
                            }
                        }

                        highlight: Rectangle {
                            color: "transparent"

                            border.color: "orange"
                            border.width : 2

                            z:2
                        }

                        ScrollIndicator.horizontal: ScrollIndicator { }
                        ScrollIndicator.vertical: ScrollIndicator { }
                    }
                }
            }

            Frame {
                id: frameSetting

                Layout.fillHeight: true

                Layout.preferredWidth: rescheduleDialog.width / 9 * 4

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

                ColumnLayout {
                    anchors.fill: parent

                    spacing: AppTheme.screenPadding

                    Label {
                        id: lblSettingTitle
                        text: qsTr("Airline Day Delay") + translator.emptyString
                        font.pointSize: AppTheme.textSizeText
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillWidth: true
                    }

                    Rectangle {
                        id: rect
                        Layout.fillWidth: true
                        height: AppTheme.vscale(3)
                        color: "#00aaff"
                    }

                    StackView {
                        id: stackView

                        anchors.top : rect.bottom
                        anchors.bottom: parent.bottom

                        anchors.topMargin: AppTheme.vscale(10)
                        anchors.bottomMargin: AppTheme.vscale(5)

                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        clip: true

                        initialItem: dayDelayProblem

                        pushEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to:1
                                duration: 200
                            }
                        }

                        pushExit: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to:0
                                duration: 200
                            }
                        }

                        popEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to:1
                                duration: 200
                            }
                        }

                        popExit: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to:0
                                duration: 200
                            }
                        }
                    }
                }
            }

            Frame {
                id: frameOption

                Layout.fillHeight: true

                Layout.preferredWidth: rescheduleDialog.width / 9 * 0.75

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

                ColumnLayout {
                    spacing: AppTheme.screenPadding

                    anchors.fill: parent

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Repeater {
                        id: listAction
                        anchors.fill: parent

                        clip: true

                        model: actionModel

                        delegate: DFMOptionButton {
                            sourceImage: "qrc:/das/images/schedules/" + modelData.image
                            text: modelData.title

                            anchors.horizontalCenter: parent.horizontalCenter

                            onClicked: {
                                lblSettingTitle.text = modelData.name

                                stackView.pop()

                                if (modelData.index === 1) {
                                    stackView.push(timeDelayProblem)
                                } else if (modelData.index === 2) {
                                    stackView.push(arrivalLimitedProblem)
                                } else if (modelData.index === 3) {
                                    stackView.push(timeLimitedProblem)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function appendModel(model, aircraft) {
        for (var i = 0; i < model.count; i++) {
            if (model.get(i).name === aircraft ) {
                return
            }
        }

        model.append( { name: aircraft } )
    }

    DayDelay {
        id: dayDelayProblem
        visible: false
    }

    TimeDelay {
        id: timeDelayProblem
        visible: false
    }

    ArrivalLimited {
        id: arrivalLimitedProblem
        visible: false
    }

    TimeLimited {
        id: timeLimitedProblem
        visible: false
    }

    CSVReader {
        id: flightReader

        flight: true
        aircraft: false
        airport: false

        onError: messages.displayMessage(msg)
    }

    RescheduleCalculation {
        id: rescheduleCalculation
    }

    FileDialog {
        id: fileSelectDialog
        title: qsTr("Select input data") + translator.emptyString

        folder: shortcuts.documents
        selectExisting: true
        selectMultiple: false

        nameFilters: [qsTr("CSV File (*.csv)")] + translator.emptyString

        onAccepted: {
            txtInputData.text = fileUrl

            flightReader.source = fileUrl
            csvFlightModel = flightReader.read()
            listAircraft.currentIndex = -1


            for (var i = 0; i < csvFlightModel.length; i++) {
                appendModel(airportModel, csvFlightModel[i].ARR)
                appendModel(rescheduleModel, csvFlightModel[i].AC)
            }


        }
    }

    DFMBanner {
        id: messages
    }
}
