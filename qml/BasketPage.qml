import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml 2.14
import QtGraphicalEffects 1.0

import "./Components"
import AziaData 1.0
import AziaAPI 1.0

Item {


    //property var basket: Basket.basket



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

    SwipeView.onIsCurrentItemChanged: {
     //console.log( SwipeView.isCurrentItem)
        /*if(SwipeView.isCurrentItem) {
            Basket.basketChanged()
        }*/
    }
    Timer {
        id: _tim
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            console.log("tut123")
            Basket.basketChanged()
        }
    }

    ListView {
        x: 20; y: 60
        width: parent.width-40; height: parent.height-40
        spacing: -1
        model: Basket.basket
        delegate: BasketDelegate {
            id: _basketDelegate
            width: parent.width; height: 100
            name: modelData.name
            cost: modelData.cost
            count: modelData.count
            onIncrement: {
                Basket.basket[index].count = count
                Basket.basketChanged()
            }
            onDecrement: {
                Basket.basket[index].count = count
                Basket.basketChanged()
            }
        }
    }

    CustomButton {
        x: 20; y: parent.height - 60
        width: parent.width - 40; height: 40
        visible: Basket.basket.length > 0
        enableShadow: true
        text: qsTr("Оформить заказ %1").arg(Basket.getTotal())
        onClicked: _orderDrawer.open()
    }

    OrderDrawer {
        id: _orderDrawer
    }


}
