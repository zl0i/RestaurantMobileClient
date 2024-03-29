#include "activeorder.h"

ActiveOrder::ActiveOrder(QObject *parent) : QStandardItemModel(parent)
{

}

void ActiveOrder::setMenu(MenuModel *menu)
{
    this->menu = menu;
}

void ActiveOrder::parseData(QJsonObject obj)
{
    clearOrder();

    if(obj.isEmpty())
        return;

    id = obj.value("id").toString();
    total = obj.value("total").toDouble();
    datetime = obj.value("datetime").toString();
    status = obj.value("status").toString();

    QJsonArray jmenu = obj.value("menu").toArray();
    insertColumn(0);
    insertRows(0, jmenu.size());
    for(int i = 0; i < jmenu.size(); i++) {
        QJsonObject item = jmenu.at(i).toObject();
        QModelIndex menuIndex = getIndexMenuItemById(item.value("id").toInt());
        QModelIndex index = this->index(i, 0);
        setData(index, item.value("id").toInt(), IdRole);
        setData(index, menu->data(menuIndex, MenuModel::NameRole), NameRole);
        setData(index, menu->data(menuIndex, MenuModel::CostRole), CostRole);
        setData(index, item.value("count"), CountRole);
        setData(index, data(index, CountRole).toInt() * data(index, CostRole).toDouble(), TotalRole);
    }
    emit activeOrderChanged();
}

void ActiveOrder::clearOrder()
{
    id = "";
    datetime = "";
    status = "";
    total = 0;
    clear();
    emit activeOrderChanged();
}

QHash<int, QByteArray> ActiveOrder::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[CostRole] = "cost";
    roles[CountRole] = "count";
    roles[TotalRole] = "total";
    return roles;
}

QModelIndex ActiveOrder::getIndexMenuItemById(int id)
{
    for(int i = 0; i < menu->rowCount(); i++) {
        QModelIndex index = menu->index(i, 0);
        if(menu->data(index, MenuModel::IdRole).toInt() == id) {
            return index;
        }
    }
    return QModelIndex();
}
