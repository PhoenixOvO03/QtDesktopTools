
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import ten.util.SocketListener
import ten.util.CacheManager

Item{
    property string ip: "127.0.0.1"
    property int port: 8080
    property string theme: "dark"

    onIpChanged: cacheManager.changeCache("ip", ip)
    onPortChanged: cacheManager.changeCache("port", port)

    id: root

    CacheManager{
        id: cacheManager
        Component.onCompleted: {
            var socketCache = cacheManager.loadCache('socket.json')
            root.ip = socketCache['ip']
            root.port = socketCache['port']
        }
    }

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
                color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox{ // 类型下拉框
                id: serverType
                width: 150
                height: 40
                model: ["TCP Server", "TCP Client"]
                background: Rectangle {
                    color: "transparent"
                    border.color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                    radius: 10
                }
                contentItem: Text { // 当前显示内容
                    leftPadding: 10
                    text: serverType.displayText
                    color: root.theme === "dark" ? "#80ffffff" : "#80000000"
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

            Button{ // 开始 停止
                property bool isStart: false

                id: startBtn
                text: isStart ? "停止" : "开始"
                width: 150
                height: 40
                background: Rectangle {
                    radius: height / 2
                    color: startBtn.isStart ? "red" : "green"
                    border.color: Qt.lighter(color)
                }
                onClicked: {
                    isStart = !isStart
                    if (isStart){
                        socket.start(serverType.currentIndex, root.ip, root.port)
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
                color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle{
                width: 200
                height: 40
                radius: height / 2
                color: "transparent"
                border.color: root.theme === "dark" ? "#80ffffff" : "#80000000"

                // 输入框
                TextInput{
                    id: ipInput
                    anchors.fill: parent
                    font.pixelSize: height * 0.5
                    font.family: "华文彩云"
                    color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                    clip: true
                    text: root.ip
                    onTextChanged: root.ip = text
                }
            }

            Text{
                text: "端口号"
                color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle{
                width: 200
                height: 40
                radius: height / 2
                color: "transparent"
                border.color: root.theme === "dark" ? "#80ffffff" : "#80000000"

                // 输入框
                TextInput{
                    id: portInput
                    anchors.fill: parent
                    font.pixelSize: height * 0.5
                    font.family: "华文彩云"
                    color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                    clip: true
                    text: root.port
                    onTextChanged: root.port = text
                }
            }
        }

        ScrollView { // 历史记录
            anchors.left: parent.left
            anchors.right: parent.right
            height: 250
            background: Rectangle{
                radius: 10
                color: "transparent"
                border.color: root.theme === "dark" ? "#80ffffff" : "#80000000"
            }

            TextArea {
                id: historyArea
                placeholderText: "暂无内容..."
                placeholderTextColor: root.theme === "dark" ? "#80ffffff" : "#80000000"
                wrapMode: TextArea.Wrap
                color: root.theme === "dark" ? "white" : "black"
                readOnly: true

                Button{
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10
                    width:30
                    height:30
                    onClicked: historyArea.text = ""
                    background: Rectangle{
                        radius: height / 2
                        color: "red"
                        border.color: Qt.lighter(color)
                    }
                }
            }
        }

        Row{ // 输入框 发送按钮
            spacing: 10

            ScrollView {
                width: 300
                height: 50
                background: Rectangle{
                    radius: 10
                    color: "transparent"
                    border.color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                }

                TextArea {
                    id: inputArea
                    placeholderText: "在此输入..."
                    placeholderTextColor: root.theme === "dark" ? "#80ffffff" : "#80000000"
                    wrapMode: TextArea.Wrap
                    color: root.theme === "dark" ? "white" : "black"
                }
            }

            Button{
                width: 150
                height: 50
                text: "发送"
                onClicked: {
                    if (startBtn.isStart) {
                        socket.sendData(inputArea.text)
                    }
                }
                background: Rectangle{
                    radius: height / 2
                    color: "green"
                    border.color: Qt.lighter(color)
                }
            }
        }
    }
}
