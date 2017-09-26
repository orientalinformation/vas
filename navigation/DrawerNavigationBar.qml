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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import "../theme"

import "../scripts/branding.js" as Branding

Drawer {
    id: drawerVD

    property alias navigationButtons: navigationButtonRepeater
    property real activeOpacity: 0.87
    property real inactiveOpacity: 0.56

    property bool highlightActiveNavigationButton : false

    width: Math.min(_mainWindow.width, _mainWindow.height) / 3

    height: _mainWindow.height

    z: 1

    leftPadding: 0

    Flickable {
        contentHeight: myButtons.height
        anchors.fill: parent
        clip: true
        interactive: false

        ColumnLayout {
            id: myButtons
            focus: false

            anchors.left: parent.left
            anchors.right: parent.right

            spacing: 0

            Item {
                anchors.left: parent.left
                anchors.right: parent.right
                height: AppTheme.vscale(120)

                Rectangle {
                    anchors.fill: parent
                    color: "#00aaff"
                }

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: AppTheme.vscale(56)

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: AppTheme.hscale(16)
                        rightPadding: AppTheme.hscale(16)

                        Label {
                            text: Branding.VER_APPNAME_STR
                            font.weight: Font.Medium
                            color: "#ffffff"

                            Layout.fillWidth: true
                            opacity: 0.87
                        }

                        Label {
                            text: "@VietnamAviation"
                            color: "#ffffff"

                            Layout.fillWidth: true
                            opacity: 0.87

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    Qt.openUrlExternally("https://twitter.com/vas")
                                }
                            }
                        }
                    }
                }

                Item {
                    // space between content - see google material guide
                    height: AppTheme.tscale(8)
                }

                Item {
                    x: AppTheme.tscale(25)
                    y: AppTheme.tscale(12)

                    Image {
                        id: image

                        property bool rounded: true
                        property bool adapt: false

                        source: "qrc:/das/images/product.png"

                        width: AppTheme.tscale(100)
                        height: AppTheme.tscale(70)

                        fillMode: Image.PreserveAspectFit

                        layer.enabled: rounded

                        layer.effect: OpacityMask {
                            maskSource: Item {
                                width: image.width
                                height: image.height
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: image.adapt ? image.width : Math.min(image.width, image.height)
                                    height: image.adapt ? image.height : width
                                    radius: Math.min(width, height)
                                }
                            }
                        }
                    }
                }
            }

            Item {
                // space between content - see google material guide
                height: AppTheme.tscale(8)
            }

            Repeater {
                id: navigationButtonRepeater
                model: navigationModel

                Loader {
                    Layout.fillWidth: true
                    source: modelData.type
                    active: true
                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
