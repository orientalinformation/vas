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

Dialog {
    id: flightDialog

    property bool isInserted: false

    property var aFlightInserted

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

    signal updated(var isUpdated)

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
                                    text: qsTr("A/C") + translator.emptyString

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 0
                                    Layout.column: 0
                                }

                                TextField {
                                    id: txtAC
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 0
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblFN
                                    text: qsTr("FN") + translator.emptyString
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

                                    readOnly: isReadOnly

                                    Layout.row: 1
                                    Layout.column: 1

                                    visible: isInserted
                                }

                                Label {
                                    id: lblACOld
                                    text: qsTr("A/C old") + translator.emptyString

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

                                    readOnly: isReadOnly

                                    Layout.row: 2
                                    Layout.column: 1

                                    visible: !isInserted
                                }

                                Label {
                                    id: lblDEP
                                    text: qsTr("DEP") + translator.emptyString

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 3
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtDEP
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 3
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblARR
                                    text: qsTr("ARR") + translator.emptyString

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 4
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtARR
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 4
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblETD
                                    text: qsTr("ETD") + translator.emptyString

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 5
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtETD
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

                                    Layout.row: 5
                                    Layout.column: 1
                                }

                                Label {
                                    id: lblETA
                                    text: qsTr("ETA") + translator.emptyString

                                    font.pointSize: AppTheme.textSizeText
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.row: 6
                                    Layout.column: 0
                                }

                                TextField  {
                                    id: txtETA
                                    Layout.fillWidth: true

                                    font.pointSize: AppTheme.textSizeText

                                    readOnly: isReadOnly

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
                                    text: qsTr("CAP") + translator.emptyString

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
                                    text: qsTr("FO") + translator.emptyString

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
                                    text: qsTr("CM") + translator.emptyString

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
                                    text: qsTr("CA 1") + translator.emptyString

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
                                    text: qsTr("CA 2") + translator.emptyString

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
                                    text: qsTr("CA 3") + translator.emptyString

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
        text: qsTr("Update") + translator.emptyString

        property bool hoverButton: false

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.rightMargin: AppTheme.hscale(15)

        ToolTip.visible: hoverButton
        ToolTip.text: isInserted ? qsTr("Save values") + translator.emptyString : qsTr("Update values") + translator.emptyString

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
                close();

                aFlightInserted = {  "name": flightNumber, "CAP": captain, "FO": coPilot, "CM": cabinManager, "CA1": cabinAgent1,
                                     "CA2": cabinAgent2, "CA3": cabinAgent3, "DEP": departure, "ARR": arrival, "AC": aircraft ,
                                     "ACO": "", "TED": Number(timeDeparture), "TEA": Number(timeArrival), "status": 0 }

                flightDialog.updated(isInserted)
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: flightSwipeView.currentIndex

        TabButton {
            text: qsTr("Flight details") + translator.emptyString

            font.pointSize: AppTheme.textSizeMenu
        }

        TabButton {
            text: qsTr("Crew") + translator.emptyString

            font.pointSize: AppTheme.textSizeMenu
        }
    }
}
