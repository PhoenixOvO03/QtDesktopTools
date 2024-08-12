import QtQuick

import ten.util.KeyboardListener

Rectangle {
    id: root
    width: 200
    height: 100
    visible: true
    radius: 25
    color: "#80808080"

    Text {
        id: keyText
        text: "按下任意键"
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 20
    }

    KeyboardListener{
        onKeyPressed: function(pressedKey) {
            keyText.text = pressedKey
        }
    }
}
