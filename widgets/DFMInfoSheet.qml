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

import QtQuick 2.0

import "../theme"

Rectangle {
    id: infoSheet

    width: AppTheme.hscale(470)
    height: AppTheme.vscale(200)

    anchors.verticalCenter: parent.verticalCenter

    property alias unchanged: infoText.unchanged
    property alias aircraftUnchanged: infoText.aircraftUnchanged
    property alias canceled: infoText.canceled
    property alias totalDelay: infoText.totalDelay
    property alias numberDelay: infoText.numberDelay
    property alias maximumDelay: infoText.maximumDelay

    Behavior on opacity { PropertyAnimation {} }

    color: "black"

    Text {
        id: infoText

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        property int unchanged: 0
        property int aircraftUnchanged: 0
        property int canceled: 0
        property int totalDelay: 0
        property int numberDelay: 0
        property int maximumDelay: 0

        font.pointSize: AppTheme.textSizeMenu

        lineHeight: 1.625 * AppTheme.tscale(16)
        lineHeightMode: Text.FixedHeight

        color: "white"

        text: {
              "<p>" + qsTr("Number of unchanged (aircraft and time) flights: ") + translator.tr + unchanged + "</p>"
            + "<p>" + qsTr("Number of unchanged (only aircraft) flights: ") + translator.tr + aircraftUnchanged + "</p>"
            + "<p>" + qsTr("Number of canceled flights: ") + translator.tr + canceled + "</p>"
            + "<p>" + qsTr("Total delayed time: ") + translator.tr + totalDelay + "</p>"
            + "<p>" + qsTr("Number of delayed flights: ") + translator.tr + numberDelay + "</p>"
            + "<p>" + qsTr("Maximum of delayed time: ") + translator.tr + maximumDelay + "</p></br>"
        }
    }
}
