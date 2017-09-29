#ifndef PROBLEM_H
#define PROBLEM_H

#include <QObject>

class Problem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int time READ time WRITE setTime NOTIFY timeChanged)

public:
    explicit Problem(QObject *parent = nullptr);
    Problem(const QString &name, const int &time, QObject *parent);

    QString name() const;
    void setName(const QString &name);
    int time() const;
    void setTime(const int &time);

signals:
    void nameChanged();
    void timeChanged();

public slots:

private:
    QString _name;
    int _time;
};

#endif // PROBLEM_H
