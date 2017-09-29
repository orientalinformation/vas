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
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.1

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/setting.js" as Settings
import "../scripts/branding.js" as Branding

import "../dialogs"
import "../sections"

Item {
    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property int parentIndex: Global.parentSettingIndex

    LanguageDialog {
        id: languageDialog
    }

    StatusColorDialog {
        id: statusColorDialog
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

            HeaderSection {
                id: header
            }

            TitleSection {
                id: titleSection

                index: parentIndex
                currentIndex: 3

                iconSource: "qrc:/das/images/title/setting.png"
                title: qsTr("Setting") + translator.emptyString

                settingVisible: false
            }
        }

        Frame {
            id: frameContent

            width: parent.width
            height: parent.height

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

            RowLayout {
                anchors.topMargin: 0
                anchors.fill: parent
                spacing: AppTheme.screenPadding

                Frame {
                    id: frameCalculation
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Layout.preferredWidth: parent.width / 2

                    background: Rectangle {
                        color: "#dddddd"
                        border.color: "transparent"
                        radius: 0
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        anchors.fill: parent

                        ColumnLayout {
                            Layout.fillWidth: true
                            anchors.horizontalCenter: parent.horizontalCenter

                            RowLayout {
                                Layout.fillWidth: true
                                anchors.horizontalCenter: parent.horizontalCenter

                                Label {
                                    id: lblTitleTask
                                    text: qsTr("Calculation") + translator.emptyString
                                    color: "#00aaff"
                                    font.weight: Font.Bold
                                    font.bold: true
                                    font.pointSize: AppTheme.textSizeTitle
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: AppTheme.lineHeight
                                color: "#00aaff"
                            }
                        }

                        GridLayout {
                            rowSpacing: AppTheme.screenPadding
                            columnSpacing: AppTheme.hscale(20)

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Label {
                                id: lblGroundTime

                                text: qsTr("Ground time") + translator.emptyString
                                font.pointSize: AppTheme.textSizeText
                                verticalAlignment: Text.AlignVCenter

                                Layout.row: 0
                                Layout.column: 0
                            }

                            TextField  {
                                id: txtGroundTime

                                Layout.fillWidth: true

                                text: "45"
                                font.pointSize: AppTheme.textSizeText
                                placeholderText: qsTr("Enter ground time") + translator.emptyString

                                horizontalAlignment: Text.AlignHCenter

                                validator: IntValidator{ bottom: 1 }

                                Layout.row: 0
                                Layout.column: 1

                                onTextChanged: {
                                    Settings.groundTime = Number.fromLocaleString(Qt.locale("en_US"), text)
                                }
                            }

                            Label {
                                id: lblGroundTimeUnit

                                text: qsTr("minutes") + translator.emptyString
                                font.pointSize: AppTheme.textSizeText
                                verticalAlignment: Text.AlignVCenter

                                Layout.row: 0
                                Layout.column: 2
                            }

                            Label {
                                id: lblSector

                                text: qsTr("Sector") + translator.emptyString
                                font.pointSize: AppTheme.textSizeText
                                verticalAlignment: Text.AlignVCenter

                                Layout.row: 1
                                Layout.column: 0
                            }

                            Slider {
                                id: sectorSlider

                                property bool hoverButton: false

                                Layout.fillWidth: true

                                from: 1
                                to: 50
                                value: 5
                                stepSize: 1

                                hoverEnabled: true

                                snapMode: Slider.SnapOnRelease

                                onHoveredChanged: {
                                    hoverButton = !hoverButton
                                }

                                onMoved: {
                                    value = Math.round(value)
                                }

                                onValueChanged: {
                                    Settings.sector = value
                                }

                                background: Rectangle {
                                    x: sectorSlider.leftPadding
                                    y: sectorSlider.topPadding + sectorSlider.availableHeight / 2 - height / 2

                                    implicitWidth: AppTheme.hscale(200)
                                    implicitHeight: AppTheme.vscale(8)

                                    width: sectorSlider.availableWidth
                                    height: implicitHeight

                                    radius: AppTheme.tscale(5)

                                    color: "#444444"

                                    Rectangle {
                                        width: sectorSlider.visualPosition * parent.width
                                        height: parent.height

                                        color: "#0aafe9"
                                        radius: AppTheme.tscale(5)
                                    }
                                }

                                handle: Rectangle {
                                    x: sectorSlider.leftPadding + sectorSlider.visualPosition * (sectorSlider.availableWidth - width)
                                    y: sectorSlider.topPadding + sectorSlider.availableHeight / 2 - height / 2

                                    implicitWidth: AppTheme.tscale(24)
                                    implicitHeight: AppTheme.tscale(24)

                                    radius: AppTheme.tscale(12)

                                    color: sectorSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                                    border.color: "#bdbebf"

                                    ToolTip.visible: sectorSlider.hoverButton
                                    ToolTip.text: sectorSlider.value
                                }

                                Layout.row: 1
                                Layout.column: 1

                                Layout.columnSpan: 2
                            }

                            Label {
                                id: lblDutyTime

                                text: qsTr("Duty time") + translator.emptyString
                                font.pointSize: AppTheme.textSizeText
                                verticalAlignment: Text.AlignVCenter

                                Layout.row: 2
                                Layout.column: 0
                            }

                            Switch {
                                id: btnDutyTime

                                checked: false

                                onCheckedChanged: {
                                    Settings.isDutyTime = checked
                                }

                                indicator: Rectangle {
                                    implicitWidth: AppTheme.switchImplicitWidth
                                    implicitHeight: AppTheme.switchImplicitHeight
                                    x: btnDutyTime.leftPadding
                                    y: parent.height / 2 - height / 2
                                    radius: AppTheme.switchRadius
                                    color: btnDutyTime.checked ? "#00aaff" : "#656565"
                                    border.color: btnDutyTime.checked ? "#00aaff" : "#cccccc"

                                    Rectangle {
                                        x: btnDutyTime.checked ? parent.width - width : 0
                                        width: AppTheme.switchHeight
                                        height: AppTheme.switchHeight
                                        radius: AppTheme.switchRadius
                                        color: btnDutyTime.down ? "#cccccc" : "#ffffff"
                                        border.color: btnDutyTime.checked ? "#00aaff" : "#999999"
                                    }
                                }

                                contentItem: Text {
                                    text: btnDutyTime.checked ? qsTr("Define") : qsTr("Infinite") + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    opacity: enabled ? 1.0 : 0.3
                                    color: "#000000"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: btnDutyTime.indicator.width + btnDutyTime.spacing
                                }

                                Layout.row: 2
                                Layout.column: 1
                                Layout.columnSpan: 2
                            }

                            TextField  {
                                id: txtDutyTime

                                Layout.fillWidth: true

                                text: ""
                                font.pointSize: AppTheme.textSizeText
                                placeholderText: qsTr("Enter duty time") + translator.emptyString

                                horizontalAlignment: Text.AlignHCenter

                                validator: IntValidator{ bottom: 1 }

                                visible: btnDutyTime.checked

                                onTextChanged: {
                                    Settings.dutyTime = Number.fromLocaleString(Qt.locale("en_US"), text)
                                }

                                Layout.row: 3
                                Layout.column: 1
                            }

                            Label {
                                id: lblDutyTimeUnit

                                text: qsTr("minutes") + translator.emptyString
                                font.pointSize: AppTheme.textSizeText
                                verticalAlignment: Text.AlignVCenter

                                visible: btnDutyTime.checked

                                Layout.row: 3
                                Layout.column: 2
                            }

                            Item {
                                // spacer item
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                } // to visualize the spacer

                                Layout.row: 4
                                Layout.column: 1
                            }
                        }
                    }
                }

                Frame {
                    id: frameApplication

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Layout.preferredWidth: parent.width / 2

                    background: Rectangle {
                        color: "#dddddd"
                        border.color: "transparent"
                        radius: 0
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        anchors.fill: parent

                        ColumnLayout {
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            anchors.horizontalCenter: parent.horizontalCenter

                            RowLayout {
                                Layout.fillWidth: true
                                anchors.horizontalCenter: parent.horizontalCenter

                                Label {
                                    id: lblTitleTool
                                    text: qsTr("Application") + translator.emptyString
                                    color: "#00aaff"
                                    font.weight: Font.Bold
                                    font.bold: true
                                    font.pointSize: AppTheme.textSizeTitle
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: AppTheme.lineHeight
                                color: "#00aaff"
                            }
                        }

                        ColumnLayout {
                            spacing: AppTheme.vscale(20)

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            RowLayout {
                                Layout.fillWidth: true

                                spacing: AppTheme.screenPadding

                                Image {
                                    id: iconLanguage
                                    source: "qrc:/das/images/settings/translate.png"
                                }

                                Label {
                                    id: lblLanguage
                                    text: qsTr("Language") + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter

                                    MouseArea {
                                        id: mouseAreaLanguage
                                        anchors.fill: parent
                                        anchors.margins: 0
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            var strCurrentLanguage = Settings.language

                                            if (strCurrentLanguage === "vi_VN") {
                                                languageDialog.currentLanguage = 1
                                            } else {
                                                languageDialog.currentLanguage = 0
                                            }

                                            languageDialog.open()
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                spacing: AppTheme.screenPadding

                                Image {
                                    source: "qrc:/das/images/settings/guide.png"
                                }

                                Label {
                                    id: lblUserGuide
                                    text: qsTr("User Guide") + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter

                                    MouseArea {
                                        id: mouseAreaUserGuide
                                        anchors.fill: parent
                                        anchors.margins: 0
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            //Qt.openUrlExternally("file:///" + applicationDir + "/VDHelpOnline/index.html")
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                spacing: AppTheme.screenPadding

                                Image {
                                    source: "qrc:/das/images/settings/palette.png"
                                }

                                Label {
                                    id: lblStatusColor
                                    text: qsTr("Flight Status Color") + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter

                                    MouseArea {
                                        id: mouseAreaStatusColor
                                        anchors.fill: parent
                                        anchors.margins: 0
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            statusColorDialog.open()
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                spacing: AppTheme.screenPadding

                                Image {
                                    source: "qrc:/das/images/settings/telephone.png"
                                }

                                Label {
                                    id: lblCustomerSupport

                                    text: qsTr("Customer Support") + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter

                                    MouseArea {
                                        id: mouseAreaCustomerSupport
                                        anchors.fill: parent
                                        anchors.margins: 0
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            Qt.openUrlExternally("tel:(+84)911959505")
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                spacing: AppTheme.screenPadding

                                Image {
                                    source: "qrc:/das/images/settings/update.png"
                                }

                                Label {
                                    id: lblUpdate

                                    text: qsTr("Update") + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter

                                    MouseArea {
                                        id: mouseAreaUpdate
                                        anchors.fill: parent
                                        anchors.margins: 0
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            //
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                spacing: AppTheme.screenPadding

                                Label {
                                    id: lblVersion

                                    text: qsTr("Version: %1").arg(Branding.APP_VERSION_SHORT) + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter

                                    enabled: false
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true

                                spacing: AppTheme.screenPadding

                                Image {
                                    source: "qrc:/das/images/settings/about.png"
                                }

                                Label {
                                    id: lblAbout

                                    text: qsTr("About") + translator.emptyString
                                    font.pointSize: AppTheme.textSizeText
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter

                                    MouseArea {
                                        id: mouseAreaAbout
                                        anchors.fill: parent
                                        anchors.margins: 0
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            Global.parentAboutIndex = swipeView.currentIndex

                                            swipeView.setCurrentIndex(4)
                                        }
                                    }
                                }
                            }

                            Item {
                                // spacer item
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                } // to visualize the spacer
                            }
                        }
                    }
                }
            }
        }
    }
}
