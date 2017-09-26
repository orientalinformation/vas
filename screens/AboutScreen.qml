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

import "../theme"

import "../scripts/global.js" as Global
import "../scripts/branding.js" as Branding

import "../sections"

Item {
    id: aboutDialog

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property int parentIndex: Global.parentAboutIndex

    property alias titleAboutSection: titleSection

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
                currentIndex: 4

                iconSource: "qrc:/das/images/title/about.png"
                title: qsTr("About") + translator.emptyString

                settingVisible: false
            }
        }

        Frame {
            id: frameContent
            Layout.fillWidth: true
            Layout.fillHeight: true

            topPadding: AppTheme.vscale(10)
            bottomPadding: 0

            leftPadding: AppTheme.hscale(150)
            rightPadding: AppTheme.hscale(150)

            background: Rectangle {
                border.color: "transparent"
                radius: 0
                color: "#eaeaea"
            }

            ColumnLayout {
                anchors.fill: parent

                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: AppTheme.tscale(10)

                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        id: imgBranchLogo
                        anchors.horizontalCenter: parent.horizontalCenter

                        text: "Vietnam Aviation Academy"
                        font.pointSize: AppTheme.tscale(55)
                        color: "#00aaff"
                        font.weight: Font.Bold
                    }

                    RowLayout {
                        id: groupSocial

                        anchors.horizontalCenter: parent.horizontalCenter

                        spacing: AppTheme.hscale(10)

                        Item {
                            // horizontal spacer item
                            Layout.fillWidth: true

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                            } // to visualize the spacer
                        }

                        Image {
                            source: "qrc:/das/images/social/share.png"

                            Layout.preferredWidth: AppTheme.tscale(24)
                            Layout.preferredHeight: AppTheme.tscale(24)
                        }

                        Image {
                            source: "qrc:/das/images/social/twitter.png"

                            Layout.preferredWidth: AppTheme.tscale(24)
                            Layout.preferredHeight: AppTheme.tscale(24)

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: 0
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Qt.openUrlExternally("https://twitter.com/vaa")
                                }
                            }
                        }

                        Image {
                            source: "qrc:/das/images/social/linkedin.png"

                            Layout.preferredWidth: AppTheme.tscale(24)
                            Layout.preferredHeight: AppTheme.tscale(24)

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: 0
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Qt.openUrlExternally("https://vi.linkedin.com/company/vaa")
                                }
                            }
                        }

                        Image {
                            source: "qrc:/das/images/social/facebook.png"

                            Layout.preferredWidth: AppTheme.tscale(24)
                            Layout.preferredHeight: AppTheme.tscale(24)

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: 0
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Qt.openUrlExternally("https://www.facebook.com/vaa/")
                                }
                            }
                        }

                        Image {
                            source: "qrc:/das/images/social/youtube.png"

                            Layout.preferredWidth: AppTheme.tscale(24)
                            Layout.preferredHeight: AppTheme.tscale(24)

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: 0
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Qt.openUrlExternally("https://www.youtube.com")
                                }
                            }
                        }

                        Item {
                            // horizontal spacer item
                            Layout.fillWidth: true

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                            } // to visualize the spacer
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: AppTheme.tscale(30)

                    Image {
                        id: imgProductIcon

                        source: "qrc:/das/images/product.png"

                        Layout.preferredWidth: AppTheme.tscale(400)
                        Layout.preferredHeight: AppTheme.tscale(200)

                        fillMode: Image.PreserveAspectFit
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        spacing: AppTheme.tscale(10)

                        Label {
                            id: lblProductName
                            text: qsTr("%1 %2").arg(Branding.VER_APPNAME_STR).arg(Branding.APP_VERSION_SHORT) + translator.emptyString
                            font.weight: Font.Bold
                            font.pointSize: AppTheme.textSizeTitle
                            Layout.fillWidth: true
                        }

                        Row {
                            Layout.fillWidth: true

                            Label {
                                text: qsTr("Website: ") + translator.emptyString
                                font.pointSize: AppTheme.textSizeText
                            }

                            Label {
                                id: lblWebsite
                                text: qsTr("<a href=\"" + Branding.VER_PRODUCTDOMAIN_STR + "\">" + Branding.VER_PRODUCTDOMAIN_STR + "</a>")
                                font.pointSize: AppTheme.textSizeText
                                Layout.fillWidth: true

                                MouseArea {
                                    id: mouseAreaWebsite
                                    anchors.fill: parent
                                    anchors.margins: 0
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        Qt.openUrlExternally(Branding.VER_PRODUCTDOMAIN_STR)
                                    }
                                }
                            }
                        }

                        Row {
                            Layout.fillWidth: true

                            Label {
                                text: qsTr("For any further information, please send an email to: ") + translator.emptyString
                                wrapMode: Text.WordWrap
                                font.pointSize: AppTheme.textSizeText
                            }

                            Label {
                                id: lblEmail
                                text: qsTr("<a href=\"mailto:info@vaa.edu.vn\">info@vaa.edu.vn</a>")
                                wrapMode: Text.WordWrap
                                font.pointSize: AppTheme.textSizeText
                                Layout.fillWidth: true

                                MouseArea {
                                    id: mouseAreaMail
                                    anchors.fill: parent
                                    anchors.margins: 0
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        Qt.openUrlExternally("mailto:contact@dfm-engineering.com")
                                    }
                                }
                            }
                        }
                    }
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

                    Label {
                        id: lblLicensing

                        text: "<a href=\"" + Branding.VER_PRODUCTDOMAIN_STR + "/licensing\">" + qsTr("License Information") + translator.emptyString + "</a>"
                        color: "#04aade"
                        font.pointSize: AppTheme.textSizeText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        MouseArea {
                            id: mouseAreaLicensing
                            anchors.fill: parent
                            anchors.margins: 0
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                Qt.openUrlExternally(Branding.VER_PRODUCTDOMAIN_STR + "/licensing")
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

                    Label {
                        id: lblTermSerices

                        text: "<a href=\"" + Branding.VER_PRODUCTDOMAIN_STR + "/terms-of-use\">" + qsTr("End-User Rights") + translator.emptyString + "</a>"
                        color: "#04aade"
                        font.pointSize: AppTheme.textSizeText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        MouseArea {
                            id: mouseAreaTermService
                            anchors.fill: parent
                            anchors.margins: 0
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                Qt.openUrlExternally(Branding.VER_PRODUCTDOMAIN_STR + "/terms-of-use")
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

                    Label {
                        id: lblPolicy

                        text: "<a href=\"" + Branding.VER_PRODUCTDOMAIN_STR + "/privacy-policy\">" + qsTr("Privacy Policy") + translator.emptyString + "</a>"
                        color: "#04aade"
                        font.pointSize: AppTheme.textSizeText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        MouseArea {
                            id: mouseAreaPolicy
                            anchors.fill: parent
                            anchors.margins: 0
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                Qt.openUrlExternally(Branding.VER_PRODUCTDOMAIN_STR + "/privacy-policy")
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

                ColumnLayout {
                    id: columnLayout1

                    spacing: AppTheme.tscale(10)
                    Layout.fillWidth: true

                    Label {
                        id: lblWarning
                        text: qsTr("Warning: <i>This computer program is protected by copyright law and international treaties. Unauthorized reproduction or distribution of this program, or any portion of it, may result in severe civil or criminal penalties, and will be prosecuted to the maximum extent possible under the law.</i>") + translator.emptyString
                        font.pointSize: AppTheme.textSizeText
                        horizontalAlignment: Text.AlignJustify
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Row {
                        Layout.fillWidth: true

                        Label {
                            text: qsTr("%1 and the %2 logos are registered trademarks of the ").arg(Branding.VER_APPNAME_STR).arg(Branding.VER_APPNAME_STR) + translator.emptyString
                            font.pointSize: AppTheme.textSizeText
                        }

                        Label {
                            id: lblTrademark
                            text: "<a href=\"" + Branding.VER_COMPANYDOMAIN_STR + "\">" + Branding.VER_PUBLISHER_STR + "</a>."
                            font.pointSize: AppTheme.textSizeText
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true

                            MouseArea {
                                id: mouseAreaTrademark
                                anchors.fill: parent
                                anchors.margins: 0
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Qt.openUrlExternally(Branding.VER_COMPANYDOMAIN_STR)
                                }
                            }
                        }
                    }

                    Label {
                        id: lblCopyright
                        text: qsTr("Copyright %1").arg(Branding.VER_LEGALCOPYRIGHT_STR) + translator.emptyString
                        font.pointSize: AppTheme.textSizeText
                        Layout.fillWidth: true
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                    }
                }

                Item {
                    // vertical spacer item
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
