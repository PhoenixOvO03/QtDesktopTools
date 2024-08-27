
import QtQuick

Rectangle {
    signal close()

    property int pageIndex: 0
    property string theme: "dark"

    id: root
    color: "transparent"

    Rectangle{ // 侧边栏
        id: sidebar
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        color: "#10000000"

        Image { // icon
            id: icon
            width: 50
            height: 50
            source: root.theme === "dark" ? "qrc:/res/ten_OvO.png" : "qrc:/res/ten_OvO_black.png"
        }

        Image { // Github主页
            id: github
            width: 25
            height: 25
            anchors.left: icon.right
            anchors.top: parent.top
            source: root.theme === "dark" ? "qrc:/res/github.png" : "qrc:/res/github_black.png"

            MouseArea{
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://github.com/PhoenixOvO03")
            }
        }

        Image { // B站主页
            id: bilibili
            width: 25
            height: 25
            anchors.left: icon.right
            anchors.bottom: parent.bottom
            source: root.theme === "dark" ? "qrc:/res/bilibili.png" : "qrc:/res/bilibili_black.png"

            MouseArea{
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://space.bilibili.com/387426555")
            }
        }

        ListView{ // 侧边栏列表
            id: sideList
            anchors.left: github.right
            anchors.right: closeBtn.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            clip: true
            interactive: false // 禁止滑动
            orientation: ListView.Horizontal

            model: ListModel{
                ListElement{imageName: "key"}
                ListElement{imageName: "web"}
            }

            delegate: Image{
                width: 50
                height: 50
                source: "qrc:res/" + imageName + (root.theme === "dark" ? ".png" : "_black.png")

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        sideList.currentIndex = index
                        root.pageIndex = index
                    }
                }
            }

            highlight: Rectangle{color: "#20ffffff"}
        }

        Image{ // 主题切换按钮
            id: themeSwitch
            width: 50
            height: 50
            anchors.right: closeBtn.left
            source: root.theme === "dark" ? "qrc:/res/moon.png" : "qrc:/res/sun.png"

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if (root.theme === "dark") root.theme = "light"
                    else root.theme = "dark"
                }
            }
        }

        Image{ // 关闭按钮
            id: closeBtn
            anchors.right: parent.right
            width: 50
            height: 50
            source: root.theme === "dark" ? "qrc:/res/close.png" : "qrc:/res/close_black.png"

            MouseArea{
                anchors.fill: parent
                onClicked: root.close()
            }
        }
    }

    Rectangle { // 页面
        id: page
        color: "transparent"
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.top: sidebar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        KeyListenerSettingPage{
            id: keyListenerSettingPage
            anchors.fill: parent
            visible: root.pageIndex === 0
            theme: root.theme
        }

        NetworkHelper{
            id: networkHelper
            anchors.fill: parent
            visible: root.pageIndex === 1
            theme: root.theme
        }
    }
}
