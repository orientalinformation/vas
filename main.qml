import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

import "scripts/global.js" as Global
import "scripts/branding.js" as Branding

import "theme"
import "screens"
import "navigation"

ApplicationWindow {
    id: _mainWindow

    visible: true
    visibility: Window.Maximized

    title: qsTr("%1").arg(Branding.VER_PRODUCTNAME_STR) + translator.emptyString

    Material.accent: "#00aaff"

    property alias swipeView: swipeView

    property bool isLandscape: width > height

    property string currentAircraft: ""

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    property var bottomMenuModel: [
        { "name": qsTr("Home") + translator.emptyString, "icon": "home.png" },
        { "name": qsTr("Schedules") + translator.emptyString, "icon": "schedule.png" },
        { "name": qsTr("Rescheduled") + translator.emptyString, "icon": "departure.png" },
        { "name": qsTr("Settings") + translator.emptyString, "icon": "setting.png" },
        { "name": qsTr("About") + translator.emptyString, "icon": "about.png" },
    ]

    property bool isSplitScheduleView: false

    property int bottomMenuIndex: 0

    onBottomMenuIndexChanged: {
        if (bottomMenuIndex !== swipeView.currentIndex) {
            swipeView.setCurrentIndex(bottomMenuIndex)
        }
    }

    ColumnLayout {
        width: parent.width
        height: parent.height

        Layout.fillWidth: true
        Layout.fillHeight: true

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true

            interactive: false

            HomeScreen {
                id: homePage
            }

            ScheduleScreen {
                id: schedulePage
            }

            RescheduleScreen {
                id: reschedulePage
            }

            SettingScreen {
                id: settingPage
            }

            AboutScreen {
                id: aboutPage
            }

            onCurrentIndexChanged: {
                switch (currentIndex) {
                    case 1:
                        schedulePage.parentIndex = Global.parentScheduleIndex
                        break;
                    case 2:
                        reschedulePage.parentIndex = Global.parentReScheduleIndex
                        break;
                    case 3:
                        settingPage.parentIndex = Global.parentSettingIndex
                        break;
                    case 4:
                        aboutPage.parentIndex = Global.parentAboutIndex
                        break;
                    default:
                        break;
                }

                bottomMenuIndex = currentIndex
            }
        }

        DrawerBottomNavigationBar {
            id: bottomBar
            visible: isLandscape
        }

        PageIndicator {
            id: pageIndicator

            currentIndex: swipeView.currentIndex
            count: swipeView.count
            interactive: true

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            visible: !isLandscape

            delegate: Rectangle {
                implicitWidth: AppTheme.tscale(15)
                implicitHeight: AppTheme.tscale(15)

                radius: width / 2
                color: index === pageIndicator.currentIndex ? "#00aaff"  : pressed ? "#00aaff" : "#00aaff"

                opacity: index === pageIndicator.currentIndex ? 0.95 : pressed ? 0.7 : 0.35

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 100
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        if (index !== swipeView.currentIndex) {
                            swipeView.setCurrentIndex(index)
                        }
                    }
                }
            }
        }
    }

    footer: ToolBar {
        leftPadding: AppTheme.hscale(20)
        rightPadding: AppTheme.hscale(20)

        RowLayout {
            anchors.fill: parent

            Label {
                id: currentDate
                text: Date().toString()

                elide: Label.ElideRight

                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter

                font.pointSize: AppTheme.textSizeTiny

                Layout.fillWidth: true
            }
        }
    }

    Timer {
        interval: 1000;
        running: true;
        repeat: true

        onTriggered: {
            currentDate.text = Date().toString()
        }
    }
}
