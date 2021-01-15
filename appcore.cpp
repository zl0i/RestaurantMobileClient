#include "appcore.h"

AppCore::AppCore(QObject *parent) : QObject(parent), basket(&menu)
{
    loginByToken();
}

void AppCore::inputByPhone(QString phone)
{
    qDebug() << "inputByPhone:" << phone;
    tempPhone = phone;

    QNetworkRequest req(QUrl(host + "/azia/api/users/input"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject obj {
        {"phone", tempPhone}
    };
    QNetworkReply *reply = manager.post(req, QJsonDocument(obj).toJson());
    reply->ignoreSslErrors();
    QObject::connect(reply, &QNetworkReply::finished, [=]() {
        if(reply->error() == QNetworkReply::NoError) {

        } else {
            qDebug() << "error:" << reply->errorString();
            emit error(reply->errorString());
        }
    });
}

void AppCore::loginBySMS(QString code)
{
    qDebug() << "loginBySMS:" << tempPhone << "code:" << code;

    QNetworkRequest req(QUrl(host + "/azia/api/users/login"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject obj {
        {"phone", tempPhone},
        {"code", code}
    };
    QNetworkReply *reply = manager.post(req, QJsonDocument(obj).toJson());
    reply->ignoreSslErrors();
    QObject::connect(reply, &QNetworkReply::finished, [=]() {
        if(reply->error() == QNetworkReply::NoError) {
            emit authenticated();
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            user.parseData(doc.object());
        } else {
            qDebug() << "error:" << reply->errorString();
            emit error(reply->errorString());
        }
    });
}

void AppCore::loginByToken()
{

    if(user.getToken().isEmpty())
        return;

    qDebug() << "loginByToken";
    QNetworkRequest req(QUrl(host + "/azia/api/users/token"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject obj {
        {"phone", user.getPhone()},
        {"token", user.getToken()}
    };
    QNetworkReply *reply = manager.post(req, QJsonDocument(obj).toJson());
    reply->ignoreSslErrors();
    QObject::connect(reply, &QNetworkReply::finished, [=]() {
        if(reply->error() == QNetworkReply::NoError) {
            emit authenticated();
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            user.parseData(doc.object());
        } else {
            qDebug() << "error:" << reply->errorString();
            errorHandler(reply);
        }
        reply->deleteLater();
    });
}

void AppCore::logout()
{
    user.clear();
}

void AppCore::requestMenu()
{
    qDebug() << "requestMenu";

    QNetworkRequest req(QUrl(host + "/azia/api/menu"));
    QNetworkReply *reply = manager.get(req);
    reply->ignoreSslErrors();
    QObject::connect(reply, &QNetworkReply::finished, [&]() {
        if(reply->error() == QNetworkReply::NoError) {
            QByteArray arr = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(arr);
            QJsonObject menuObj = doc.object();
            menu.parseData(menuObj);
            emit menuSended();
        } else {
            qDebug() << "error:" << reply->errorString();
            emit menuSended();
            errorHandler(reply);
        }
        reply->deleteLater();
    });
}

void AppCore::makeOrder(QJsonObject info)
{
    QNetworkRequest req(QUrl(host + "/azia/api/orders"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject obj;
    obj.insert("token", user.getToken());
    obj.insert("menu", basket.order());
    obj.insert("phoneUser", user.getPhone());
    obj.insert("phoneOrder", info.value("phone"));
    obj.insert("comment", info.value("comment"));
    obj.insert("address", info.value("address"));
    QJsonDocument doc(obj);

    //если адрес новый - сохранить

    QNetworkReply *reply = manager.post(req, doc.toJson());
    reply->ignoreSslErrors();
    QObject::connect(reply, &QNetworkReply::finished, [=]() {
        if(reply->error() == QNetworkReply::NoError) {
            QByteArray arr = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(arr);

            QJsonObject obj = doc.object();

            QFile file(":icons/payment-page.html");
            file.open(QIODevice::ReadOnly);

            QString html = file.readAll();

            html.replace("%1", obj.value("payment_token").toString());
            emit payment(html);

        } else {
            qDebug() << "error:" << reply->errorString();
            errorHandler(reply);
        }
        reply->deleteLater();
    });
}

void AppCore::requestHistory()
{

}

void AppCore::requestStatusActiveOrder()
{

}

void AppCore::errorHandler(QNetworkReply *reply)
{
    const QNetworkReply::NetworkError err = reply->error();

    switch (err) {
    case QNetworkReply::HostNotFoundError:
        emit error(tr("Сервер не найден"));
        break;
    case QNetworkReply::InternalServerError:
        emit error(tr("Внутрення ошибка сервера"));
        break;
    case QNetworkReply::ProtocolInvalidOperationError: {
        QByteArray arr = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(arr);
        QJsonObject errorObj = doc.object();
        QString errorString = errorObj.value("result").toString();
        emit error(errorString);
        break;
    }
    case QNetworkReply::UnknownNetworkError:
        emit error("Неизвестная ошибка");
        break;
    default:
        emit error(tr("Внутрення ошибка"));
    }
}
