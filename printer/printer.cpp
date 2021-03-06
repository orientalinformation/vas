#include "printer.h"

#include <QQuickWindow>
#include <QPainter>
#include <QPrinter>

#include "minipage.h"
#include "pagesize.h"
#include "quickitempainter.h"

#include "../setting.h"

static const QString footer("This is the\nfooter\ntext");
static const QString fontfamily("Times New Roman");

Printer::Printer(QQuickItem *parent):
    QQuickItem(parent), _window(0), _printer(0), _painter(0), _mode(GRAB_IMAGE), _pageSize(new PageSize), _miniPage(new MiniPage), _orientation(Portrait), _itemPainter(0), _debugVerbose(false)
{
    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()
    // setFlag(ItemHasContents, true);
    connect(_pageSize, SIGNAL(pageSizeChanged()), this, SLOT(updatePageSize()));
}

Printer::~Printer()
{
    endPrinting();
}

int Printer::renderHeader()
{
    QFont font(fontfamily, 50, 50);
    font.setBold(true);

    QPen penHText(QColor("#00aaff"));

    _painter->save();
    _painter->resetTransform();

    _painter->setFont(font);
    _painter->setPen(penHText);

    QString header = tr("VAA Airline Schedules");

    QRect boundingRect = _painter->boundingRect(_painter->window(), Qt::AlignHCenter | Qt::TextWordWrap, header);
    _painter->drawText(boundingRect, Qt::AlignHCenter | Qt::TextWordWrap, header);
    _painter->restore();

    return boundingRect.height() + 20;
}

int Printer::renderFooter()
{
    _painter->save();
    _painter->resetTransform();

    _painter->setFont(QFont(fontfamily, 12));

    QRect boundingRect = _painter->boundingRect(_painter->window(), Qt::AlignJustify | Qt::TextWordWrap, footer);
    _painter->translate(0, _painter->window().height() - boundingRect.height() - 5);

    _painter->drawText(boundingRect, Qt::AlignJustify | Qt::TextWordWrap, footer);
    _painter->restore();

    return boundingRect.height();
}

int Printer::renderTableTitle(int position)
{
    _painter->save();
    _painter->resetTransform();
    _painter->setFont(QFont(fontfamily, 18));

    QRect boundingRect = _painter->boundingRect(_painter->window(), Qt::AlignJustify | Qt::TextWordWrap, "FN");
    _painter->translate(0, position);

    QTextDocument td;
    td.setHtml("<table style=\"width: 100%;border: 1px solid black;border-collapse: collapse\">"
               "<tr style=\"background-color: #00aaff;color: white;\">"
                 "<th>FN</th>"
                 "<th>Crew1</th>"
                 "<th>Crew2</th>"
                 "<th>Crew3</th>"
                 "<th>Crew4</th>"
                 "<th>Crew5</th>"
                 "<th>Crew6</th>"
                 "<th>DEP</th>"
                 "<th>ARR</th>"
                 "<th>TD</th> "
                 "<th>TA</th> "
                 "<th>AC</th> "
                 "<th>ACo</th>"
               "</tr>"
             "</table>");
    td.drawContents(_painter);

    _painter->restore();
    return boundingRect.height();
}

void Printer::beginPrinting()
{
    QString fileName = QFileDialog::getSaveFileName(0, tr("Export PDF"), QString(), tr("PDF File (*.pdf)"));

    if (fileName.isEmpty()) {
        return;
    }

    if (!fileName.endsWith(".pdf", Qt::CaseInsensitive)) {
        fileName.append(".pdf");
    }

    _filename = fileName;

    if (!_window) {
        qWarning() << "Window is not set, cannot print!";
        return;
    }

    if (_printer) {
        qWarning() << "Printing is already started!";
        return;
    }

    if (_filename.isEmpty()) {
        qWarning() << "No filenames specified";
        return;
    }

    QString filename = _filename;

    if (filename.startsWith("file://")) {
        filename = filename.right(filename.size() - 7);
    }

    _printer = new QPrinter;
//  m_printer->setFullPage(true); // TODO: reintroduce as an option
    _printer->setOutputFileName(filename);
    _printer->setPageSize(_pageSize->pageSize());
    _printer->setOrientation(QPrinter::Orientation(_orientation));
    // Setup mini pages
    const int miniPageWidth  = _printer->pageRect().width() / _miniPage->columns();
    const int miniPageHeight = _printer->pageRect().height() / _miniPage->rows();
    const int miniPageMargin = _miniPage->margin();

    const QMargins miniPageMargins(miniPageMargin, miniPageMargin, miniPageMargin, miniPageMargin);
    _miniPages.clear();

    for (int r = 0; r < _miniPage->rows(); ++r) {
        for (int c = 0; c < _miniPage->columns(); ++c) {
            QRect rect(c * miniPageWidth + _printer->pageRect().x(), r * miniPageHeight + _printer->pageRect().y(), miniPageWidth, miniPageHeight);
            _miniPages.append(rect.marginsRemoved(miniPageMargins));
        }
    }

    if (_debugVerbose) {
        qDebug() << "Start printing";
        qDebug() << "  miniPage.columns: " << _miniPage->columns();
        qDebug() << "  miniPage.rows:    " << _miniPage->rows();
        qDebug() << "  miniPage.margin:  " << _miniPage->margin();
        qDebug() << "  miniPages";

        for (int i = 0; i < _miniPages.count(); ++i) {
            qDebug() << "    " << i << ":" << _miniPages.at(i);
        }
    }

    _painter = new QPainter;
    _painter->begin(_printer);
    _miniPageIndex = 0;
    _itemPainter = new QuickItemPainter(_painter, _window);
}

