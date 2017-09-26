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
import QtQuick.Controls 2.2 as QQC2

import "../theme"

PathView {
    id: circularView

    signal launched(string page)

    property string currentTitle: currentItem ? currentItem.text : ""

    readonly property int cX: AppTheme.tscale(100)
    readonly property int cY: AppTheme.tscale(105)
    readonly property int itemSize: AppTheme.tscale(50)
    readonly property int size: AppTheme.tscale(250)
    readonly property int radius: AppTheme.tscale(size / 3 - itemSize / 3)

    snapMode: PathView.SnapToItem

    model: ListModel {
        ListElement {
            title: qsTr("Home")
            icon: "qrc:/das/images/title/home.png"
            page: "qrc:/screens/HomeScreen.qml"
        }

        ListElement {
            title: qsTr("Schedules")
            icon: "qrc:/das/images/title/schedule.png"
            page: "qrc:/screens/ScheduleScreen.qml"
        }

        ListElement {
            title: qsTr("Re-Schedules")
            icon: "qrc:/das/images/title/departure.png"
            page: "qrc:/screens/ReScheduleScreen.qml"
        }

        ListElement {
            title: qsTr("Settings")
            icon: "qrc:/das/images/title/setting.png"
            page: "qrc:/screens/SettingScreen.qml"
        }

        ListElement {
            title: qsTr("Help")
            icon: "qrc:/das/images/title/help.png"
            page: ""
        }

        ListElement {
            title: qsTr("About")
            icon: "qrc:/das/images/title/about.png"
            page: "qrc:/screens/AboutScreen.qml"
        }
    }

    delegate: QQC2.AbstractButton {
        width: circularView.itemSize
        height: circularView.itemSize

        text: model.title
        opacity: PathView.itemOpacity
        padding: AppTheme.screenPadding

        contentItem: Image {
            source: model.icon
            fillMode: Image.Pad
            sourceSize.width: parent.availableWidth
            sourceSize.height: parent.availableHeight
        }

        background: Rectangle {
            radius: width / 2
            border.width: AppTheme.tscale(3)
            border.color: parent.PathView.isCurrentItem ? AppTheme.colorQtPrimGreen : AppTheme.colorQtGray4
        }

        onClicked: {
            if (PathView.isCurrentItem) {
                circularView.launched(Qt.resolvedUrl(page))
            } else {
                circularView.currentIndex = index
            }
        }
    }

    path: Path {
        startX: circularView.cX
        startY: circularView.cY

        PathAttribute {
            name: "itemOpacity"
            value: 1.0
        }

        PathLine {
            x: circularView.cX + circularView.radius
            y: circularView.cY
        }

        PathAttribute {
            name: "itemOpacity"
            value: 0.7
        }

        PathArc {
            x: circularView.cX - circularView.radius
            y: circularView.cY
            radiusX: circularView.radius
            radiusY: circularView.radius
            useLargeArc: true
            direction: PathArc.Clockwise
        }

        PathAttribute {
            name: "itemOpacity"
            value: 0.5
        }

        PathArc {
            x: circularView.cX + circularView.radius
            y: circularView.cY
            radiusX: circularView.radius
            radiusY: circularView.radius
            useLargeArc: true
            direction: PathArc.Clockwise
        }

        PathAttribute {
            name: "itemOpacity"
            value: 0.3
        }
    }
}
