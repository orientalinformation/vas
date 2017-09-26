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

#ifndef FILEPROCESSING_H
#define FILEPROCESSING_H

#include <QObject>

class FileProcessing : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)

    explicit FileProcessing(QObject *parent = 0);

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString& data);

    Q_INVOKABLE bool copy(QString destPath, QString name = "");

    Q_INVOKABLE bool remove(QString path = "");

    Q_INVOKABLE bool exist(QString path = "");

    QString source();

public slots:
    void setSource(const QString& source);

signals:
    void sourceChanged();
    void error(const QString& msg);

private:
    QString _source;
};

#endif // FILEPROCESSING_H
