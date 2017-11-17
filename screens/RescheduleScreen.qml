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

import RescheduleCalculation 1.0

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/branding.js" as Branding
import "../scripts/setting.js" as Settings

import "../sections"
import "../widgets"

import "../problems"

Item {
    id: rescheduleDialog

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property int parentIndex: Global.parentScheduleIndex

    property alias titleReScheduleSection: titleSection

    property var csvFlightList: []

    property alias airportModel: arrivalLimitedProblem.airportModel

    property alias aircraftArrivalLimitModel: arrivalLimitedProblem.aircraftArrivalLimitModel

    property alias airportSelectedModel: arrivalLimitedProblem.airportSelectedModel

    property alias dayDelayModel: dayDelayProblem.dayDelayModel

    property alias timeDelayModel: timeDelayProblem.timeDelayModel

    property alias timeLimitedModel: timeLimitedProblem.timeLimitedModel

    property var currentProblem
    property int optionSelectedIndex: -1

    signal built(var inputPath)

    signal newCase()
    signal open(var path)
    signal save(var path)
    signal saveAs(var path)

    IOStreams {
       id: rescheduleIostream
    }

    Component.onCompleted: {
        currentProblem = dayDelayProblem
        optionSelectedIndex = 0
    }

    onCurrentProblemChanged: {
        stackView.clear()

        stackView.push(currentProblem)
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
                currentIndex: 2

                iconSource: "qrc:/das/images/title/departure.png"
                title: qsTr("Rescheduled") + translator.tr

                buildVisible: true
                settingVisible: true

                buildEnable: txtInputData.text !== ""

                onBuilt: {
                    //Write code calculate here
                    var dayDelayList = []
                    var timeDelayList = []
                    var timeLimitedList = []
                    var airportList = []
                    var aircraftArrivalLimitedList = []

                    function checkInputTimeValid(timeDelay, timeLimit) {
                        for (var i = 0; i < timeDelay.count; i++) {
                            if (timeDelayModel.get(i).time === "") {
                                return false
                            }
                        }

                        for (var i = 0; i < timeLimit.count; i++) {
                            if (timeLimit.get(i).time === "") {
                                return false
                            }
                        }

                        return true
                    }

                    for (var i = 0 ; i < dayDelayModel.count ; i++) {
                       dayDelayList.push(dayDelayModel.get(i).name)
                    }

                    for (var i = 0; i < timeDelayModel.count; i++) {
                        timeDelayList.push(timeDelayModel.get(i))
                    }

                    for (var i = 0; i < timeLimitedModel.count; i++) {
                        timeLimitedList.push(timeLimitedModel.get(i))
                    }

                    for (var i = 0; i < aircraftArrivalLimitModel.count; i++) {
                        aircraftArrivalLimitedList.push(aircraftArrivalLimitModel.get(i).name)
                    }

                    for (var i = 0; i < airportSelectedModel.count; i++) {
                        airportList.push(airportSelectedModel.get(i).name)
                    }
                    if (checkInputTimeValid(timeDelayModel, timeLimitedModel)) {
                        rescheduleCalculation.execute(dayDelayList, timeDelayList, aircraftArrivalLimitedList, airportList,
                                                            timeLimitedList, Settings.groundTime, Settings.sector, Settings.isDutyTime ? Settings.dutyTime : 999999, csvFlightList)

                        rescheduleDialog.built(flightReader.source)

                        isSplitScheduleView = true

                        swipeView.setCurrentIndex(0)
                    } else {
                        messages.displayMessage(qsTr("You must enter all input time.") + translator.tr)
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

                Layout.fillHeight: true

                Layout.preferredWidth: rescheduleDialog.width / 9 * 3.9

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

                            text: qsTr("Input data") + translator.tr
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

                            text: qsTr("Browse") + translator.tr

                            onClicked: {
                                fileSelectDialog.open("dataPath")
                            }
                        }
                    }

                    Label {
                        id: lblAircraftTitle
                        text: qsTr("Aircraft list") + translator.tr
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
                                model: [qsTr("Aircraft name") + translator.tr ]

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

                Layout.preferredWidth: rescheduleDialog.width / 9 * 3.9

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
                        text: qsTr("Airline Day Delay") + translator.tr
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

                Layout.preferredWidth: rescheduleDialog.width / 9

                spacing: AppTheme.tscale(3)

                topPadding: 0
                bottomPadding: 0
                leftPadding: 0
                rightPadding: 0

                background: Rectangle {
                    border.color: "transparent"
                    radius: 0
                    color: "#eaeaea"
                }

                ColumnLayout {
                    spacing: AppTheme.screenPadding

                    anchors.fill: parent

                    DFMOptionButton {
                        sourceImage: "qrc:/das/images/schedules/day.png"
                        text: qsTr("Day Delay") + translator.tr

                        anchors.horizontalCenter: parent.horizontalCenter

                        isActive: optionSelectedIndex === 0

                        onClicked: {
                            if (currentProblem !== dayDelayProblem) {
                                lblSettingTitle.text = qsTr("Airline Day Delay") + translator.tr

                                currentProblem = dayDelayProblem

                                optionSelectedIndex = 0
                            }
                        }
                    }

                    DFMOptionButton {
                        sourceImage: "qrc:/das/images/schedules/time.png"
                        text: qsTr("Time Delay") + translator.tr

                        anchors.horizontalCenter: parent.horizontalCenter

                        isActive: optionSelectedIndex === 1

                        onClicked: {
                            if (currentProblem !== timeDelayProblem) {
                                lblSettingTitle.text = qsTr("Airline Time Delay") + translator.tr

                                currentProblem = timeDelayProblem

                                optionSelectedIndex = 1
                            }
                        }
                    }

                    DFMOptionButton {
                        sourceImage: "qrc:/das/images/schedules/arrival.png"
                        text: qsTr("Arrival Limited") + translator.tr

                        anchors.horizontalCenter: parent.horizontalCenter

                        isActive: optionSelectedIndex === 2

                        onClicked: {
                            if (currentProblem !== arrivalLimitedProblem) {
                                lblSettingTitle.text = qsTr("Airline Arrival Limited") + translator.tr

                                currentProblem = arrivalLimitedProblem

                                optionSelectedIndex = 2
                            }
                        }
                    }

                    DFMOptionButton {
                        sourceImage: "qrc:/das/images/schedules/itinerary.png"
                        text: qsTr("Time Limited") + translator.tr

                        anchors.horizontalCenter: parent.horizontalCenter

                        isActive: optionSelectedIndex === 3

                        onClicked: {
                            if (currentProblem !== timeLimitedProblem) {
                                lblSettingTitle.text = qsTr("Airline Time Limited") + translator.tr

                                currentProblem = timeLimitedProblem

                                optionSelectedIndex = 3
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

        onSuccessfull: {
            numberFlightUnchanged = numberUnchanged
            numberAircarftUnchanged = numberAircarft
            numberFlightCancel = numberCancel
            totalTimeDelay = totalTime
            numberFlightDelay = numberDelay
            maximumTimeDelay = maximumTime
        }
    }

    DFMFileDialog {
        id: fileSelectDialog
        title: qsTr("Select input data") + translator.tr

        suffix: ".csv"
        qml: true

        nameFilters: qsTr("CSV File (*.csv)") + translator.tr

        onAccepted: {
            txtInputData.text = fileUrl
            flightReader.source = fileUrl
            csvFlightList = flightReader.read()
            listAircraft.currentIndex = -1

            airportModel.clear()
            rescheduleModel.clear()

            if (csvFlightList.length === 0) {
                txtInputData.text = ""
                messages.displayMessage(qsTr("Please select correct data.") + translator.tr)
                return
            }

            for (var i = 0; i < csvFlightList.length; i++) {
                appendModel(airportModel, csvFlightList[i].ARR)
                appendModel(rescheduleModel, csvFlightList[i].AC)
            }
        }
    }

    DFMBanner {
        id: messages
    }

    onNewCase: {
        txtInputData.text = ""

        csvFlightList = []

        rescheduleModel.clear()

        dayDelayModel.clear()
        timeDelayModel.clear()

        aircraftArrivalLimitModel.clear()

        airportModel.clear()
        airportSelectedModel.clear()

        timeLimitedModel.clear()
    }

    onOpen: {
        var rescheduleList = []
        var arrivalLimitSelected  = []

        var dayDelayList = []
        var timeDelayList = []

        var aircraftArrivalLimitedList = []
        var airportList = []

        var timeLimitedList = []

        // Log info
        numberFlightUnchanged = Number(rescheduleIostream.read("numberFlightUnchanged", "reschedules", path))
        numberAircarftUnchanged = Number(rescheduleIostream.read("numberAircarftUnchanged",  "reschedules", path))
        numberFlightCancel = Number(rescheduleIostream.read("numberFlightCancel",  "reschedules", path))
        totalTimeDelay = Number(rescheduleIostream.read("totalTimeDelay", "reschedules", path))
        numberFlightDelay = Number(rescheduleIostream.read("numberFlightDelay", "reschedules", path))
        maximumTimeDelay = Number(rescheduleIostream.read("maximumTimeDelay", "reschedules", path))

        var urlInput = rescheduleIostream.read("path", "reschedules", path)

        dayDelayList = rescheduleIostream.readData("problem1", "reschedules", path)

        timeDelayList = rescheduleIostream.readObject("problem2", "reschedules", path)

        arrivalLimitSelected = rescheduleIostream.readData("problem3AP", "reschedules", path)
        aircraftArrivalLimitedList = rescheduleIostream.readData("problem3AC", "reschedules", path)

        timeLimitedList = rescheduleIostream.readObject("problem4", "reschedules", path)

        rescheduleList = rescheduleIostream.readData("availableAC", "reschedules", path)
        airportList = rescheduleIostream.readData("availableAP", "reschedules", path)

        csvFlightList = rescheduleIostream.readObject("inputFlights", "reschedules", path)

        txtInputData.text = urlInput

        for (var i = 0; i < rescheduleList.length; i++) {
            appendModel(rescheduleModel, rescheduleList[i])
        }

        for (var i = 0; i < dayDelayList.length; i++) {
            appendModel(dayDelayModel, dayDelayList[i])
        }

        for (var i = 0; i < aircraftArrivalLimitedList.length; i++) {
            appendModel(aircraftArrivalLimitModel, aircraftArrivalLimitedList[i])
        }

        for (var i = 0; i < airportList.length; i++) {
            appendModel(airportModel, airportList[i])
        }

        for (var i = 0; i < arrivalLimitSelected.length; i++) {
            appendModel(airportSelectedModel, arrivalLimitSelected[i])
        }

        for (var i = 0; i < timeDelayList.length; i++) {
            timeDelayModel.append({ name: timeDelayList[i].name, time: Number(timeDelayList[i].time) })
        }

        for (var i = 0; i < timeLimitedList.length; i++) {
            timeLimitedModel.append( { name: timeLimitedList[i].name, time: Number(timeLimitedList[i].time) })
        }
    }

    onSave: {
        var codes = getData()
        // Log info
        rescheduleIostream.write("numberFlightUnchanged", numberFlightUnchanged.toString(), "reschedules", path)
        rescheduleIostream.write("numberAircarftUnchanged", numberAircarftUnchanged.toString(), "reschedules", path)
        rescheduleIostream.write("numberFlightCancel", numberFlightCancel.toString(), "reschedules", path)
        rescheduleIostream.write("totalTimeDelay", totalTimeDelay.toString(), "reschedules", path)
        rescheduleIostream.write("numberFlightDelay", numberFlightDelay.toString(), "reschedules", path)
        rescheduleIostream.write("maximumTimeDelay", maximumTimeDelay.toString(), "reschedules", path)

        rescheduleIostream.write("path", txtInputData.text, "reschedules", path)

        rescheduleIostream.write("problem1", codes[0], "reschedules", path)

        rescheduleIostream.writeData("problem2", codes[1], "reschedules", path)

        rescheduleIostream.write("problem3AC", codes[2], "reschedules", path)
        rescheduleIostream.write("problem3AP", codes[3], "reschedules", path)

        rescheduleIostream.writeData("problem4", codes[4], "reschedules", path)

        rescheduleIostream.write("availableAC", codes[5], "reschedules", path)
        rescheduleIostream.write("availableAP", codes[6], "reschedules", path)

        rescheduleIostream.writeObject2("inputFlights", csvFlightList, "reschedules", path)
    }

    onSaveAs: {
        var codes = getData()
        // Log info
        rescheduleIostream.write("numberFlightUnchanged", numberFlightUnchanged.toString(), "reschedules", path)
        rescheduleIostream.write("numberAircarftUnchanged", numberAircarftUnchanged.toString(), "reschedules", path)
        rescheduleIostream.write("numberFlightCancel", numberFlightCancel.toString(), "reschedules", path)
        rescheduleIostream.write("totalTimeDelay", totalTimeDelay.toString(), "reschedules", path)
        rescheduleIostream.write("numberFlightDelay", numberFlightDelay.toString(), "reschedules", path)
        rescheduleIostream.write("maximumTimeDelay", maximumTimeDelay.toString(), "reschedules", path)

        rescheduleIostream.write("path", txtInputData.text, "reschedules", path)

        rescheduleIostream.write("problem1", codes[0], "reschedules", path)

        rescheduleIostream.writeData("problem2", codes[1], "reschedules", path)

        rescheduleIostream.write("problem3AC", codes[2], "reschedules", path)
        rescheduleIostream.write("problem3AP", codes[3], "reschedules", path)

        rescheduleIostream.writeData("problem4", codes[4], "reschedules", path)

        rescheduleIostream.write("availableAC", codes[5], "reschedules", path)
        rescheduleIostream.write("availableAP", codes[6], "reschedules", path)

        rescheduleIostream.writeObject2("inputFlights", csvFlightList, "reschedules", path)
    }

    function getData() {
        var problem1Data = []
        var problem2Data = []

        var problem3Data1 = []
        var problem3Data2 = []

        var problem4Data = []

        var rescheduleList = []
        var arrivalLimitSelected = []

        for (var i = 0; i < rescheduleModel.count; i++) {
            rescheduleList.push(rescheduleModel.get(i).name)
        }

        for (var i = 0; i < airportModel.count; i++) {
            arrivalLimitSelected.push(airportModel.get(i).name)
        }

        for (var i = 0 ; i < dayDelayModel.count ; i++) {
           problem1Data.push(dayDelayModel.get(i).name)
        }

        for (var i = 0; i < timeDelayModel.count; i++) {
            problem2Data.push(timeDelayModel.get(i))
        }

        for (var i = 0; i < timeLimitedModel.count; i++) {
            problem4Data.push(timeLimitedModel.get(i))
        }

        for (var i = 0; i < aircraftArrivalLimitModel.count; i++) {
            problem3Data1.push(aircraftArrivalLimitModel.get(i).name)
        }

        for (var i = 0; i < airportSelectedModel.count; i++) {
            problem3Data2.push(airportSelectedModel.get(i).name)
        }

        return [problem1Data, problem2Data, problem3Data1, problem3Data2, problem4Data, rescheduleList, arrivalLimitSelected]
    }
}
