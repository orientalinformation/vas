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

import Setting 1.0

import "../theme"

import "../sections"
import "../scripts/setting.js" as Settings

Dialog {
    id: languageDialog

    focus: true
    modal: true

    width: _mainWindow.width / 4 * 0.9
    height: _mainWindow.height / 5 * 0.8

    x: (_mainWindow.width - width) / 2
    y: (_mainWindow.height - height) / 2

    property int currentLanguage: 0

    padding: AppTheme.screenPadding

    Setting {
        id: setting

    }

    ButtonGroup {
        id: radioGroup
    }

    ColumnLayout {
        anchors.fill: parent

        Repeater {
            RowLayout {
                Layout.fillWidth: true

                RadioButton {
                    text: model.name

                    font.pointSize: AppTheme.textSizeText
                    Layout.fillWidth: true

                    checked: index === currentLanguage

                    padding: AppTheme.radioButtonPadding
                    spacing: AppTheme.radioButtonSpacing
                    topPadding: AppTheme.radioButtonPadding
                    bottomPadding: AppTheme.radioButtonPadding
                    leftPadding: AppTheme.radioButtonPadding
                    rightPadding: AppTheme.radioButtonPadding

                    ButtonGroup.group: radioGroup

                    onClicked: {
                        Settings.language = model.value

                        currentLanguage = index

                        translator.selectLanguage(model.value)

                        setting.writeSetting("language", model.value)

                        languageDialog.close()
                    }
                }

                Item {
                    // horizontal spacer item
                    Layout.fillWidth: true
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                    }
                }

                Image {
                    source: "qrc:/das/images/language/" + model.nation + ".png"
                }
            }

            model: languageModel
            focus: true
        }
    }

    ListModel {
        id: languageModel

        ListElement {
            name: "English (United States)"
            nation: "america"
            value: "en_US"
        }

        ListElement {
            name: "Tiếng Việt (Việt Nam)"
            nation: "vietnam"
            value: "vi_VN"
        }
    }
}
