#ifndef PRINTER_H
#define PRINTER_H

#include <QQuickItem>
#include <QtWidgets>
#ifndef QT_NO_PRINTER
#include <QPrinter>
#endif

class QPrinter;

class MiniPage;
class PageSize;
class QuickItemPainter;

class Printer : public QQuickItem
{
public:
    enum Orientation {
        Portrait,
        Landscape
    };

    enum Mode {
        GRAB_IMAGE, //< Print items by taking "screenshot", most accurate solution, but not efficient for PDF
        EFFICIENT   //< Efficient printing of items, but might not be accurate
    };

    Q_ENUMS(Mode Orientation)

private:
    Q_OBJECT

    Q_DISABLE_COPY(Printer)
    Q_PROPERTY(QQuickWindow *window READ window WRITE setWindow NOTIFY windowChanged)
    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged)
    Q_PROPERTY(Mode mode READ mode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(PageSize *pageSize READ pageSize)
    Q_PROPERTY(MiniPage *miniPage READ miniPage)
    Q_PROPERTY(Orientation orientation READ orientation WRITE setOrientation NOTIFY orientationChanged)
    Q_PROPERTY(bool debugVerbose READ debugVerbose WRITE setDebugVerbose NOTIFY debugVerboseChanged)

public:
    Printer(QQuickItem *parent = 0);
    ~Printer();

public:
    Q_INVOKABLE void beginPrinting();
    Q_INVOKABLE void newPage();
    Q_INVOKABLE void printWindow();
    Q_INVOKABLE void endPrinting();
    Q_INVOKABLE void printerPDF(QList<QObject *> data);

public:
    QQuickWindow *window() const;

    void setWindow(QQuickWindow *window);

    QString filename() const;

    void setFilename(const QString &filename);

    Mode mode() const;

    void setMode(Mode mode);

    PageSize *pageSize() const;

    MiniPage *miniPage() const;

    Orientation orientation() const;

    void setOrientation(Orientation orientation);

    bool debugVerbose() const;

    void setDebugVerbose(bool debugVerbose);

private:
    int renderHeader();
    int renderFooter();
    int renderTableTitle(int position);

signals:
    void windowChanged();
    void filenameChanged();
    void modeChanged();
    void orientationChanged();
    void debugVerboseChanged();

    void finished(bool success);

private slots:
    void updatePageSize();

private:
    QQuickWindow *_window;

    QPrinter *_printer;
    QPainter *_painter;

    PageSize *_pageSize;
    MiniPage *_miniPage;

    QuickItemPainter *_itemPainter;

    QString _filename;

    Mode _mode;
    Orientation _orientation;

    QList<QRect> _miniPages;

    int _miniPageIndex;
    bool _debugVerbose;

};

#endif // PRINTER_H
