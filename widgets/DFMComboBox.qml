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
import QtGraphicalEffects 1.0

import "../theme"

ComboBox {
    id: control

    property bool sizeToContents
    property int modelWidth

    width: (sizeToContents) ? modelWidth + 2 * leftPadding + 2 * rightPadding : implicitWidth

    delegate: ItemDelegate {
        width: (sizeToContents) ? Math.max(modelWidth + 2 * leftPadding + 2 * rightPadding, control.width) : implicitWidth

        contentItem: Text {
            text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
            color: "#000000"
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        highlighted: control.highlightedIndex === index
        hoverEnabled: true
    }

    TextMetrics {
        id: textMetrics
    }

    onModelChanged: {
        textMetrics.font = control.font

        for (var i = 0; i < model.length; i++) {
            textMetrics.text = model[i].modelData
            modelWidth = Math.max(textMetrics.width, modelWidth)
        }
    }
}
