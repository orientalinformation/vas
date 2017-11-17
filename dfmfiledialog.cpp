#include "dfmfiledialog.h"

#include "setting.h"

#include <QFileDialog>

DFMFileDialog::DFMFileDialog(QObject *parent) :
    QObject(parent)
{
    _isQML = false;
}

QString DFMFileDialog::open(QString key)
{
    Setting settings;

    QString path = settings.readSetting(key);

    QString fileName = QFileDialog::getOpenFileName(NULL, _title, path, _filters);

    if (fileName.isEmpty()) {
        emit canceled();
        return QString();
    }

    if (!fileName.endsWith(_suffix, Qt::CaseInsensitive)) {
        fileName.append(_suffix);
    }

    path = fileName.mid(0, fileName.lastIndexOf("/"));

    settings.writeSetting(key, path);

    if (_isQML) {
        if (!fileName.startsWith("file:///")) {
#ifdef Q_OS_WIN
            fileName = fileName.prepend("file:///");
#else
            fileName = fileName.prepend("file://");
#endif
        }
    }

    emit accepted(fileName);

    return fileName;
}

QString DFMFileDialog::save(QString key)
{
    Setting settings;

    QString path = settings.readSetting(key);

    QString fileName = QFileDialog::getSaveFileName(NULL, _title, path, _filters);

    if (fileName.isEmpty()) {
        emit canceled();
        return QString();
    }

    if (!fileName.endsWith(_suffix, Qt::CaseInsensitive)) {
        fileName.append(_suffix);
    }

    path = fileName.mid(0, fileName.lastIndexOf("/"));

    settings.writeSetting(key, path);

    if (_isQML) {
        if (!fileName.startsWith("file:///", Qt::CaseInsensitive)) {
#ifdef Q_OS_WIN
            fileName = fileName.prepend("file:///");
#else
            fileName = fileName.prepend("file://");
#endif
        }
    }

    emit accepted(fileName);

    return fileName;
}

QString DFMFileDialog::title() const
{
    return _title;
}

void DFMFileDialog::setTitle(const QString &title)
{
    if (_title != title) {
        _title = title;

        emit titleChanged();
    }
}

QString DFMFileDialog::filters() const
{
    return _filters;
}

void DFMFileDialog::setFilters(const QString &filters)
{
    if (_filters != filters) {
        _filters = filters;

        emit filtersChanged();
    }
}

QString DFMFileDialog::suffix() const
{
    return _suffix;
}

void DFMFileDialog::setSuffix(const QString &suffix)
{
    if (_suffix != suffix) {
        _suffix = suffix;

        emit suffixChanged();
    }
}

bool DFMFileDialog::isQML() const
{
    return _isQML;
}

void DFMFileDialog::setQML(bool isQML)
{
    if (_isQML != isQML) {
        _isQML = isQML;

        emit isQMLChanged();
    }
}
