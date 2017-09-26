#ifndef MINIPAGE_H
#define MINIPAGE_H

#include <QQuickItem>

class MiniPage : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int rows READ rows WRITE setRows NOTIFY rowsChanged)
    Q_PROPERTY(int columns READ columns WRITE setColumns NOTIFY columnsChanged)
    Q_PROPERTY(int margin READ margin WRITE setMargin NOTIFY marginChanged)

public:
    explicit MiniPage(QQuickItem *parent = 0);

public:
    int rows() const;

    void setRows(int rows);

    int columns() const;

    void setColumns(int columns);

    int margin() const;

    void setMargin(int margin);

signals:
    void rowsChanged();
    void columnsChanged();
    void marginChanged();

private:
    int _rows;
    int _columns;
    int _margin;

};

#endif // MINIPAGE_H
