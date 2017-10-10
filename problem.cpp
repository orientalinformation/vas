#include "problem.h"

Problem::Problem(QObject *parent) :
    QObject(parent), _name(""), _time(0)
{
}

Problem::Problem(const QString &name, const int &time, QObject *parent) :
    QObject(parent), _name(name), _time(time)
{
}

QString Problem::name() const
{
    return _name;
}

void Problem::setName(const QString &name)
{
    if (name != _name) {
        _name = name;
        emit nameChanged();
    }
}

int Problem::time() const
{
    return _time;
}

void Problem::setTime(const int &time)
{
    if (time != _time) {
        _time = time;
        emit timeChanged();
    }
}
