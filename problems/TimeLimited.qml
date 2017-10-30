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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import "../theme"

Frame {

    property var timeLimitedModel: timeLimitedModel

    id: timeLimitedFrame
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

    ColumnLayout {
        spacing: AppTheme.screenPadding

        anchors.fill: parent

        width: parent.width
        height: parent.height

        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            id: timeLimited
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true

            flickableDirection: Flickable.HorizontalAndVerticalFlick

            headerPositioning: ListView.OverlayHeader

            boundsBehavior: Flickable.StopAtBounds

            header: Row {
                spacing: 2

                Repeater {
                    model: [qsTr("Aircraft Name") + translator.tr, qsTr("Time") + translator.tr ]

                    Label {
                        text: modelData
                        font.pointSize: AppTheme.textSizeSmall
                        padding: AppTheme.screenPadding

                        background: Rectangle {
                            color: "silver"
                        }

                        width: AppTheme.hscale(305)

                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            model: ListModel {
                id: timeLimitedModel
            }

            delegate: Column {
                id: delegate

                property int row: index

                Row {
                    spacing: 1

                    Label {
                        text: name

                        padding: AppTheme.screenPadding
                        font.pointSize: AppTheme.textSizeText

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                        width: AppTheme.hscale(305)

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                timeLimited.currentIndex = row
                            }
                        }
                    }

                    TextField {
                        id: txtTimeLimited
                        Layout.fillWidth: true
                        font.pointSize: AppTheme.textSizeText
                        width: AppTheme.hscale(305)
                        horizontalAlignment: Text.AlignHCenter

                        validator: IntValidator { bottom:0; top: 2359}

                        placeholderText: qsTr("Input time...") + translator.tr

                        text: time

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                timeLimited.currentIndex = row
                                txtTimeLimited.forceActiveFocus()
                            }
                        }

                        onTextChanged: {
                            timeLimitedModel.set(row, { time: txtTimeLimited.text} )
                        }
                    }
                }
            }

            highlight: Rectangle {
                color: "transparent"
                border.color: "orange"
                border.width: 2
                z: 2
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
                    anchors.fill: parent
                    anchors.margins: 0

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: parent.hoverButton = true

                    onExited: parent.hoverButton = false

                    // Funtion checked aircraft exits in model
                    function appendIfNotExist(aircraft) {
                        for (var i = 0; i < timeLimitedModel.count; i++) {
                            if (timeLimitedModel.get(i).name === aircraft ) {
                                messages.displayMessage(qsTr("The aircraft already exists.") + translator.tr)
                                return
                            }
                        }

                        timeLimitedModel.append( { name: aircraft, time: "" } )
                        timeLimited.currentIndex += 1
                    }

                    onClicked: {
                        if (currentAircraft != "") {
                            appendIfNotExist( currentAircraft )
                        } else {
                            messages.displayMessage(qsTr("Please select an aircraft.") + translator.tr)
                        }
                    }
                }
            }

            ToolButton {
                id: btnRemove

                property bool hoverButton: false
                scale: hoverButton ? 1.25 : 1

                ToolTip.visible: hoverButton
                ToolTip.text: qsTr("Remove") + translator.tr

                enabled: timeLimitedModel.count > 0

                Layout.preferredWidth: AppTheme.tscale(40)
                Layout.preferredHeight: AppTheme.tscale(40)

                contentItem: Image {
                    fillMode: Image.PreserveAspectFit

                    source: "qrc:/das/images/tools/remove.png"
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: 0

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: parent.hoverButton = true

                    onExited: parent.hoverButton = false

                    onClicked: {
                        timeLimitedModel.remove( timeLimited.currentIndex )
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
}
