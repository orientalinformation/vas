#include "printer.h"

#include <QQuickWindow>
#include <QPainter>
#include <QPrinter>

#include "minipage.h"
#include "pagesize.h"
#include "quickitempainter.h"

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

void Printer::beginPrinting()
{
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
