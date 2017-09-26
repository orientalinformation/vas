#include "minipage.h"

MiniPage::MiniPage(QQuickItem *parent) :
    QQuickItem(parent), _rows(1), _columns(1), _margin(0)
{
}

int MiniPage::rows() const
{
    return _rows;
}

void MiniPage::setRows(int rows)
{
    _rows = rows;
    emit(rowsChanged());
}

int MiniPage::columns() const
{
    return _columns;
}

void MiniPage::setColumns(int columns)
{
    _columns = columns;
    emit(columnsChanged());
}

int MiniPage::margin() const
{
    return _margin;
}

void MiniPage::setMargin(int margin)
{
    _margin = margin;
    emit(marginChanged());
}
