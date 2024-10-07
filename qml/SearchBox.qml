
import QtQuick

Item {
    property string theme: "dark"
    property bool isFolded: true
    
    id: root
    width: isFolded ? 50 : 500
    height: 50

    onWidthChanged: if (width === 50) searchInput.focus = false // 折叠后取消编辑

    Behavior on width {
        NumberAnimation {
            duration: 500
        }
    }

    MouseArea{ // 进入区域展开侧边栏 离开折叠
        anchors.fill: parent
        hoverEnabled: true // 鼠标悬停
        propagateComposedEvents: true // 事件传播
        onEntered: root.isFolded = false
    }

    Rectangle{ // 输入框
        height: 50
        anchors.left: parent.left
        anchors.right: searchBtn.left
        color: "transparent"
        border.color: root.theme === "dark" ? "#ffffff" : "#000000"
        clip: true

        TextInput{
            id: searchInput
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: height * 0.5
            color: root.theme === "dark" ? "#ffffff" : "#000000"
            clip: true
            anchors.margins: 5
            // 按下回车键搜索
            Keys.onEnterPressed: Qt.openUrlExternally("https://cn.bing.com/search?q=" + searchInput.text)
            Keys.onReturnPressed: Qt.openUrlExternally("https://cn.bing.com/search?q=" + searchInput.text)
        }
    }

    Image { // 搜索按钮
        id: searchBtn
        width: 50
        height: 50
        anchors.right: parent.right
        source: root.theme === "dark" ? "qrc:/res/search.png" : "qrc:/res/search_black.png"

        MouseArea{
            anchors.fill: parent
            onClicked: Qt.openUrlExternally("https://cn.bing.com/search?q=" + searchInput.text)
        }
    }
}