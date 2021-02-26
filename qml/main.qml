import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0

import "./Components"

ApplicationWindow {
    visible: true
    width: 420
    height: 720
    title: "Azia"

    font.family: "Roboto"

    property alias errorPopup: _errorPopup

    StackView {
        id: _stackView
        anchors.fill: parent
        initialItem: _mainView

        Component {
            id: _mainView
            Item {
                width: parent.width
                height: parent.height
                SwipeView {
                    id: _swipeView
                    width: parent.width; height: parent.height-60
                    clip: true

                    MenuPage {
                        id: _menuPage
                    }

                    BasketPage {

                        onCheckout: _stackView.push(_orderPageComponent)
                    }

                    ProfilePage {

                    }
                }
                Rectangle {
                    y: parent.height-height
                    width: parent.width; height: 60
                    color: "#FFFFFF"
                    layer.enabled: true
                    layer.effect: DropShadow {
                        radius: 8
                        samples: 16
                        verticalOffset: -3
                        color: "#40000000"
                    }
                    Row {
                        x: 20
                        width: parent.width - 40
                        height: parent.height
                        NavigationDelegate {
                            width: parent.width/3; height: parent.height
                            iconWidth: 35; iconHeight: 30
                            text: qsTr("Меню")
                            icon: "qrc:/icons/burger-black.svg"
                            selected: _swipeView.currentIndex === 0
                            onClicked: _swipeView.currentIndex = 0
                        }
                        Rectangle {
                            y: parent.height/2 - height/2
                            width: 2
                            height: parent.height - 20
                            color: "#5AD166"
                        }

                        NavigationDelegate {
                            width: parent.width/3; height: parent.height
                            iconWidth: 30; iconHeight: 25
                            text: qsTr("Корзина")
                            icon: "qrc:/icons/shopping-black.svg"
                            selected: _swipeView.currentIndex === 1
                            onClicked: _swipeView.currentIndex = 1
                        }
                        Rectangle {
                            y: parent.height/2 - height/2
                            width: 2
                            height: parent.height - 20
                            color: "#5AD166"
                        }
                        NavigationDelegate {
                            width: parent.width/3; height: parent.height
                            iconWidth: 30; iconHeight: 25
                            text: qsTr("Профиль")
                            icon: "qrc:/icons/profile-black.svg"
                            selected: _swipeView.currentIndex === 2
                            onClicked: {
                                _swipeView.currentIndex = 2
                                if(!user.isAuthenticated) {
                                    _authDialog.open()
                                }
                            }
                        }
                    }
                }
            }
        }
        Component {
            id: _orderPageComponent
            OrderPage {
                id: _orderPage
                phone: user.phone
                costOrder: basket.total
                cityCostDeliveryModel: core.currentShop.deliveryCityCost
                address {
                    street: user.address.street;
                    house: user.address.house;
                    flat: user.address.flat;
                }
                onPayment: {
                    core.makeOrder(obj)
                    showBusyIndicator = true
                }
                onBack: _stackView.pop()
            }
        }

        Component {
            id: _paymentComponent

            PaymentPage {
                id: _paymentPage
                onBack: _stackView.pop()
                onError: _errorPopup.show(text)

                Connections {
                    target: core

                    function onPayment(html) {
                        _paymentPage.open(html)
                    }
                }
            }
        }
    }

    AuthDialog {
        id: _authDialog
        phone: user.phone
        onInputPhone: core.inputByPhone(phone)
        onInputCode: core.loginBySMS(code)
    }

    Connections {
        target: core
        function onAuthenticated() {
            _authDialog.close()
        }

        function onError(msg) {
            _errorPopup.show(msg)
        }

        function onPayment(html) {
            //_paymentPage.open(html)
            _stackView.replace(_paymentComponent)

        }
    }

    ErrorPopup {
        id: _errorPopup
    }
}
