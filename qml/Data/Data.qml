pragma Singleton
import QtQuick 2.9

QtObject {






    function findIndexMenuByCategory(category) {
        return menu.findIndex(function(item, i) {
            if(item.category === category)
                return true
        })
    }

    function getCategoriesMenu() {
        return Object.keys(menu)
    }

    readonly property var menu: {
        "Первое": [
            {
                "name": "Лагман",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Борщ",
                "cost": 150,
                "description": "",
                "img": ""
            },
            {
                "name": "Суп с фрикадельками",
                "cost": 190,
                "description": "",
                "img": ""
            },
            {
                "name": "Пельмени",
                "cost": 190,
                "description": "",
                "img": ""
            },
            {
                "name": "Солянка",
                "cost": 190,
                "description": "",
                "img": ""
            },
            {
                "name": "Куриный суп",
                "cost": 190,
                "description": "",
                "img": ""
            }
        ],
        "Второе": [
            {
                "name": "Босо лагман",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Ганфан",
                "cost": 190,
                "description": "",
                "img": ""
            },
            {
                "name": "Бифштекс",
                "cost": 190,
                "description": "",
                "img": ""
            },
            {
                "name": "Манты с мясом",
                "cost": 180,
                "description": "",
                "img": ""
            },
            {
                "name": "Манты жаренные",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Пельмени жаренные",
                "cost": 180,
                "description": "",
                "img": ""
            },
            {
                "name": "Плов",
                "cost": 150,
                "description": "",
                "img": ""
            },
            {
                "name": "Котлеты",
                "cost": 180,
                "description": "",
                "img": ""
            },
            {
                "name": "Окорочка жаренные",
                "cost": 250,
                "description": "",
                "img": ""
            },
            {
                "name": "Курдак с луком",
                "cost": 250,
                "description": "",
                "img": ""
            },
            {
                "name": "Курдак с картошкой",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Курдак с олениной",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Гуляш",
                "cost": 160,
                "description": "",
                "img": ""
            },
            {
                "name": "Сосики",
                "cost": 170,
                "description": "",
                "img": ""
            },
            {
                "name": "Бризоль",
                "cost": 250,
                "description": "",
                "img": ""
            },
            {
                "name": "Шаурма",
                "cost": 250,
                "description": "",
                "img": ""
            }
        ],
        "Гарниры": [
            {
                "name": "Картофельное пюре",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Картофель фри",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Макароны",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Рис",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Гречка",
                "cost": 200,
                "description": "",
                "img": ""
            }
        ],
        "Салаты": [
            {
                "name": "Фунчеза",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Винигрет",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Оливье",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Куриный",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Крабовый",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Свекла с чесноком",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Морковка по-корейски",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Капуста по-корейски",
                "cost": 70,
                "description": "",
                "img": ""
            },
            {
                "name": "Китайский острый",
                "cost": 120,
                "description": "",
                "img": ""
            },
            {
                "name": "Изя языка",
                "cost": 120,
                "description": "",
                "img": ""
            },
            {
                "name": "Из баклажана",
                "cost": 120,
                "description": "",
                "img": ""
            },
            {
                "name": "Свежий из редиски",
                "cost": 120,
                "description": "",
                "img": ""
            }
        ],
        "Напитки": [
            {
                "name": "Кофе 3 в 1",
                "cost": 30,
                "description": "",
                "img": ""
            },
            {
                "name": "Рис",
                "cost": 200,
                "description": "",
                "img": ""
            },
            {
                "name": "Чай с молоком",
                "cost": 30,
                "description": "",
                "img": ""
            },
            {
                "name": "Чай черный",
                "cost": 30,
                "description": "",
                "img": ""
            },
            {
                "name": "Компот",
                "cost": 30,
                "description": "",
                "img": ""
            }
        ],
        "Разное": [
            {
                "name": "Пицца",
                "cost": 350,
                "description": "",
                "img": ""
            },
            {
                "name": "Самсы куриные",
                "cost": 60,
                "description": "",
                "img": ""
            },
            {
                "name": "Самсы с говядиной",
                "cost": 60,
                "description": "",
                "img": ""
            }
        ]
    }

    property var activeOrder

    property var basket



    readonly property var history : [
        {
            "id": 546,
            "cost": "2456.50",
            "datetime": "2019-06-08T00:43:37.000Z",
            "status": "active",
            "content": [
                {

                }

            ]
        },
        {
            "id": 547,
            "cost": "10.25",
            "datetime": "2019-06-08T00:43:37.000Z",
            "status": "active",
            "content": [
                {
                    "id": 2,
                    "name": "Овощи запеченные",
                    "cost": 200
                }

            ]
        }
    ]
}


