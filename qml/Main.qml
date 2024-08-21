
import QtQuick

Rectangle{
    property int pageIndex: 0

    id: root
    color: "#c0444444"

    Rectangle{
        id: sidebar
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 50
        radius: 25
        color: "#40C0C0C0"

        ListView{
            id: sideList
            anchors.fill: parent
            clip: true
            interactive: false // 禁止滑动
            model: ListModel{
                ListElement{imageUrl: "qrc:/res/key.png"}
                ListElement{imageUrl: "qrc:/res/web.png"}
            }

            delegate: Image{
                width: 50
                height: 50
                source: imageUrl

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        sideList.currentIndex = index
                        root.pageIndex = index
                    }
                }
            }

            highlight: Rectangle{
                color: "#40ffffff"
                radius: 25
            }
        }

        Image {
            id: github
            width: 50
            height: 50
            anchors.bottom: bilibili.top
            source: "qrc:/res/github.png"

            MouseArea{
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://github.com/PhoenixOvO03")
            }
        }

        Image {
            id: bilibili
            width: 50
            height: 50
            anchors.bottom: parent.bottom
            source: "qrc:/res/bilibili.png"

            MouseArea{
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://space.bilibili.com/387426555")
            }
        }
    }

    KeyListenerSettingPage{
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: sidebar.right
        anchors.right: parent.right
        visible: root.pageIndex === 0
    }

    NetworkHelper{
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: sidebar.right
        anchors.right: parent.right
        visible: root.pageIndex === 1
    }
}
