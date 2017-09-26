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
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "../theme"

Item {
    id: container

    property alias flightNumber: flightNumber.text
    property alias depAirport: depAirport.text
    property alias arrAirport: arrAirport.text

    property color color: "#444444"
    property int fontSize: AppTheme.textSizeText
    property bool hovered: false

    signal clicked

    width: AppTheme.tscale(200)
    height: AppTheme.tscale(45)

    opacity: hovered ? 1 : 0.95

    scale: hovered ? 1.1 : 1

    Label {
        id: depAirport

        font.pointSize: AppTheme.textSizeTiny

        anchors.right: flightNumber.left
        anchors.bottom: parent.bottom

        padding: AppTheme.tscale(5)

        color: container.color
    }

    Label {
        id: flightNumber
        font.pointSize: AppTheme.textSizeText
        anchors.centerIn: parent
        padding: AppTheme.tscale(3)

        color: "#ffffff"

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

        background: Rectangle {
            anchors.fill: flightNumber
            color: container.color
            opacity: 0.7
        }
    }

    Label {
        id: arrAirport

        font.pointSize: AppTheme.textSizeTiny

        anchors.left: flightNumber.right
        anchors.bottom: parent.bottom

        padding: AppTheme.tscale(5)

        color: container.color
    }
}
