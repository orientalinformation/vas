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
import QtQuick.Controls 2.0 as QQC2

import "../theme"

QQC2.AbstractButton {
    id: button

    property int edge: Qt.LeftEdge
    property alias imageSource: image.source

    contentItem: Image {
        id: image
        fillMode: Image.Pad

        sourceSize {
            width: AppTheme.tscale(40)
            height: AppTheme.tscale(40)
        }
    }

    background: Rectangle {
        width: button.width * 4
        height: width
        radius: height / 2

        anchors.verticalCenter: button.horizontalCenter
        anchors.left: edge === Qt.RightEdges ? button.left : undefined
        anchors.right: edge === Qt.LeftEdge ? button.right : undefined

        color: AppTheme.colorQtGray2
    }

    transform: Translate {
        Behavior on x {
            NumberAnimation { }
        }

        x: enabled ? 0 : edge === Qt.LeftEdge ? -button.width : button.width
    }
}
