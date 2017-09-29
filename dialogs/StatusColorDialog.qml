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
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtQuick.Window 2.2

import "../theme"

import "../sections"
import "../scripts/setting.js" as Settings

Dialog {
    id: colorDialog

    focus: true
    modal: true

    width: _mainWindow.width / 4 * 0.7
    height: _mainWindow.height / 5 * 1.3

    x: (_mainWindow.width - width) / 2
    y: (_mainWindow.height - height) / 2

    padding: AppTheme.screenPadding

    property var colorModel: [
        { "type": qsTr("Unchanged") + translator.emptyString, "color": "#444444" },
        { "type": qsTr("Only Delay Day") + translator.emptyString, "color": "#4f51d8" },
        { "type": qsTr("Only Delay Time") + translator.emptyString, "color": "#eab71a" },
        { "type": qsTr("Delay Date") + translator.emptyString, "color": "#df522e" },
    ]

    ColumnLayout {
        anchors.fill: parent

        Repeater {
            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: model.modelData.type

                    font.pointSize: AppTheme.textSizeText
                    Layout.fillWidth: true
                }

                Item {
                    // horizontal spacer item
                    Layout.fillWidth: true
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                    }
                }

                Rectangle {
                    width: 50
                    height: 30

                    color: model.modelData.color
                }
            }

            model: colorModel
            focus: true
        }
    }
}
