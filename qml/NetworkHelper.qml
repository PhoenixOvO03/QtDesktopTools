
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import ten.util.SocketListener
import ten.util.CacheManager

Item{
    property string ip: "127.0.0.1"
    property int port: 8080
    property string theme: "dark"

    onIpChanged: setConfig("ip", ip)
    onPortChanged: setConfig("port", port)

    function setConfig(key, value){
        ipEdit.content = ip
        portEdit.content = port
        cacheManager.changeCache(key, value)
    }

    id: root

    Component.onCompleted: {
        var socketCache = cacheManager.loadCache(CacheManager.SocketCache)
        root.ip = socketCache['ip']
        root.port = socketCache['port']
    }

    CacheManager{
        id: cacheManager
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

            ClickBtn{ // 开始 停止
                property bool isStart: false

                id: startBtn
                width: 150
                height: 40
                btnText: isStart ? "停止" : "开始"
                btnColor: isStart ? "red" : "green"
                onClicked: {
                    isStart = !isStart
                    if (isStart){
                        socket.start(serverType.currentIndex, ipEdit.content, portEdit.content)
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

            LineEdit{
                id: ipEdit
                width: 200
                height: 40
                content: root.ip
                allColor: root.theme === "dark" ? "#80ffffff" : "#80000000"
                onContentChanged: root.ip = content
            }

            Text{
                text: "端口号"
                color: root.theme === "dark" ? "#80ffffff" : "#80000000"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            LineEdit{
                id: portEdit
                width: 100
                height: 40
                content: root.port
                allColor: root.theme === "dark" ? "#80ffffff" : "#80000000"
                onContentChanged: root.port = content
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

                ClickBtn{
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10
                    width:30
                    height:30
                    btnColor: "red"
                    onClicked: historyArea.text = ""
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

            ClickBtn{
                width: 150
                height: 50
                btnText: "发送"
                btnColor: "green"
                onClicked: {
                    if (startBtn.isStart) {
                        socket.sendData(inputArea.text)
                    }
                }
            }
        }
    }
}
