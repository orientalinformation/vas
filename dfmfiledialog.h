#ifndef DFMFILEDIALOG_H
#define DFMFILEDIALOG_H

#include <QObject>

class DFMFileDialog : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString nameFilters READ filters WRITE setFilters NOTIFY filtersChanged)
    Q_PROPERTY(QString suffix READ suffix WRITE setSuffix NOTIFY suffixChanged)

    Q_PROPERTY(bool qml READ isQML WRITE setQML NOTIFY isQMLChanged)

public:
    explicit DFMFileDialog(QObject *parent = 0);

    Q_INVOKABLE QString open(QString key = "path");
    Q_INVOKABLE QString save(QString key = "path");

    QString title() const;
    void setTitle(const QString &title);

    QString filters() const;
    void setFilters(const QString &filters);

    QString suffix() const;
    void setSuffix(const QString &suffix);

    bool isQML() const;
    void setQML(bool isQML);

signals:
    void accepted(QString fileUrl);
    void canceled();

    void titleChanged();
    void filtersChanged();
    void suffixChanged();
    void isQMLChanged();

public slots:

private:
    QString _title;
    QString _filters;

    QString _suffix;

    bool _isQML;
};

#endif // DFMFILEDIALOG_H