void Printer::printWindow()
{
    if (!_printer) {
        qWarning() << "Printing not started";

        emit finished(false);
        return;
    }

    QRect pageRect = _miniPages[_miniPageIndex];
    QSize targetSize = _window->size();

    targetSize.scale(pageRect.width(), pageRect.height(), Qt::KeepAspectRatio);

    QSize trans_size = 0.5 * (pageRect.size() - targetSize);
    QPoint trans(trans_size.width(), trans_size.height());

    _painter->save();

    QRect viewport = QRect(trans + pageRect.topLeft(), targetSize);

    _painter->setViewport(viewport);
    _painter->setWindow(0, 0, _window->width(), _window->height());

    if (_debugVerbose) {
        qDebug() << "Print window";
        qDebug() << "  pageRect:    " << pageRect;
        qDebug() << "  targetSize:  " << targetSize;
        qDebug() << "  viewport:    " << viewport;
        qDebug() << "  window:      " << _window->width() << _window->height();
    }

    switch (_mode) {
        case GRAB_IMAGE: {
            QImage image = _window->grabWindow();
            Q_ASSERT(image.size() == _window->size());
            _painter->drawImage(0, 0, image);

            break;
        }

        case EFFICIENT: {
            _itemPainter->setDebugVerbose(_debugVerbose);
            _itemPainter->paintItem(_window->contentItem());

            break;
        }

        default: {
            qWarning() << "Unimplemented printing mode.";
            break;
        }
    }

    _painter->restore();

    emit finished(true);
}

void Printer::newPage()
{
    if (!_printer) {
        qWarning() << "Printing not started";
        return;
    }

    ++_miniPageIndex;

    if (_miniPageIndex >= _miniPages.size()) {
        if (_debugVerbose) {
            qDebug() << "New page";
        }

        _miniPageIndex = 0;
        _printer->newPage();
    } else if (_debugVerbose) {
        qDebug() << "New mini page" << _miniPageIndex << " at " << _miniPages.at(_miniPageIndex);
    }
}

void Printer::endPrinting()
{
    if (_printer) {
        _painter->end();
        delete _painter;
        _painter = 0;
        delete _printer;
        _printer = 0;
    }
}

