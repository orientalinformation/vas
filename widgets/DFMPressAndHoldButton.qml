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

Image {
    id: container

    property int repeatDelay: 300
    property int repeatDuration: 75
    property bool pressed: false

    signal clicked

    scale: pressed ? 0.9 : 1

    function release() {
        autoRepeatClicks.stop()
        container.pressed = false
    }

    SequentialAnimation on pressed {
        id: autoRepeatClicks
        running: false

        PropertyAction { target: container; property: "pressed"; value: true }
        ScriptAction { script: container.clicked() }
        PauseAnimation { duration: repeatDelay }

        SequentialAnimation {
            loops: Animation.Infinite
            ScriptAction { script: container.clicked() }
            PauseAnimation { duration: repeatDuration }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: autoRepeatClicks.start()
        onReleased: container.release()
        onCanceled: container.release()
    }
}
