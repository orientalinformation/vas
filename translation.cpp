/****************************************************************************
**
** Copyright (C) 2017 Eric Lee.
** Contact: levanhong05@gmail.com
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

#include "translation.h"

#include <QApplication>

Translation::Translation(QObject *parent) :
    QObject(parent)
{
    _viTranslator = new QTranslator(this);
}

QString Translation::tr()
{
    return "";
}

void Translation::selectLanguage(QString language)
{
    if (language == QString("vi_VN")) { //Vietnamese
        _viTranslator->load(":/das/translation/qml_vi.qm");

        qApp->installTranslator(_viTranslator);
    }

    if (language == QString("en_US")){ //English
        qApp->removeTranslator(_viTranslator);
    }

    emit languageChanged();
}
