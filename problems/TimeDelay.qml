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

    property var timeDelayModel: timeDelayModel

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

        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            id: timeDelay

            Layout.fillWidth: true
            Layout.fillHeight: true

            anchors.horizontalCenter: parent.horizontalCenter
            contentWidth: headerItem.width

            clip: true

            flickableDirection: Flickable.HorizontalAndVerticalFlick

            headerPositioning: ListView.OverlayHeader

            boundsBehavior: Flickable.StopAtBounds

            header: Row {
                spacing: 2

                function itemAt(index) { return repeater.itemAt(index) }

                Repeater {
                    id: repeater

                    model: [qsTr("Aircraft Name") + translator.emptyString, qsTr("Time") + translator.emptyString ]

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

                z: 3
            }

            model: ListModel {
                id: timeDelayModel
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

                        padding: 0

                        anchors.verticalCenter: parent.verticalCenter

                        width: AppTheme.hscale(305)

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked:  {
                                timeDelay.currentIndex = row
                            }
                        }
                    }

                    TextField {
                        id: txtTimeDelay
                        Layout.fillWidth: true
                        width: AppTheme.hscale(305)
                        padding: 0

                        font.pointSize: AppTheme.textSizeText
                        horizontalAlignment: Text.AlignHCenter

                        validator: IntValidator { bottom:0; top: 2359}

                        text: ""


                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked:  {
                                timeDelay.currentIndex = row
                                txtTimeDelay.forceActiveFocus()
                            }
                        }

                        onTextChanged: {
                            timeDelayModel.set(row, { "time": txtTimeDelay.text })
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
                ToolTip.text: qsTr("Add") + translator.emptyString

                Layout.preferredWidth: AppTheme.tscale(40)
                Layout.preferredHeight: AppTheme.tscale(40)

                contentItem: Image {
                    fillMode: Image.PreserveAspectFit

                    source: "qrc:/das/images/tools/add.png"
                }

                MouseArea {
                    id: addMouseArea
                    anchors.fill: parent
                    anchors.margins: 0

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: parent.hoverButton = true
                    onExited: parent.hoverButton = false

                    onClicked: {
                        // Funtion checked aircraft exits in model
                        function appendModel(aircraft) {
                            for (var i = 0; i < timeDelayModel.count; i++) {
                                if (timeDelayModel.get(i).name === aircraft ) {
                                     messages.displayMessage(qsTr("The aircraft already exists.") + translator.emptyString)
                                    return
                                }
                            }

                            timeDelayModel.append( { name: aircraft } )
                            timeDelay.currentIndex += 1
                        }

                        if (currentAircraft != "") {
                            appendModel( currentAircraft )
                        } else {
                            messages.displayMessage(qsTr("Please select an aircraft.") + translator.emptyString)
                        }
                    }
                }
            }

            ToolButton {
                id: btnRemove

                property bool hoverButton: false
                scale: hoverButton ? 1.25 : 1

                ToolTip.visible: hoverButton
                ToolTip.text: qsTr("Remove") + translator.emptyString

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

                    enabled: timeDelayModel.count > 0

                    onEntered: parent.hoverButton = true

                    onExited: parent.hoverButton = false

                    onClicked: {
                        timeDelayModel.remove( timeDelay.currentIndex )
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

