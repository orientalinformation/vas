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
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.1

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/branding.js" as Branding

Frame {
    id: frameHeader

    property int index: -1
    property int currentIndex: -1

    property string backIconSource: "qrc:/das/images/back.png"
    property string homeIconSource: "qrc:/das/images/header/home.png"
    property string iconSource: ""
    property string printIconSource: "qrc:/das/images/header/print.png"
    property string settingIconSource : "qrc:/das/images/header/settings_button.png"
    property string quitIconSource: "qrc:/das/images/header/shut_down.png"

    property string buildIconSource: "qrc:/das/images/actions/build.png"

    property string title: ""

    property bool backVisible: true
    property bool homeVisible: true
    property bool iconVisible: true
    property bool printVisible: false
    property bool settingVisible: true
    property bool quitVisible: true

    property bool buildVisible: false

    property bool titleInCenter: false

    property bool buildEnable: false

    signal built
    signal printed

    leftPadding: AppTheme.titleHorizontalPadding
    rightPadding: AppTheme.titleHorizontalPadding
    topPadding: AppTheme.titleVerticalPadding
    bottomPadding: AppTheme.titleVerticalPadding

    Layout.fillWidth: true

    Material.foreground: "white"

    background: Rectangle {
        border.color: "transparent"
        color: "#00aaff"
        radius: 0
    }

    RowLayout {
        anchors.fill: parent
        spacing: AppTheme.screenPadding

        ToolButton {
            id: btnBack

            visible: backVisible

            property bool hoverButton: false

            ToolTip.visible: hoverButton
            ToolTip.text: qsTr("Back") + translator.emptyString

            Layout.preferredWidth: AppTheme.tscale(42)
            Layout.preferredHeight: AppTheme.tscale(42)

            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: backIconSource

                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: "#000000"
                }
            }

            MouseArea {
                id: mouseAreaBack
                anchors.fill: parent
                anchors.margins: 0
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: parent.hoverButton = true

                onExited: parent.hoverButton = false

                onClicked: {
                    swipeView.setCurrentIndex(index)
                }
            }
        }

        ToolButton {
            id: btnHome

            visible: homeVisible

            property bool hoverButton: false

            ToolTip.visible: hoverButton
            ToolTip.text: qsTr("Home") + translator.emptyString

            Layout.preferredWidth: AppTheme.tscale(36)
            Layout.preferredHeight: AppTheme.tscale(36)

            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: homeIconSource
            }

            MouseArea {
                id: mouseAreaHome
                anchors.fill: parent
                anchors.margins: 0
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: parent.hoverButton = true

                onExited: parent.hoverButton = false

                onClicked: {
                    swipeView.setCurrentIndex(0)
                }
            }
        }

        Image {
            id: lblIcon
            visible: iconVisible
            source: iconSource

            fillMode: Image.PreserveAspectFit

            Layout.preferredWidth: AppTheme.tscale(24)
            Layout.preferredHeight: AppTheme.tscale(24)
        }

        Label {
            id: lblTitle
            text: title

            color: "#ffffff"

            font.weight: Font.Bold
            font.bold: true
            font.pointSize: AppTheme.textSizeTitleSmall

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            anchors.horizontalCenter: titleInCenter ? parent.horizontalCenter : undefined
        }

        Item {
            // horizontal spacer item
            Layout.fillWidth: true
            Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
        }

        ToolButton {
            id: btnPrint

            visible: printVisible

            property bool hoverButton: false

            ToolTip.visible: hoverButton
            ToolTip.text: qsTr("Print") + translator.emptyString

            Layout.preferredWidth: AppTheme.tscale(36)
            Layout.preferredHeight: AppTheme.tscale(36)

            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: printIconSource
            }

            MouseArea {
                id: mouseAreaPrint
                anchors.fill: parent
                anchors.margins: 0
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: parent.hoverButton = true

                onExited: parent.hoverButton = false

                onClicked: {
                    // Write code export PDF file
                    frameHeader.printed()
                }
            }
        }

        ToolButton {
            id: btnBuild

            visible: buildVisible

            enabled: buildEnable

            property bool hoverButton: false

            ToolTip.visible: hoverButton
            ToolTip.text: qsTr("Build") + translator.emptyString

            Layout.preferredWidth: AppTheme.tscale(36)
            Layout.preferredHeight: AppTheme.tscale(36)

            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: buildIconSource
            }

            MouseArea {
                id: mouseAreaBuild
                anchors.fill: parent
                anchors.margins: 0
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: parent.hoverButton = true

                onExited: parent.hoverButton = false

                onClicked: {
                    frameHeader.built()
                }
            }
        }

        ToolButton {
            id: btnSetting

            visible: settingVisible

            property bool hoverButton: false

            ToolTip.visible: hoverButton
            ToolTip.text: qsTr("Settings") + translator.emptyString

            Layout.preferredWidth: AppTheme.tscale(36)
            Layout.preferredHeight: AppTheme.tscale(36)

            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: settingIconSource
            }

            MouseArea {
                id: mouseAreaSetting
                anchors.fill: parent
                anchors.margins: 0
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: parent.hoverButton = true

                onExited: parent.hoverButton = false

                onClicked: {
                    Global.parentSettingIndex = currentIndex

                    swipeView.setCurrentIndex(3)
                }
            }
        }

        ToolButton {
            id: btnQuit

            visible: quitVisible

            property bool hoverButton: false

            ToolTip.visible: hoverButton
            ToolTip.text: qsTr("Quit") + translator.emptyString

            Layout.preferredWidth: AppTheme.tscale(36)
            Layout.preferredHeight: AppTheme.tscale(36)

            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: quitIconSource
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
                    quitMessageDialog.visible = true
                }
            }
        }
    }

    MessageDialog {
        id: quitMessageDialog
        title: qsTr("%1").arg(Branding.VER_PRODUCTNAME_STR) + translator.emptyString
        text: qsTr("Are you sure you want to quit this application?") + translator.emptyString
        icon: StandardIcon.Warning
        standardButtons: StandardButton.No | StandardButton.Ok

        onAccepted: {
            Qt.quit()
        }
    }
}
