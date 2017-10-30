/****************************************************************************
**
** Copyright (C) 2017 Oriental.
** Contact: dongtp@dfm-engineering.com
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
import QtQuick.Controls.Styles 1.4

import "../theme"
import "../widgets"

Frame {
    property var airportModel: airportComboboxModel
    property var aircraftArrivalLimitModel: aircraftModel

    property var  airportSelectedModel: airportSelectedModel

    Layout.fillHeight: true
    Layout.fillWidth: true
    spacing: AppTheme.tscale(3)

    rightPadding: AppTheme.headerRightPadding
    leftPadding: AppTheme.headerRightPadding

    topPadding: 0
    bottomPadding: AppTheme.vscale(10)

    background: Rectangle {
        border.color: "transparent"
        radius: 0
        color: "#eaeaea"
    }

    RowLayout {
        spacing: AppTheme.screenPadding

        anchors.fill: parent

        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            spacing: AppTheme.screenPadding

            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: listAC

                Layout.fillHeight: true

                width:  AppTheme.hscale(305)

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

                            width: AppTheme.hscale(300)

                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    z: 3
                }

                model: ListModel {
                    id: aircraftModel
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

                            width: listAC.headerItem.itemAt(0).width

                            background: Rectangle  {
                                color: "white"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked:  {
                                    listAC.currentIndex = row
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

            RowLayout {
                Layout.fillWidth: true

                Item {
                    // horizontal spacer item
                    Layout.fillWidth: true
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                    }
                }

                ToolButton {
                    id: btnAdd

                    property bool hoverButton: false
                    scale: hoverButton ? 1.25 : 1

                    ToolTip.visible: hoverButton
                    ToolTip.text: qsTr("Add") + translator.tr

                    Layout.preferredWidth: AppTheme.tscale(40)
                    Layout.preferredHeight: AppTheme.tscale(40)

                    contentItem: Image {
                        fillMode: Image.PreserveAspectFit

                        source: "qrc:/das/images/tools/add.png"
                    }

                    MouseArea {
                        id: mouseAreaAdd
                        anchors.fill: parent
                        anchors.margins: 0
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: parent.hoverButton = true

                        onExited: parent.hoverButton = false

                        onClicked: {
                            // Funtion checked aircraft exits in model
                            function appendModel(aircraft) {
                                for (var i = 0; i < aircraftModel.count; i++) {
                                    if (aircraftModel.get(i).name === aircraft ) {
                                        messages.displayMessage(qsTr("The aircraft already exists.") + translator.tr)
                                        return
                                    }
                                }

                                aircraftModel.append( { name: aircraft } )
                            }

                            if (currentAircraft == "") {
                                messages.displayMessage(qsTr("Please select an aircraft.") + translator.tr)
                                return
                            }

                            appendModel(currentAircraft)
                            listAC.currentIndex = aircraftModel.count - 1
                        }
                    }
                }

                ToolButton {
                    id: btnRemove

                    property bool hoverButton: false
                    scale: hoverButton ? 1.25 : 1

                    enabled: aircraftModel.count > 0

                    ToolTip.visible: hoverButton
                    ToolTip.text: qsTr("Remove") + translator.tr

                    Layout.preferredWidth: AppTheme.tscale(40)
                    Layout.preferredHeight: AppTheme.tscale(40)

                    contentItem: Image {
                        fillMode: Image.PreserveAspectFit

                        source: "qrc:/das/images/tools/remove.png"
                    }

                    MouseArea {
                        id: mouseAreaQuit
                        anchors.fill: parent
                        anchors.margins: 0
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: parent.hoverButton = true

                        onExited: parent.hoverButton = false

                        onClicked: {
                            aircraftModel.remove(listAC.currentIndex)
                        }
                    }
                }

                Item {
                    // horizontal spacer item
                    Layout.fillWidth: true
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                    }
                }
            }
        }

        ColumnLayout {
            spacing: AppTheme.screenPadding

            Layout.fillWidth: true
            Layout.fillHeight: true

            Component {
                id: airportDelegate

                Item {
                    id: delegateItem

                    width: listARR.width
                    height: AppTheme.vscale(40)

                    clip: true

                    Row {
                        anchors.centerIn: parent

                        spacing: AppTheme.hscale(8)

                        Label {
                            text: name
                            font.pointSize: AppTheme.textSizeText

                            Layout.fillWidth: true
                            width: AppTheme.hscale(265)

                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter

                            padding: AppTheme.tscale(5)

                            anchors.verticalCenter: parent.verticalCenter

                            background: Rectangle {
                                color: "white"
                            }
                        }

                        Image {
                            source: "qrc:/das/images/actions/list-delete.png"

                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                anchors.fill: parent;
                                onClicked: airportSelectedModel.remove(index)
                            }
                        }
                    }
                }
            }

            ListView {
                id: listARR

                Layout.fillHeight: true

                width: AppTheme.hscale(300)

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
                        id: repeaterArr
                        model: [qsTr("Airport code") + translator.tr ]

                        Label {
                            text: modelData
                            font.pointSize: AppTheme.textSizeSmall
                            padding: AppTheme.screenPadding

                            background: Rectangle {
                                color: "silver"
                            }

                            width: AppTheme.hscale(300)

                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    z: 3
                }

                model: ListModel {
                    id: airportSelectedModel
                }

                delegate: airportDelegate

                ScrollIndicator.horizontal: ScrollIndicator { }
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: qsTr("Airport list") + translator.tr

                    font.pointSize: AppTheme.textSizeText
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }

                ComboBox {
                    id: cboAirport

                    Layout.fillWidth: true

                    font.pointSize: AppTheme.textSizeSmall

                    model: ListModel {
                        id: airportComboboxModel
                    }

                    delegate: ItemDelegate {
                        width: cboAirport.width

                        contentItem: Text {
                            text: modelData
                            color: "#000000"
                            font: cboAirport.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        highlighted: cboAirport.highlightedIndex === index
                    }

                    background: Rectangle {
                        implicitWidth: AppTheme.comboBoxImplicitWidth
                        implicitHeight: AppTheme.comboBoxImplicitHeight
                        border.color: cboAirport.pressed ? "#00aaff" : "#000000"
                        color: cboAirport.pressed ? "#00aaff" : "#ffffff"
                        border.width: cboAirport.visualFocus ? 2 : 1
                        radius: AppTheme.comboBoxRadius
                    }

                    onCurrentTextChanged: {
                        function appendModel(airport) {
                            for (var i = 0; i < airportSelectedModel.count; i++) {
                                if (airportSelectedModel.get(i).name === airport ) {
                                    messages.displayMessage(qsTr("The airport already exists.") + translator.tr)
                                    return
                                }
                            }

                            airportSelectedModel.append( { "name": currentText } )
                        }

                        appendModel(currentText)
                    }

                    onModelChanged: {
                        cboAirport.currentIndex = 0
                    }
                }
            }
        }
    }
}
