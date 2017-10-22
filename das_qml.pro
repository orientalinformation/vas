QT +=           widgets qml quick printsupport

CONFIG +=       resources_big c++11\

win32: TARGET =     ../bin/AirlineSchedules
android: TARGET =   bin/AirlineSchedules
unix: TARGET =      bin/AirlineSchedules

HEADERS += \
                translation.h \
                dataobject.h \
                flightobject.h \
                airportobject.h \
                aircraftobject.h \
                fileprocessing.h \
                csvreader.h \
                schedulecalculation.h \
                reschedulecalculation.h \
                printer/minipage.h \
                printer/pagesize.h \
                printer/printer.h \
                printer/quickitempainter.h \
                printer/styledtext.h \
                problem.h \
                iostreams.h

SOURCES +=      main.cpp \
                translation.cpp \
                dataobject.cpp \
                flightobject.cpp \
                airportobject.cpp \
                aircraftobject.cpp \
                fileprocessing.cpp \
                csvreader.cpp \
                schedulecalculation.cpp \
                reschedulecalculation.cpp \
                printer/minipage.cpp \
                printer/pagesize.cpp \
                printer/printer.cpp \
                printer/quickitempainter.cpp \
                printer/styledtext.cpp \
                problem.cpp \
                iostreams.cpp

RESOURCES +=    qml.qrc \
                das_res.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH +=
QML2_IMPORT_PATH += $PWD/theme

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
include(das_qml.pri)
include(SortFilterProxyModel/SortFilterProxyModel.pri)

TRANSLATIONS =  translation/qml_vi.ts

win32:RC_FILE = $$PWD/das_qml.rc

DISTFILES += \
                android/AndroidManifest.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

macos:QMAKE_INFO_PLIST = macos/Info.plist
ios:QMAKE_INFO_PLIST = ios/Info.plist

OTHER_FILES +=  version.h \
                images/LICENSE \
                LICENSE \
                *.md

win32 {
    SOURCEPATH = $$PWD/data
    DESTPATH = $$OUT_PWD/bin/data

    SOURCEPATH1 = $$PWD/LICENSE
    DESTPATH1 = $$OUT_PWD/bin/LICENSE

    copydata.commands = "$(COPY_DIR) $$replace(SOURCEPATH,/,\\) $$replace(DESTPATH,/,\\) && copy $$replace(SOURCEPATH1,/,\\) $$replace(DESTPATH1,/,\\)"
}

unix {
    copydata.commands = "$(COPY_DIR) $$PWD/data $$OUT_PWD/bin/ && cp $$PWD/LICENSE $$OUT_PWD/bin/"
}

first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)

QMAKE_EXTRA_TARGETS += first copydata

#QMAKE_POST_LINK = cd $$PWD && lupdate das_qml.pro && lrelease das_qml.pro
