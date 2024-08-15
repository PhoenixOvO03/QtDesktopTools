import QtQuick

// 单行输入框

Rectangle {
    property string content: ""
    onContentChanged: textInput.text = root.content

    id: root
    radius: height / 2
    color: "#80444444"
    border.color: "#80ffffff"

    // 输入框
    TextInput{
        id: textInput
        anchors.fill: parent
        font.pixelSize: height * 0.5
        font.family: "华文彩云"
        color: "white"
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        clip: true
        text: root.content

        onTextChanged: {
            // if (text === "") text = "0"
            // if (text > 255) text = 255
            // else if (text < 0) text = 0
            root.content = text
        }
    }

    function getText(){
        return textInput.text
    }
}
