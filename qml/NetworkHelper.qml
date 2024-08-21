
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import ten.util.SocketListener

Item{
    id: root

    SocketListener{
        id: socket
        onRecvData: function(data){
            historyArea.text = "recv:" + data + '\n' + historyArea.text
        }
    }

    Column{
        spacing: 10

        Row{ // 类型 开关
            spacing: 10

            Text{
                text: "类型"
                color: "#80ffffff"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox{
                id: serverType
                width: 150
                height: 40
                model: ["TCP Server", "TCP Client"]
                background: Rectangle {
                    color: "transparent"
                    border.color: "#80ffffff"
                    radius: 10
                }
                contentItem: Text { // 当前显示内容
                    leftPadding: 10
                    text: serverType.displayText
                    color: "#80ffffff"
                    verticalAlignment: Text.AlignVCenter
                }
                delegate: ItemDelegate { // 下拉框选项
                    width: serverType.width
                    contentItem: Text {
                        text: modelData
                        color: "black"
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: serverType.highlightedIndex === index
                }
            }

            ClickBtn{
                property bool isStart: false

                id: startBtn
                width: 150
                height: 40
                btnText: isStart ? "停止" : "开始"
                btnColor: isStart ? "red" : "green"
                onClicked: {
                    isStart = !isStart
                    if (isStart){
                        socket.start(serverType.currentIndex, ip.content, port.content)
                    }else{
                        socket.stop()
                    }
                }
            }
        }

        Row{ // IP地址 端口号
            spacing: 10

            Text{
                text: "IP地址"
                color: "#80ffffff"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            LineEdit{
                id: ip
                width: 200
                height: 40
                content: "127.0.0.1"
            }

            Text{
                text: "端口号"
                color: "#80ffffff"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            LineEdit{
                id: port
                width: 100
                height: 40
                content: "8080"
            }
        }

        ScrollView { // 历史记录
            anchors.left: parent.left
            anchors.right: parent.right
            height: 250
            background: Rectangle{
                radius: 10
                color: "#80444444"
                border.color: "#80ffffff"
            }

            TextArea {
                id: historyArea
                placeholderText: "暂无内容..."
                placeholderTextColor: "#80ffffff"
                wrapMode: TextArea.Wrap
                color: "white"
                readOnly: true
            }
        }

        Row{ // 输入框 发送按钮
            spacing: 10

            ScrollView {
                width: 300
                height: 50
                background: Rectangle{
                    radius: 10
                    color: "#80444444"
                    border.color: "#80ffffff"
                }

                TextArea {
                    id: inputArea
                    placeholderText: "在此输入..."
                    placeholderTextColor: "#80ffffff"
                    wrapMode: TextArea.Wrap
                    color: "white"
                }
            }

            ClickBtn{
                width: 150
                height: 50
                btnText: "发送"
                btnColor: "green"
                onClicked: {
                    if (startBtn.isStart) {
                        // historyArea.text = inputArea.text + "\n" + historyArea.text
                        socket.sendData(inputArea.text)
                    }
                }
            }
        }
    }
}
