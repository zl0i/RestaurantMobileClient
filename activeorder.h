#ifndef ACTIVEORDER_H
#define ACTIVEORDER_H

#include <QObject>
#include <QStandardItemModel>
#include <QDateTime>
#include <QJsonArray>
#include <QJsonObject>

#include "menumodel.h"

class ActiveOrder : public QStandardItemModel {
    Q_OBJECT
    Q_PROPERTY(QString datetime MEMBER datetime NOTIFY activeOrderChanged)
    Q_PROPERTY(QString status MEMBER status NOTIFY activeOrderChanged)
    Q_PROPERTY(qreal total MEMBER total NOTIFY activeOrderChanged)
    Q_PROPERTY(bool isEmpty READ isEmpty NOTIFY activeOrderChanged)

public:

    typedef enum {
        IdRole = Qt::UserRole+1,
        NameRole,
        CostRole,
        CountRole,
        TotalRole
    } ActiveOrderRoles;

    explicit ActiveOrder(MenuModel *menus, QObject *parent = nullptr);

    void parseData(QJsonObject);
    bool isEmpty() { return rowCount() > 0; }

private:
    QString datetime;
    qreal total = 0;
    QString status;
    QString payment_token;

    QHash<int, QByteArray> roleNames() const;

    const MenuModel menu;

    QModelIndex getIndexMenuItemById(QString);

signals:
    void activeOrderChanged();
};

#endif // ACTIVEORDER_H
