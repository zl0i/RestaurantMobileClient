#include "customer.h"

Customer::Customer(QObject *parent) : QObject(parent)
{
    phone = settings.value("phone", "").toString();
    token = settings.value("token").toString();
    name = settings.value("name", "").toString();
    address = settings.value("address", QJsonObject {
                                     {"street", ""},
                                     {"house", ""},
                                     {"flat", ""}
                                 }).toJsonObject();

    qDebug() << "user info:" << '\n'
             << "phone:" << phone << '\n'
             << "token:" << token << '\n'
             << "address:" << address << '\n';
}

bool Customer::isAuthenticated()
{
    return !token.isEmpty();
}

void Customer::parseData(QJsonObject obj)
{
    phone = obj.value("phone").toString();
    token = obj.value("token").toString();
    address = obj.value("address").toObject();
    activeOrder->total = obj.value("activeOrder").toObject().value("total").toDouble();
    activeOrder->datetime = obj.value("activeOrder").toObject().value("datetime").toString();
    activeOrder->status = obj.value("activeOrder").toObject().value("status").toString();

    emit activeOrder->activeOrderChanged();
    emit userChanged();
    save();
}

QString Customer::getPhone()
{
    return phone;
}

QString Customer::getToken()
{
    return token;
}

void Customer::setAddress(QJsonObject obj)
{
    address = obj;
    settings.setValue("address", address);
}

void Customer::save()
{
    settings.setValue("phone", phone);
    settings.setValue("token", token);
    settings.setValue("address", address);
}

void Customer::clear()
{
    phone = "";
    token = "";
    name = "";
    address = QJsonObject();
    settings.clear();
    emit userChanged();
}

void Customer::setPaymentToken(QString ptoken)
{
    activeOrder->payment_token = ptoken;
}

QString Customer::getPaymentToken()
{
    return activeOrder->payment_token;
}
