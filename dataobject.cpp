/****************************************************************************
**
** Copyright (C) 2017 Thien Nguyen.
** Contact: thiennt@dfm-engineering.com
** Company: DFM-Engineering Vietnam
**
** This file is part of the VAA Airline Schedules project.
**
**All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
**
****************************************************************************/

#include "dataobject.h"

DataObject::DataObject(QObject *parent) :
    QObject(parent), _name("")
{
}

DataObject::DataObject(const QString &name, QObject *parent) :
    QObject(parent), _name(name)
{
}

QString DataObject::name() const
{
    return _name;
}

void DataObject::setName(const QString &name)
{
    if (_name != name) {
        _name = name;
        emit nameChanged();
    }
}
