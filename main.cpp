#include <QScreen>
#include <QApplication>
#include <QDesktopWidget>

#include <QQmlContext>
#include <QQmlApplicationEngine>

#include <QDir>
#include <QStandardPaths>

#include "csvreader.h"
#include "translation.h"
#include "fileprocessing.h"

#include "schedulecalculation.h"
#include "reschedulecalculation.h"
#include "iostreams.h"

#include "printer/printer.h"
#include "printer/minipage.h"
#include "printer/pagesize.h"

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    Translation translator;

    qmlRegisterType<FlightObject, 1>("FlightObject", 1, 0, "FlightObject");

    qmlRegisterType<FileProcessing, 1>("FileProcessing", 1, 0, "FileProcessing");
    qmlRegisterType<CSVReader, 1>("CSVReader", 1, 0, "CSVReader");

    qmlRegisterType<ScheduleCalculation, 1>("ScheduleCalculation", 1, 0, "ScheduleCalculation");
    qmlRegisterType<RescheduleCalculation, 1>("RescheduleCalculation", 1, 0, "RescheduleCalculation");

    qmlRegisterType<MiniPage>("DFMPrinter", 1, 0, "MiniPage");
    qmlRegisterType<Printer>("DFMPrinter", 1, 0, "Printer");
    qmlRegisterType<PageSize>("DFMPrinter", 1, 0, "PageSize");

    qmlRegisterType<IOStreams, 1>("IOStreams", 1, 0, "IOStreams");

    QScreen *screen = QGuiApplication::screens().at(0);

    qreal dpi;

#if defined (Q_OS_WIN)
    dpi = screen->logicalDotsPerInch() * app.devicePixelRatio();
#elif defined(Q_OS_ANDROID)
    dpi = 96;
#else
    dpi = screen->physicalDotsPerInch() * app.devicePixelRatio();
#endif

    //Get Desktop Screen Size
    QRect rec = QApplication::desktop()->screenGeometry();

    QString applicationDirPath = QApplication::applicationDirPath();

    QString applicationLocalPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    QDir dir(applicationLocalPath);

    if (!dir.exists()) {
        dir.mkpath(applicationLocalPath);
    }

    if (!dir.exists("data")) {
        dir.mkdir("data");
    }

    QQmlApplicationEngine engine;

    QQmlContext *context = engine.rootContext();

    context->setContextProperty("applicationDir", applicationDirPath);
    context->setContextProperty("localDataPath", applicationLocalPath);

    context->setContextProperty("screenDpi", dpi);
    context->setContextProperty("screenPixelWidth", rec.width());
    context->setContextProperty("screenPixelHeight", rec.height());

    context->setContextProperty("translator", (QObject*)&translator);

    engine.addImportPath("qrc:/");

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
