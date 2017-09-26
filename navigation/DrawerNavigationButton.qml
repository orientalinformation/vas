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

ItemDelegate {
    id: button

    property bool isActive: false //index === navigationIndex

    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    focusPolicy: Qt.NoFocus

    height: AppTheme.vscale(48)

    width: drawerVD.width

    // Material.buttonPressColor
    Rectangle {
        visible: button.isActive// && highlightActiveNavigationButton
        height: button.height
        width: button.width
        color: Material.listHighlightColor
    }

    Row {
        spacing: 0
        topPadding: 0

        leftPadding: AppTheme.hscale(16)
        rightPadding: AppTheme.hscale(16)

        anchors.verticalCenter: parent.verticalCenter

        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: AppTheme.hscale(24 + 32)
            height: AppTheme.vscale(24)

            Image {
                id: icon
                width: AppTheme.hscale(24)
                height: AppTheme.vscale(24)

                horizontalAlignment: Image.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/das/images/menu/" + modelData.icon
                opacity: isActive ? drawerVD.activeOpacity : drawerVD.inactiveOpacity
            }

            ColorOverlay {
                id: colorOverlay
                visible: button.isActive
                anchors.fill: icon
                source: icon
                color: "#00aaff"
            }
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.name + translator.emptyString
            opacity: 0.87
            color: isActive ? "#00aaff" : "#000000"
            font.pointSize: AppTheme.textSizeMenu
            font.weight: Font.Medium
        }
    }

    onClicked: {
        navigationIndex = index
        navigationBar.close()
    }
}
