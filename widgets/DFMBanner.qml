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

Loader {
    id: messages

    function displayMessage(message) {
        messages.source = "";
        messages.source = Qt.resolvedUrl("DFMMessageBox.qml");
        messages.item.message = message;
    }

    width: AppTheme.hscale(500)
    anchors.top: parent.bottom
    anchors.bottomMargin: 0
    anchors.horizontalCenter: parent.horizontalCenter

    z: 1

    onLoaded: {
        messages.item.state = "landscape";
        timer.running = true
        messages.state = "show"
    }

    Timer {
        id: timer

        interval: 2000

        onTriggered: {
            messages.state = ""
        }
    }

    states: [
        State {
            name: "show"

            AnchorChanges {
                target: messages

                anchors {
                    bottom: parent.bottom
                    top: undefined
                }
            }

            PropertyChanges {
                target: messages
                anchors.bottomMargin: AppTheme.vscale(0)
            }
        }
    ]

    transitions: Transition {
        AnchorAnimation {
            easing.type: Easing.OutQuart;
            duration: 300
        }
    }
}
