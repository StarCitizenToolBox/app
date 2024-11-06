async function init() {
    try {
        let response = await fetch("/api");
        let responseJson = await response.json();
        if (responseJson.status === "ok") {
            showMessage("服务连接成功！");
        } else {
            showMessage("服务连接失败！" + responseJson);
        }
    } catch (e) {
        showMessage("服务连接失败！" + e);
    }
}


async function onSendMessage() {
    let send_button = document.getElementById("send_button");
    let input = document.getElementById("input_message");
    let isAutoCopy = document.getElementById("auto_copy").checked;
    let messageJson = {
        "text": input.value,
        "autoCopy": isAutoCopy,
        "autoInput": false
    };
    send_button.loading = true;
    try {
        let response = await fetch("/api/send", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(messageJson)
        });
        let responseJson = await response.json();
        console.log(responseJson);
        showMessage(responseJson.message);
        if (response.ok) {
            input.value = "";
        }
    } catch (e) {
        showMessage("发送失败！" + e);
    }
    send_button.loading = false;
}

function showMessage(message) {
    let snack = document.getElementById("snackbar_message");
    snack.open = false;
    snack.innerText = message;
    snack.open = true;
}

function onShowHelp() {
    alert("在浏览器中输入文本，将发送给汉化盒子转码。" +
        "\n\n自动复制：勾选后自动复制转码结果到剪贴板。");
}