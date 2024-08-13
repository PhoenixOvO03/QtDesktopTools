import QtQuick
import QtQuick.Window
import ten.util.KeyboardListener

Window {
    property color backgroundColor: "#80808080"
    property color keyColor: "#80C0C0C0"
    property color textColor: "black"
    property ListModel keyArray: ListModel{
        ListElement{
            keyText: "开始"
        }
    }

    KeyboardListener{
        onKeyPressed: function(topKey, bottomKey) {
            if (bottomKey === "") root.keyArray.append({"keyText": topKey})
            else root.keyArray.append({"keyText": topKey + "\n" + bottomKey})
        }
    }

    function setStyle(backgroundColor, keyColor, textColor){
        root.backgroundColor = backgroundColor
        root.keyColor = keyColor
        root.textColor = textColor
    }

    id: root
    x: 100
    y: Screen.desktopAvailableHeight - 200
    width: 100 * keyArray.count
    height: 100
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    Rectangle { // 背景
        anchors.fill: parent
        visible: true
        radius: 25
        color: root.backgroundColor

        ListView
        {
            anchors.fill: parent
            anchors.margins: 10
            model: root.keyArray
            spacing: 20

            delegate: Rectangle{
                width: 80
                height: 80
                radius: 25
                anchors.margins: 25
                color: root.keyColor
                visible: true

                Text {
                    text: keyText
                    anchors.centerIn: parent
                    color: root.textColor
                    font.pixelSize: 15
                }

                Timer{
                    interval: 3000
                    running: true
                    onTriggered: root.keyArray.remove(index)
                }
            }

            interactive: false // 禁止滑动
            orientation: Qt.Horizontal // 水平方向
        }
    }
}
