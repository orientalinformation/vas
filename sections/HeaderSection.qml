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
import QtQuick.Extras 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.1
import FlightObject 1.0

import "../theme"
import "../navigation"

import "../scripts/branding.js" as Branding

Frame {
    id: header

    property bool lineSection: false

    property bool drawerVisible: true

    property bool topSpacing: true

    bottomPadding: AppTheme.vscale(10)
    rightPadding: 0
    leftPadding: 0

    topPadding: topSpacing ? AppTheme.headerTopPadding : 0

    Layout.fillWidth: true

    background: Rectangle {
        border.color: "transparent"
        radius: 0
    }

    property int navigationIndex: -1

    signal caseSaved(var path)
    signal caseOpened(var path)
    signal caseSavedAs(var path)
    signal caseExport(var path)

    onNavigationIndexChanged: {
        switch (navigationIndex) {
        case 0: // Open
            fileOpenDialog.open()
            break;

        case 1: // Save
            if (currentCaseName !== "") {
                header.caseSaved(currentCaseName)
            } else {
                fileSaveDialog.open()
            }
            break;

        case 2: // Save as
            fileSaveAsDialog.open()
            break;

        case 4: // Export
            fileExportDialog.open()
            break;

        case 6: // Quit
            quitMessageDialog.visible = true
            break;

        case 8: //Feedback
            break;

        case 9: // About this app
            swipeView.setCurrentIndex(4)
            break;

        case 3: // Devider
        case 5: // Devider
        case 7: // Devider
        default:
            break;
        }

        navigationIndex = -1
    }

    ColumnLayout {
        id: columnLayoutTitle
        Layout.fillWidth: true
        anchors.fill: parent

        spacing: 0

        Frame {
            id: frameTitle

            leftPadding: 0
            rightPadding: AppTheme.headerRightPadding

            topPadding: 0
            bottomPadding: 0

            Layout.fillWidth: true

            background: Rectangle {
                border.color: "transparent"
                radius: 0
            }

            RowLayout {
                Layout.fillWidth: true
                anchors.fill: parent

                ToolButton {
                    id: btnDrawer

                    visible: drawerVisible

                    contentItem: Image {
                        id: drawerIcon
                        fillMode: Image.Pad
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        source: "qrc:/das/images/menu_indicator.png"
                    }

                    ColorOverlay {
                        anchors.fill: drawerIcon
                        source: drawerIcon
                        color: "#000000"
                    }

                    MouseArea {
                        id: mouseAreaDrawer
                        anchors.fill: parent
                        anchors.margins: 0
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            navigationBar.open()
                        }
                    }
                }

                Label {
                    id: lblTitle
                    text: qsTr(Branding.VER_APPNAME_STR) + translator.tr
                    color: "#00aaff"
                    font.capitalization: Font.AllUppercase
                    font.weight: Font.Bold
                    font.bold: true
                    font.pointSize: AppTheme.textSizeHeader
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
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

                Image {
                    id: logoDFM

                    source: "qrc:/das/images/vaa.png"
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: frameTitle.height * (lineSection ? 0.09 : 0)
            color: lineSection ? "#00aaff" : "transparent"
        }
    }

    property var navigationModel: [
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Open") + translator.tr, "icon": "open_file.png" },
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Save") + translator.tr, "icon": "save.png" },
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Save As") + translator.tr, "icon": "save_as.png" },
        {"type": "../navigation/DrawerDivider.qml", "name": "", "icon": "" },
        //{"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Import") + translator.tr, "icon": "import.png" },
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Export") + translator.tr, "icon": "export.png" },
        {"type": "../navigation/DrawerDivider.qml", "name": "", "icon": "" },
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Quit") + translator.tr, "icon": "logout.png" },
        {"type": "../navigation/DrawerDivider.qml", "name": "", "icon": "" },
        {"type": "../navigation/DrawerNavigationButton.qml", "name": qsTr("Feedback") + translator.tr, "icon": "feedback.png" },
        {"type": "../navigation/DrawerNavigationTextButton.qml", "name": qsTr("About this App") + translator.tr, "icon": "" }
    ]

    // The sliding Drawer
    DrawerNavigationBar {
        id: navigationBar
    }

    FileDialog {
        id: fileOpenDialog
        title: qsTr("Open %1 Case File").arg(Branding.VER_APPNAME_STR) + translator.tr

        folder: shortcuts.documents
        selectExisting: true
        selectMultiple: false

        nameFilters: [qsTr("%1 File (*.vas)").arg(Branding.VER_APPNAME_STR) + translator.tr]

        onAccepted: {
            currentCaseName = fileUrl

            header.caseOpened(fileUrl)
        }
    }

    FileDialog {
        id: fileSaveDialog
        title: qsTr("Save %1 Case File").arg(Branding.VER_APPNAME_STR) + translator.tr

        folder: shortcuts.documents
        selectExisting: false
        selectMultiple: false

        nameFilters: [qsTr("%1 File (*.vas)").arg(Branding.VER_APPNAME_STR) + translator.tr]

        onAccepted: {
            header.caseSaved(fileUrl)
        }
    }

    FileDialog {
        id: fileSaveAsDialog
        title: qsTr("Save %1 Case File").arg(Branding.VER_APPNAME_STR) + translator.tr

        folder: shortcuts.documents
        selectExisting: false
        selectMultiple: false

        nameFilters: [qsTr("%1 File (*.vas)").arg(Branding.VER_APPNAME_STR) + translator.tr]

        onAccepted: {
            header.caseSavedAs(fileUrl)
        }
    }

    FileDialog {
        id: fileExportDialog
        title: qsTr("Export CSV data") + translator.tr

        folder: shortcuts.documents
        selectExisting: false
        selectMultiple: false

        nameFilters: [qsTr("CSV File (*.csv)") + translator.tr]

        onAccepted: {
            header.caseExport(fileUrl)
        }
    }

    MessageDialog {
        id: quitMessageDialog
        title: qsTr("%1").arg(Branding.VER_PRODUCTNAME_STR) + translator.tr
        text: qsTr("Are you sure you want to quit this application?") + translator.tr
        icon: StandardIcon.Warning
        standardButtons: StandardButton.No | StandardButton.Ok

        onAccepted: {
            Qt.quit()
        }
    }
}
