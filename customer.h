#ifndef CUSTOMER_H
#define CUSTOMER_H

#include <QObject>
#include <QSettings>
#include <QJsonObject>
#include <QJsonArray>
#include "ActiveOrder.h"

class Customer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name MEMBER name NOTIFY userChanged)
    Q_PROPERTY(QString phone MEMBER phone NOTIFY userChanged)
    Q_PROPERTY(QJsonObject address MEMBER address NOTIFY userChanged)
    Q_PROPERTY(ActiveOrder *activeOrder MEMBER activeOrder NOTIFY userChanged)

public:
    explicit Customer(QObject *parent = nullptr);

    void parseData(QJsonObject);

    QString getPhone();
    QString getToken();

    void setAddress(QJsonObject);

    void save();
    void clear();

    void setPaymentToken(QString);
    QString getPaymentToken();

private:
    QSettings settings;

    QString name;
    QString phone;
    QJsonObject address;
    QString token;

    ActiveOrder *activeOrder = new ActiveOrder();
public slots:

    bool isAuthenticated();

signals:
    void userChanged();

};

#endif // CUSTOMER_H
