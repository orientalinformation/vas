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

import "../theme"

Item {
    id: banner

    property alias message : messageText.text

    height: AppTheme.vscale(50)

    Rectangle {
        id: background

        anchors.fill: banner
        color: "#333333"
        smooth: true
        opacity: 0.6
    }

    Text {
        id: messageText
        anchors.fill: banner

        font.pointSize: AppTheme.textSizeText
        renderType: Text.QtRendering

        width: AppTheme.hscale(150)
        height: AppTheme.vscale(40)

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap

        color: "#df3105"
    }

    states: [
        State {
            name: "portrait"

            PropertyChanges {
                target: banner
                height: AppTheme.vscale(100)
            }
        },

        State {
            name: "landscape"

            PropertyChanges {
                target: banner
                height: AppTheme.vscale(50)
            }
        }
    ]

    MouseArea {
        anchors.fill: parent

        onClicked: {
            messages.state = ""
        }
    }
}
