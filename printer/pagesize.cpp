#include "pagesize.h"

PageSize::PageSize(QQuickItem *parent) :
    QQuickItem(parent), _unit(Point), _pageSize(QPageSize::A4)
{
}

qreal PageSize::width() const
{
    return _pageSize.size(QPageSize::Unit(_unit)).width();
}

void PageSize::setWidth(qreal _width)
{
    _pageSize = QPageSize(QSizeF(_width, height()), QPageSize::Unit(_unit));
    emit(pageSizeChanged());
}

qreal PageSize::height() const
{
    return _pageSize.size(QPageSize::Unit(_unit)).height();
}

void PageSize::setHeight(qreal height)
{
    _pageSize = QPageSize(QSizeF(width(), height), QPageSize::Unit(_unit));
    emit(pageSizeChanged());
}

PageSize::PageSizeId PageSize::pageSizeId() const
{
    return PageSizeId(_pageSize.id());
}

void PageSize::setPageSizeId(PageSizeId id)
{
    _pageSize = QPageSize(QPageSize::PageSizeId(id));
    emit(pageSizeChanged());
}

PageSize::Unit PageSize::unit() const
{
    return _unit;
}

void PageSize::setUnit(const PageSize::Unit unit)
{
    _unit = unit;
    emit(unitChanged());
}

QPageSize PageSize::pageSize() const
{
    return _pageSize;
}
