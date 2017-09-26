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

#include "fileprocessing.h"

#include <QFile>
#include <QTextStream>

FileProcessing::FileProcessing(QObject *parent) :
    QObject(parent)
{
}

QString FileProcessing::source()
{
    return _source;
}

void FileProcessing::setSource(const QString &source)
{
    if (_source != source) {
        _source = source;

        emit sourceChanged();
    }
}

QString FileProcessing::read()
{
    if (_source.isEmpty()) {
        emit error("Source is empty.");

        return QString();
    }

    QFile file(_source);

    QStringList fileContent;

    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);

        while (!in.atEnd()) {
            fileContent.append(in.readLine());
        };

        file.close();
    } else {
        emit error("Unable to open the file.");

        return QString();
    }

    return fileContent.join("\n");
}

bool FileProcessing::write(const QString &data)
{
    if (_source.isEmpty()) {
        emit error("Source is empty.");

        return false;
    }

    QFile file(_source);

    if (!file.open(QFile::WriteOnly | QFile::Truncate)) {
        emit error("Unable to open the file.");

        return false;
    }

    QTextStream out(&file);

    out << data;

    file.close();

    return true;
}

bool FileProcessing::copy(QString destPath, QString name)
{
    if (name == "") {
        name = _source.mid(_source.lastIndexOf("/") + 1, _source.lastIndexOf(".") - _source.lastIndexOf("/") - 1);
    }

    QString extension = _source.mid(_source.lastIndexOf(".") + 1);

    QString path = destPath + "/" + name.replace(" ", "_") + "." + extension.toLower();

    if (QFile::exists(path)) {
        QFile::remove(path);
    }

    return QFile::copy(_source, path);
}

bool FileProcessing::remove(QString path)
{
    if (path == "") {
        path = _source;
    }

    return QFile::remove(path);
}

bool FileProcessing::exist(QString path)
{
    if (path == "") {
        path = _source;
    }

    return QFile::exists(path);
}
