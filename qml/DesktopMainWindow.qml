
import QtQuick
import QtQuick.Shapes

import ten.util.CacheManager

Rectangle {
    signal foldBtnClicked(bool toFold)

    property bool isFolded: false // 窗口是否折叠
    property int pageIndex: -1 // 控制显示哪个页面
    property string theme: "dark" // 主题
    property int skinIndex: 0 // 主题索引
    property color backLeftLight: "#FFF3FF" // 背景左上角亮色颜色
    property color backRightLight: "#D8EAFF" // 背景右下角亮色颜色
    property color backLeftDark: "#604962" // 背景左上角暗色颜色
    property color backRightDark: "#0C1824" // 背景右下角暗色颜色

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

    MouseArea{ // 点击空白处
        anchors.fill: parent
        onClicked: {
            sidebar.currentIndex = -1 // 关闭页面
            searchBox.isFolded = true // 折叠搜索框
        }
    }

    Background { // 渐变背景
        anchors.fill: parent
        topLeft: root.theme === "dark" ? root.backLeftDark : root.backLeftLight
        bottomRight: root.theme === "dark" ? root.backRightDark : root.backRightLight
    }

    Sidebar { // 侧边栏
        id: sidebar
        anchors.verticalCenter: root.verticalCenter
        theme: root.theme
        onCurrentIndexChanged: root.pageIndex = currentIndex
    }

    SearchBox { // 搜索框
        id: searchBox
        anchors.right: root.right
        theme: root.theme
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

        KeyListenerSettingPage{ // 监听按键设置页面
            id: keyListenerSettingPage
            anchors.fill: parent
            visible: root.pageIndex === 0
            theme: root.theme
        }

        NetworkHelper{ // 网络助手页面
            id: networkHelper
            anchors.fill: parent
            visible: root.pageIndex === 1
            theme: root.theme
        }

        SkinSetting{ // 主题设置页面
            id: skinSetting
            anchors.fill: parent
            visible: root.pageIndex === 2
            theme: root.theme
            currentIndex: root.skinIndex
            onCurrentIndexChanged: {
                root.skinIndex = currentIndex
                var skin = skinSetting.model.get(currentIndex)
                root.backLeftLight = skin.leftLight
                root.backRightLight = skin.rightLight
                root.backLeftDark = skin.leftDark
                root.backRightDark = skin.rightDark
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
