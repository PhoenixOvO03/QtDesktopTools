import QtQuick
import QtQuick.Window
import ten.util.KeyboardListener

Window {
    property color backgroundColor: "#80808080"
    property color keyColor: "#80C0C0C0"
    property color textColor: "black"
    property int stayTime: 3000
    property int locationIndex: 6
    property ListModel keyArray: ListModel{
        ListElement{
            keyText: "开始"
        }
    }

    function setStyle(backgroundColor, keyColor, textColor, stayTime, locationIndex){
        root.backgroundColor = backgroundColor
        root.keyColor = keyColor
        root.textColor = textColor
        root.stayTime = stayTime
        root.locationIndex = locationIndex
    }

    KeyboardListener{
        onKeyPressed: function(topKey, bottomKey) {
            if (bottomKey === "") root.keyArray.append({"keyText": topKey})
            else root.keyArray.append({"keyText": topKey + "\n" + bottomKey})
        }
    }

    id: root
    x: {
        if (locationIndex % 3 === 0) return 100
        else if (locationIndex % 3 === 1) return Screen.desktopAvailableWidth / 2 - keyArray.count * 50
        else return Screen.desktopAvailableWidth - 100 - keyArray.count * 100
    }

    y: {
        if (locationIndex / 3 < 1) return 100
        else if (locationIndex / 3 < 2) return Screen.desktopAvailableHeight / 2
        else return Screen.desktopAvailableHeight - 200
    }
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
                    interval: root.stayTime
                    running: true
                    onTriggered: root.keyArray.remove(index)
                }
            }

            interactive: false // 禁止滑动
            orientation: Qt.Horizontal // 水平方向
        }
    }
}
