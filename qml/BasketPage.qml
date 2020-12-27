import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.12
import QtGraphicalEffects 1.0

import "./Components"

Item {
    clip: true
    Rectangle {
        width: parent.width; height: 50
        layer.enabled: true
        layer.effect: DropShadow {
            radius: 8
            samples: 16
            color: "#80000000"
            verticalOffset: 4
        }

        Label {
            x: 20;
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            font { pixelSize: 20; bold: true }
            text: qsTr("Корзина")
        }
    }

    ListView {
        id: _basketView
        x: 20; y: 60; z: -1
        width: parent.width-40; height: parent.height-40
        spacing: -1
        model: basket
        delegate: BasketDelegate {
            id: _basketDelegate
            width: _basketView.width; height: 100
            image: core.host + "/"  + model.image
            name: model.name
            cost: model.cost
            count: model.count

            Binding {
                target: _basketDelegate
                property: "count"
                value: model.count
            }
            onIncrement: {
                menu.setCountItem(String(model.id), count)
            }
            onDecrement: {
                 menu.setCountItem(String(model.id), count)
            }
        }
    }

    CustomButton {
        x: 20; y: parent.height - 60
        width: parent.width - 40; height: 40
        visible: basket.rowCount() > 0
        enableShadow: true
        text: qsTr("Оформить заказ")
        extractText: qsTr("%1 р.").arg(basket.total)
        onClicked: _orderDialog.open()
    }

    OrderDialog {
        id: _orderDialog
        /*phone: User.phoneNumber
        address {
            street: User.address.street
            house: User.address.house
            flat: User.address.flat
        }*/
        onAccess: {
            var obj = {
                "menu": JSON.stringify(Basket.getMinimumBasket()),
                "comment": _orderDialog.comment,
                "address": {
                    "street": _orderDialog.address.street,
                    "house": _orderDialog.address.house,
                    "flat":_orderDialog.address.flat
                },
                "phone": _orderDialog.phone,
                "phoneNumber": User.phoneNumber
            }
            AziaAPI.ordered(obj,
                            function(responseText) {
                                console.log(responseText)
                                Basket.basket = []
                                close()
                            },
                            function (status, text) {
                                console.log("error:", text)
                            })
        }
    }
}
