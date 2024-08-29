
import QtQuick
import QtQuick.Shapes

Rectangle {
    signal close()
    signal skinChanged(string topLeft, string bottomRight, string theme, int index)

    property int skinIndex: 0
    property int pageIndex: 0
    property string theme: "dark"
    onThemeChanged: {
        var skinObject = skinSetting.model.get(skinSetting.currentIndex)
        if (root.theme === "dark") root.skinChanged(skinObject['leftDark'], skinObject['rightDark'], root.theme, root.skinIndex)
        else root.skinChanged(skinObject['leftLight'], skinObject['rightLight'], root.theme, root.skinIndex)
    }

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
                ListElement{imageName: "skin"}
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

            highlight: Rectangle{
                color: root.theme === "dark" ? "#20ffffff" : "#20000000"
            }
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

    Rectangle{ // 设置主题
        visible: root.pageIndex === 2
        anchors.top: sidebar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 20
        color: "transparent"

        GridView{
            id: skinSetting
            anchors.fill: parent
            clip: true
            cellWidth: root.width / 4 - 6
            cellHeight: cellWidth
            currentIndex: root.skinIndex

            model: ListModel{
                ListElement{ leftLight: "#c0FFF3FF"; rightLight: "#c0D8EAFF"; leftDark: "#c0604962"; rightDark: "#c00C1824" }
                ListElement{ leftLight: "#c0F2F2F2"; rightLight: "#c0F2F2F2"; leftDark: "#c0111111"; rightDark: "#c0111111" }
                ListElement{ leftLight: "#c0D0F3FF"; rightLight: "#c0FEFEFF"; leftDark: "#c0628D9B"; rightDark: "#c082AFC2" }
                ListElement{ leftLight: "#c0FFDDEF"; rightLight: "#c0F4FEE7"; leftDark: "#c085707A"; rightDark: "#c0798967" }
                ListElement{ leftLight: "#c0F7CEC5"; rightLight: "#c0B4EAB2"; leftDark: "#c0776E78"; rightDark: "#c0597171" }
                ListElement{ leftLight: "#c082E8A3"; rightLight: "#c0B6FAB7"; leftDark: "#c05EB57D"; rightDark: "#c06A9377" }
                ListElement{ leftLight: "#c0EEC0A2"; rightLight: "#c0FFE9B3"; leftDark: "#c0E9A276"; rightDark: "#c0F68F64" }
                ListElement{ leftLight: "#c0FFDF92"; rightLight: "#c0EFE5F9"; leftDark: "#c0735C16"; rightDark: "#c038323F" }
                ListElement{ leftLight: "#c0A8F688"; rightLight: "#c0FBFBF7"; leftDark: "#c03F612F"; rightDark: "#c04F3242" }
                ListElement{ leftLight: "#c0DDD7FD"; rightLight: "#c0BDF9B2"; leftDark: "#c04A4873"; rightDark: "#c02A4129" }
                ListElement{ leftLight: "#c0FCC9F0"; rightLight: "#c04DFCF3"; leftDark: "#c0653E61"; rightDark: "#c0174241" }
                ListElement{ leftLight: "#c0B2D4FE"; rightLight: "#c0E8C5F5"; leftDark: "#c0456EA6"; rightDark: "#c08A5A91" }
            }

            delegate: Shape {
                width: root.width / 4 - 26
                height: width
                ShapePath {
                    strokeWidth: -1 // 不描边
                    fillGradient: LinearGradient {
                        x1: 0; y1: 0
                        x2: width; y2: height
                        GradientStop { position: 0; color: root.theme === "dark" ? leftDark : leftLight }
                        GradientStop { position: 1; color: root.theme === "dark" ? rightDark : rightLight }
                    }
                    PathLine { x: width; y: 0 }
                    PathLine { x: width; y: height }
                    PathLine { x: 0; y: height }
                    PathLine { x: 0; y: 0 }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        skinSetting.currentIndex = index
                        root.skinIndex = index
                        if (root.theme === "dark") root.skinChanged(leftDark, rightDark, root.theme, index)
                        else root.skinChanged(leftLight, rightLight, root.theme, index)
                    }
                }
            }

            highlight: Rectangle{
                color: "transparent"
                border.color: root.theme === "dark" ? "white" : "black"
                border.width: 10
                z: skinSetting.z + 2

                Text{
                    anchors.centerIn: parent
                    font.pixelSize: parent.width / 8
                    text: "当前主题"
                    color: root.theme === "dark" ? "white" : "black"
                }
            }
        }
    }
}