void Printer::printerPDF(QList<QObject *> data)
{
    Setting settings;

    QString path = settings.readSetting("printPath");

    QString fileName = QFileDialog::getSaveFileName(NULL, tr("Export PDF"), path, tr("PDF File (*.pdf)"));

    if (fileName.isEmpty()) {
        qWarning() << "Printing not started";

        return;
    }

    if (!fileName.endsWith(".pdf", Qt::CaseInsensitive)) {
        fileName.append(".pdf");
    }

    path = fileName.mid(0, fileName.lastIndexOf("/"));

    settings.writeSetting("printPath", path);

    QPrinter printer(QPrinter::PrinterResolution);
    printer.setOutputFormat(QPrinter::PdfFormat);
    printer.setPageMargins(35, 10, 20, 10, QPrinter::Millimeter);
    printer.setPaperSize(QPrinter::A4);
    printer.setOrientation(QPrinter::Landscape);
    printer.setOutputFileName(fileName);

    QTextDocument doc;

    QStringList datas;

    QString currentAircraft = "";
    QString color = "";
    bool isAircraftChanged = false;

    for(int i = 0; i < data.length(); i++) {
        if (data[i]->property("newAircraft").toString() != currentAircraft) {
            currentAircraft = data[i]->property("newAircraft").toString();
            isAircraftChanged = !isAircraftChanged;

            if (!isAircraftChanged) {
                color = "#FFFFCC";
            } else {
                color = "#C6EFCE";
            }
        }

        int ted = data[i]->property("timeDeparture").toInt() / 60 * 100 + data[i]->property("timeDeparture").toInt() % 60;
        int tea = data[i]->property("timeArrival").toInt() / 60 * 100 + data[i]->property("timeArrival").toInt() % 60;

        QString rowData = "<tr style=\"background-color: " + color + ";color: #000000;\">"
                           "<td>"+ data[i]->property("name").toString() +"</td>"
                           "<td>"+ data[i]->property("captain").toString() +"</td>"
                           "<td>"+ data[i]->property("coPilot").toString() +"</td>"
                           "<td>"+ data[i]->property("cabinManager").toString() +"</td>"
                           "<td>"+ data[i]->property("cabinAgent1").toString() +"</td>"
                           "<td>"+ data[i]->property("cabinAgent2").toString() +"</td>"
                           "<td>"+ data[i]->property("cabinAgent3").toString() +"</td>"
                           "<td>"+ data[i]->property("departure").toString() +"</td>"
                           "<td>"+ data[i]->property("arrival").toString() +"</td>"
                           "<td>"+ QString::number(ted) +"</td>"
                           "<td>"+ QString::number(tea) +"</td>"
                           "<td>"+ data[i]->property("newAircraft").toString() +"</td>"
                           "<td>"+ data[i]->property("oldAircraft").toString() +"</td>"
                         "</tr>";

        datas.append(rowData);
    }

    QString footer = "<div style=\"position: relative;\">"
                         "<div align=right style=\"position: absolute;\">"
                             "<a href=\"www.vaa.edu.vn\">www.vaa.edu.vn</a>"
                          "</div>"
                          "<div align=left>" +
                             tr("Vietnam Aviation Academy") +
                          "<br></div>"
                     "</div>" +
                     tr("No. 104, Nguyen Van Troi Street, Phu Nhuan District, Ho Chi Minh City, Vietnam") + "<br>" +
                     tr("Tel") + ": 028.38.422.199 – " + tr("Email") + ":<a href=\"mailto:info@vaa.edu.vn\"> info@vaa.edu.vn</a><br>";

    doc.setHtml(
              "<table style=\"margin: 0px auto; width: 100%\">"
                  "<caption style=\"color: #00aaff; font-size: 40px; font-weight: 600;\">" + tr("VAA Airline Schedules") + "</caption>"
                  "<tr style=\"background-color: #00aaff;color: white;\">"
                    "<th>FN</th>"
                    "<th>Crew1</th>"
                    "<th>Crew2</th>"
                    "<th>Crew3</th>"
                    "<th>Crew4</th>"
                    "<th>Crew5</th>"
                    "<th>Crew6</th>"
                    "<th>DEP</th>"
                    "<th>ARR</th>"
                    "<th>TD</th> "
                    "<th>TA</th> "
                    "<th>AC</th> "
                    "<th>ACo</th>"
                  "</tr>"
               + datas.join(" ") +
               "</table><br><hr>"
                + footer
                );

    doc.setPageSize(printer.pageRect().size()); // This is necessary if you want to hide the page number
    doc.print(&printer);

    emit finished(true);
}

QQuickWindow *Printer::window() const
{
    return _window;
}

void Printer::setWindow(QQuickWindow *window)
{
    _window = window;
    emit(windowChanged());
}

QString Printer::filename() const
{
    return _filename;
}

void Printer::setFilename(const QString &filename)
{
    _filename = filename;
    emit(filenameChanged());
}

Printer::Mode Printer::mode() const
{
    return _mode;
}

void Printer::setMode(Printer::Mode mode)
{
    _mode = mode;
    emit(modeChanged());
}

PageSize *Printer::pageSize() const
{
    return _pageSize;
}

MiniPage *Printer::miniPage() const
{
    return _miniPage;
}

Printer::Orientation Printer::orientation() const
{
    return _orientation;
}

void Printer::setOrientation(Printer::Orientation orientation)
{
    _orientation = orientation;
    emit(orientationChanged());
}

bool Printer::debugVerbose() const
{
    return _debugVerbose;
}

void Printer::setDebugVerbose(bool debugVerbose)
{
    _debugVerbose = debugVerbose;
    emit(debugVerboseChanged());
}

void Printer::updatePageSize()
{
    if (_printer) {
        _printer->setPageSize(_pageSize->pageSize());
    }
}
