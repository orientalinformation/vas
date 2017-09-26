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
import QtGraphicalEffects 1.0

import "../theme"

ToolButton {
    id: myButton

    property bool isActive: index == bottomMenuIndex

    Layout.alignment: Qt.AlignHCenter
    focusPolicy: Qt.NoFocus

    implicitHeight: AppTheme.vscale(56)
    implicitWidth: (bottomMenuBar.width - AppTheme.hscale(62)) / (bottomMenuModel.length)

    Column {
        spacing: 0
        topPadding: 0

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: AppTheme.tscale(24)
            height: AppTheme.tscale(24)

            Image {
                id: contentImage

                width: AppTheme.tscale(24)
                height: AppTheme.tscale(24)

                verticalAlignment: Image.AlignTop
                anchors.horizontalCenter: parent.horizontalCenter

                source: "qrc:/das/images/title/" + modelData.icon
                opacity: isActive ? bottomMenuBar.activeOpacity : bottomMenuBar.inactiveOpacity
            }

            ColorOverlay {
                id: colorOverlay
                visible: myButton.isActive
                anchors.fill: contentImage
                source: contentImage
                color: "#00aaff"
            }
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: modelData.name + translator.emptyString
            opacity: isActive ? 1.0 : 0.7
            color: isActive ? "#00aaff" : "#424242"
            font.pointSize: AppTheme.textSizeTiny
        }
    }

    onClicked: {
        bottomMenuIndex = index
    }
}
