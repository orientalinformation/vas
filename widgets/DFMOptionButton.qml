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
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

import "../theme"

Item {
    id: container

    property bool isActive: false

    property int fontSize: AppTheme.textSizeText
    property alias text: labelText.text
    property bool hovered: false

    property alias sourceImage: contentImage.source

    signal clicked

    opacity: hovered ? 1 : 0.85

    scale: hovered ? 1.25 : 1

    width: AppTheme.tscale(72)
    height: AppTheme.tscale(72)

    Column {
        spacing: AppTheme.vscale(8)
        topPadding: 0

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: AppTheme.tscale(64)
            height: AppTheme.tscale(64)

            Image {
                id: contentImage

                width: AppTheme.tscale(64)
                height: AppTheme.tscale(64)

                verticalAlignment: Image.AlignTop
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ColorOverlay {
                id: colorOverlay
                visible: container.isActive
                anchors.fill: contentImage
                source: contentImage
                color: "#00aaff"
            }
        }

        Label {
            id: labelText
            anchors.horizontalCenter: parent.horizontalCenter
            color: isActive ? "#00aaff" : "#424242"
            font.pointSize: AppTheme.textSizeTiny
        }
    }

    MouseArea {
        anchors {
            fill: parent
            leftMargin: 0
            topMargin: 0
            rightMargin: 0
            bottomMargin: 0
        }

        hoverEnabled: true

        onEntered: hovered = true
        onExited: hovered = false

        onClicked: container.clicked()
        cursorShape: Qt.PointingHandCursor
    }
}
