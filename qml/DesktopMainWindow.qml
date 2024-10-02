
import QtQuick
import QtQuick.Shapes

import ten.util.CacheManager

Rectangle {
    signal foldBtnClicked(bool toFold)

    property bool isFolded: false // 窗口是否折叠
    property int pageIndex: -1 // 控制显示哪个页面
    property string theme: "dark"
    property int skinIndex: 0
    property color backLeftLight: "#FFF3FF"
    property color backRightLight: "#D8EAFF"
    property color backLeftDark: "#604962"
    property color backRightDark: "#0C1824"

    // 属性修改时保存到缓存
    onThemeChanged: cacheManager.changeCache("theme", theme)
    onSkinIndexChanged: cacheManager.changeCache("skinIndex", skinIndex)
    onBackLeftLightChanged: cacheManager.changeCache("backLeftLight", backLeftLight)
    onBackRightLightChanged: cacheManager.changeCache("backRightLight", backRightLight)
    onBackLeftDarkChanged: cacheManager.changeCache("backLeftDark", backLeftDark)
    onBackRightDarkChanged: cacheManager.changeCache("backRightDark", backRightDark)
    
    id: root
    color: "transparent"

    CacheManager{ // 主题缓存管理
        id: cacheManager
        Component.onCompleted: { // 部件加载完成时加载主题缓存
            var themeCache = cacheManager.loadCache("theme.json")
            root.theme = themeCache["theme"]
            root.skinIndex = themeCache["skinIndex"]
            root.backLeftLight = themeCache["backLeftLight"]
            root.backRightLight = themeCache["backRightLight"]
            root.backLeftDark = themeCache["backLeftDark"]
            root.backRightDark = themeCache["backRightDark"]
        }
    }

    MouseArea{ // 点击空白处关闭页面
        anchors.fill: parent
        onClicked: sidebar.pageIndex = -1
    }

    Background { // 渐变背景
        anchors.fill: parent
        topLeft: root.theme === "dark" ? root.backLeftDark : root.backLeftLight
        bottomRight: root.theme === "dark" ? root.backRightDark : root.backRightLight
    }

    Sidebar { // 侧边栏
        id: sidebar
        height: 50
        width: sideItems.count * 50
        anchors.horizontalCenter: root.horizontalCenter
        theme: root.theme
        onPageIndexChanged: root.pageIndex = pageIndex
    }

    Image { // 折叠窗口图标
        id: foldIcon
        width: 50
        height: 50
        source: root.theme === "dark" ? "qrc:/res/ten_OvO.png" : "qrc:/res/ten_OvO_black.png"

        MouseArea{
            anchors.fill: parent
            onClicked: {
                root.foldBtnClicked(!isFolded)
                root.isFolded = !root.isFolded
            }
        }
    }

    Rectangle { // 页面
        id: page
        color: "transparent"
        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent

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
        id: themeSetting
        visible: root.pageIndex === 2
        color: "transparent"
        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent

        GridView{
            id: skinSetting
            anchors.fill: parent
            clip: true
            cellWidth: themeSetting.width / 4 - 6
            cellHeight: cellWidth
            currentIndex: root.skinIndex

            model: ListModel{
                ListElement{ leftLight: "#FFF3FF"; rightLight: "#D8EAFF"; leftDark: "#604962"; rightDark: "#0C1824" }
                ListElement{ leftLight: "#F2F2F2"; rightLight: "#F2F2F2"; leftDark: "#111111"; rightDark: "#111111" }
                ListElement{ leftLight: "#D0F3FF"; rightLight: "#FEFEFF"; leftDark: "#628D9B"; rightDark: "#82AFC2" }
                ListElement{ leftLight: "#FFDDEF"; rightLight: "#F4FEE7"; leftDark: "#85707A"; rightDark: "#798967" }
                ListElement{ leftLight: "#F7CEC5"; rightLight: "#B4EAB2"; leftDark: "#776E78"; rightDark: "#597171" }
                ListElement{ leftLight: "#82E8A3"; rightLight: "#B6FAB7"; leftDark: "#5EB57D"; rightDark: "#6A9377" }
                ListElement{ leftLight: "#EEC0A2"; rightLight: "#FFE9B3"; leftDark: "#E9A276"; rightDark: "#F68F64" }
                ListElement{ leftLight: "#FFDF92"; rightLight: "#EFE5F9"; leftDark: "#735C16"; rightDark: "#38323F" }
                ListElement{ leftLight: "#A8F688"; rightLight: "#FBFBF7"; leftDark: "#3F612F"; rightDark: "#4F3242" }
                ListElement{ leftLight: "#DDD7FD"; rightLight: "#BDF9B2"; leftDark: "#4A4873"; rightDark: "#2A4129" }
                ListElement{ leftLight: "#FCC9F0"; rightLight: "#4DFCF3"; leftDark: "#653E61"; rightDark: "#174241" }
                ListElement{ leftLight: "#B2D4FE"; rightLight: "#E8C5F5"; leftDark: "#456EA6"; rightDark: "#8A5A91" }
            }

            delegate: Shape {
                width: themeSetting.width / 4 - 26
                height: width
                ShapePath {
                    strokeWidth: -1 // 不描边
                    fillGradient: LinearGradient {
                        x1: 0; y1: 0
                        x2: width; y2: height
                        GradientStop { position: 0; color: root.theme === "dark" ? leftDark : leftLight }
                        GradientStop { position: 1; color: root.theme === "dark" ? rightDark : rightLight }
                    }
                    startX: 0; startY: 0
                    PathLine { x: width; y: 0 }
                    PathLine { x: width; y: height }
                    PathLine { x: 0; y: height }
                    PathLine { x: 0; y: 0 }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.skinIndex = index
                        root.backLeftDark = leftDark
                        root.backRightDark = rightDark
                        root.backLeftLight = leftLight
                        root.backRightLight = rightLight
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

    Image { // Github主页
        id: github
        width: 25
        height: 25
        anchors.right: bilibili.left
        anchors.bottom: parent.bottom
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
        anchors.right: themeSwitch.left
        anchors.bottom: parent.bottom
        source: root.theme === "dark" ? "qrc:/res/bilibili.png" : "qrc:/res/bilibili_black.png"

        MouseArea{
            anchors.fill: parent
            onClicked: Qt.openUrlExternally("https://space.bilibili.com/387426555")
        }
    }

    Image{ // 主题切换按钮
        id: themeSwitch
        width: 50
        height: 50
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: root.theme === "dark" ? "qrc:/res/moon.png" : "qrc:/res/sun.png"

        MouseArea{
            anchors.fill: parent
            onClicked: {
                if (root.theme === "dark") root.theme = "light"
                else root.theme = "dark"
            }
        }
    }
}
