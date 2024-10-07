
import QtQuick

ListView{
    property string theme: "dark"

    id: root
    height: model.count * 50
    width: 5
    clip: true
    interactive: false // 禁止滑动
    currentIndex: -1
    model: ListModel{
        ListElement{imageName: "key"}
        ListElement{imageName: "web"}
        ListElement{imageName: "skin"}
    }

    Behavior on width {
        NumberAnimation {
            duration: 500
        }
    }

    Rectangle{ // 背景
        anchors.fill: parent
        color: root.theme === "dark" ? "#40ffffff" : "#40000000"
    }

    delegate: Image{
        width: 50
        height: 50
        source: "qrc:res/" + imageName + (root.theme === "dark" ? ".png" : "_black.png")

        MouseArea{
            anchors.fill: parent
            onClicked: root.currentIndex = index
        }
    }

    highlight: Rectangle{
        color: root.theme === "dark" ? "#40ffffff" : "#40000000"
    }

    MouseArea{ // 进入区域展开侧边栏 离开折叠
        anchors.fill: parent
        hoverEnabled: true // 鼠标悬停
        propagateComposedEvents: true // 事件传播
        onEntered: root.width = 50
        onExited: root.width = 5
    }
}
