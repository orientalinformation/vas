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

pragma Singleton

import QtQml 2.2
import QtQuick 2.9

QtObject
{
    id: root

    readonly property real refScreenWidth: 1600
    readonly property real refScreenHeight: 1024

    readonly property real contentScaleFactor: screenDpi / 96;

    function dp(value) {
        return Math.round(value * contentScaleFactor)
    }

    function sp(value, textScale) {
        return Math.round(value * contentScaleFactor * textScale)
    }

    function hscale(size) {
        return Math.round(size * (screenPixelWidth / refScreenWidth))
    }

    function vscale(size) {
        return Math.round(size * (screenPixelHeight / refScreenHeight))
    }

    function tscale(size) {
        return Math.round((hscale(size) + vscale(size)) / 2)
    }

    readonly property real screenWidthSize: dp(screenPixelWidth)
    readonly property real screenHeightSize: dp(screenPixelHeight)

    readonly property real screenPadding: tscale(12)

    readonly property real headerTopPadding: vscale(15)
    readonly property real headerRightPadding: hscale(20)

    readonly property real lineHeight: vscale(3)

    readonly property real titleVerticalPadding: vscale(10)
    readonly property real titleHorizontalPadding: hscale(20)

    readonly property real logoWidthSize: hscale(196)
    readonly property real logoHeightSize: vscale(196)

    readonly property int textSizeHeader: tscale(30)
    readonly property int textSizeTitle: tscale(23)
    readonly property int textSizeTitleSmall: tscale(20)
    readonly property int textSizeText: tscale(16)
    readonly property int textSizeMenu: tscale(12)
    readonly property int textSizeMenuSmall: tscale(11)
    readonly property int textSizeTabButton: tscale(15)
    readonly property int textSizeSmall: tscale(14)
    readonly property int textSizeContact: tscale(16)
    readonly property int textSizeMessage: tscale(10)
    readonly property int textSizeTiny: tscale(10)
    readonly property int textSizeTinySmall: tscale(9)

    readonly property int buttonBorderMargin: tscale(-8)
    readonly property int buttonBorderPadding: tscale(10)

    readonly property real switchRadius: tscale(13)
    readonly property real switchHeight: vscale(26)
    readonly property real switchWidth: hscale(26)
    readonly property real switchImplicitWidth: hscale(80)
    readonly property real switchImplicitHeight: vscale(26)

    readonly property real comboBoxRadius: tscale(13)
    readonly property real comboBoxImplicitWidth: hscale(120)
    readonly property real comboBoxImplicitHeight: vscale(40)

    readonly property real checkBoxPadding: tscale(10)
    readonly property real checkBoxSpacing: tscale(10)

    readonly property real radioButtonPadding: tscale(10)
    readonly property real radioButtonSpacing: tscale(10)

    readonly property real rowSpacing: vscale(16)
    readonly property real columnSpacing: hscale(20)

    readonly property real listItemWidth: hscale(130)

    // Color Scheme
    // Green
    readonly property color colorQtPrimGreen: "#41cd52"
    readonly property color colorQtAuxGreen1: "#21be2b"
    readonly property color colorQtAuxGreen2: "#17a81a"

    // Gray
    readonly property color colorQtGray1: "#09102b"
    readonly property color colorQtGray2: "#222840"
    readonly property color colorQtGray3: "#3a4055"
    readonly property color colorQtGray4: "#53586b"
    readonly property color colorQtGray5: "#53586b"
    readonly property color colorQtGray6: "#848895"
    readonly property color colorQtGray7: "#9d9faa"
    readonly property color colorQtGray8: "#b5b7bf"
    readonly property color colorQtGray9: "#cecfd5"
    readonly property color colorQtGray10: "#f3f3f4"
}
