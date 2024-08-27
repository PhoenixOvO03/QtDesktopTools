import QtQuick

// 单行输入框

Rectangle {
    property string content: ""
    property color allColor: "#80ffffff"
    onContentChanged: textInput.text = root.content

    id: root
    radius: height / 2
    color: "transparent"
    border.color: root.allColor

    // 输入框
    TextInput{
        id: textInput
        anchors.fill: parent
        font.pixelSize: height * 0.5
        font.family: "华文彩云"
        color: root.allColor
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        clip: true
        text: root.content

        onTextChanged: root.content = text
    }

    function getText(){
        return textInput.text
    }
}
