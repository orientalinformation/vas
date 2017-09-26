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
import QtGraphicalEffects 1.0

import "../theme"

Item {
    id: container

    property alias text: labelText.text
    property color tint: "transparent"
    property int fontSize: AppTheme.textSizeText
    property bool hovered: false

    property bool enableButton: true

    signal clicked

    //width: labelText.width + AppTheme.hscale(50)
    //height: labelText.height + AppTheme.vscale(18)

    width: AppTheme.tscale(150)
    height: AppTheme.tscale(45)

    opacity: hovered ? 1 : 0.95

    scale: hovered ? 1.1 : 1

    BorderImage {
        anchors {
            fill: container
            leftMargin: AppTheme.buttonBorderMargin + AppTheme.hscale(2)
            topMargin: AppTheme.buttonBorderMargin + AppTheme.vscale(2)
            rightMargin: AppTheme.buttonBorderMargin
            bottomMargin: AppTheme.buttonBorderMargin
        }

        border.left: AppTheme.buttonBorderPadding
        border.top: AppTheme.buttonBorderPadding
        border.right: AppTheme.buttonBorderPadding
        border.bottom: AppTheme.buttonBorderPadding
    }

    Image {
        id: image
        anchors.fill: parent
        source: "qrc:/das/images/widgets/cardboard.png"
        antialiasing: true
    }

    ColorOverlay {
        anchors.fill: image
        source: image
        color: enableButton ? "#00aaff" : "#cdcdcd"
        opacity: 0.45
    }

    Rectangle {
        anchors.fill: container
        color: container.tint
        visible: container.tint !== ""
        opacity: 0.25
    }

    Text {
        id: labelText
        font.pointSize: AppTheme.textSizeText
        anchors.centerIn: parent
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
