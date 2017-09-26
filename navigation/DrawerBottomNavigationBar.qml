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

Pane {
    id: bottomMenuBar

    Material.elevation: 8

    property real activeOpacity: 0.9
    property real inactiveOpacity: 0.6

    leftPadding: 0
    rightPadding: AppTheme.vscale(56)
    topPadding: 0

    height: AppTheme.vscale(56)

    Layout.fillWidth: true

    RowLayout {
        focus: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 0

        Repeater {
            model: bottomMenuModel

            DrawerBottomNavigationButton {
                id: myButton
            }
        }
    }
}
