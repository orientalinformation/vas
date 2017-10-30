import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

import "scripts/global.js" as Global
import "scripts/branding.js" as Branding

import "theme"
import "screens"
import "navigation"
import "sections"

ApplicationWindow {
    id: _mainWindow

    visible: true
    visibility: Window.Maximized

    title: qsTr(Branding.VER_PRODUCTNAME_STR) + translator.tr

    Material.accent: "#00aaff"

    property alias swipeView: swipeView

    property bool isLandscape: width > height

    property string currentAircraft: ""

    property string currentCaseName: ""

    property int numberFlightUnchanged: 0
    property int numberAircarftUnchanged: 0
    property int numberFlightCancel: 0
    property int totalTimeDelay: 0
    property int numberFlightDelay: 0
    property int maximumTimeDelay: 0

    width: AppTheme.screenWidthSize
    height: AppTheme.screenHeightSize

    minimumWidth: AppTheme.screenWidthSize
    minimumHeight: AppTheme.screenHeightSize

    property var bottomMenuModel: [
        { "name": qsTr("Home") + translator.tr, "icon": "home.png" },
        { "name": qsTr("Schedules") + translator.tr, "icon": "schedule.png" },
        { "name": qsTr("Rescheduled") + translator.tr, "icon": "departure.png" },
        { "name": qsTr("Settings") + translator.tr, "icon": "setting.png" },
        { "name": qsTr("About") + translator.tr, "icon": "about.png" },
    ]

    property bool isSplitScheduleView: false

    property int bottomMenuIndex: 0

    onBottomMenuIndexChanged: {
        if (bottomMenuIndex !== swipeView.currentIndex) {
            swipeView.setCurrentIndex(bottomMenuIndex)
        }
    }

    header: HeaderSection {
        id: headerSection

        onCaseOpened: {
            homePage.open(path)
            schedulePage.open(path)
            reschedulePage.open(path)
            settingPage.open(path)
        }

        onCaseSaved: {
            homePage.save(path)
            schedulePage.save(path)
            reschedulePage.save(path)
            settingPage.save(path)
        }

        onCaseSavedAs: {
            homePage.saveAs(path)
            schedulePage.saveAs(path)
            reschedulePage.saveAs(path)
            settingPage.saveAs(path)
        }

        onCaseExport: {
           homePage.exportCSV(path)
        }

        onCaseNew: {
            homePage.newCase()
            schedulePage.newCase()
            reschedulePage.newCase()
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

                onBuilt: {
                    homePage.reload(localDataPath + "/data/flight_schedule.csv", "", true)

                    homePage.isInfoShowed = false
                }
            }

            RescheduleScreen {
                id: reschedulePage

                onBuilt: {
                    homePage.reload(localDataPath + "/data/flight_reschedule.csv", inputPath, false)

                    homePage.isInfoShowed = true
                }
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
        id: timer

        interval: 1000;
        running: true;
        repeat: true

        onTriggered: {
            currentDate.text = Date().toString()
        }
    }
}
