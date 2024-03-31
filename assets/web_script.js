/// ------- WebLocalization Script --------------
let SCLocalizationReplaceLocalesMap = {};
let enable_webview_localization_capture = false;
let SCLocalizationEnableSplitMode = false;

function InitWebLocalization() {
    let scriptTimeAgo = document.createElement('script');
    scriptTimeAgo.src = 'https://cdn.bootcdn.net/ajax/libs/timeago.js/4.0.2/timeago.full.min.js';
    document.head.appendChild(scriptTimeAgo);
    if (typeof $ === 'undefined') {
        let scriptJquery = document.createElement('script');
        scriptJquery.src = 'https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js';
        document.head.appendChild(scriptJquery);
    }
    LocalizationWatchUpdate();
}

function LocalizationWatchUpdate() {
    const m = window.MutationObserver || window.WebKitMutationObserver;
    const observer = new m(function (mutations, observer) {
        for (let mutationRecord of mutations) {
            for (let node of mutationRecord.addedNodes) {
                traverseElement(node);
            }
        }
    });

    observer.observe(document.body, {
        subtree: true,
        characterData: true,
        childList: true,
    });

    if (window.location.href.includes("robertsspaceindustries.com")) {
        console.log("SCLocalizationEnableSplitMode = true");
        SCLocalizationEnableSplitMode = true;
    }

    if (window.location.hostname.includes("www.erkul.games")) {
        document.body.addEventListener("click", function (event) {
            setTimeout(function () {
                allTranslate().then(_ => {
                });
            }, 200);
        });
    }
}

function WebLocalizationUpdateReplaceWords(w, b) {
    enable_webview_localization_capture = b;
    let replaceWords = w.sort(function (a, b) {
        return b.word.length - a.word.length;
    });
    replaceWords.forEach(({word, replacement}) => {
        SCLocalizationReplaceLocalesMap[word] = replacement;
    });
    if (window.location.hostname.startsWith("issue-council.robertsspaceindustries.com")) {
        SCLocalizationReplaceLocalesMap["save"] = "保存";
    }
    allTranslate().then(_ => {
    });
    // console.log("WebLocalizationUpdateReplaceWords ==" + w)
}

async function allTranslate() {
    async function replaceTextNode(node1) {
        if (node1.nodeType === Node.TEXT_NODE) {
            node1.nodeValue = GetSCLocalizationTranslateString(node1.nodeValue);
        } else {
            for (let i = 0; i < node1.childNodes.length; i++) {
                await replaceTextNode(node1.childNodes[i]);
            }
        }
    }

    await replaceTextNode(document.body);
}

function traverseElement(el) {
    if (!shouldTranslateEl(el)) {
        return
    }

    for (const child of el.childNodes) {
        if (["RELATIVE-TIME", "TIME-AGO"].includes(el.tagName)) {
            translateRelativeTimeEl(el);
            return;
        }

        if (child.nodeType === Node.TEXT_NODE) {
            translateElement(child);
        } else if (child.nodeType === Node.ELEMENT_NODE) {
            if (child.tagName === "INPUT") {
                translateElement(child);
            } else {
                traverseElement(child);
            }
        } else {
            // pass
        }
    }
}

function translateElement(el) {
    // Get the text field name
    let k;
    if (el.tagName === "INPUT") {
        if (el.type === 'button' || el.type === 'submit') {
            k = 'value';
        } else {
            k = 'placeholder';
        }
    } else {
        k = 'data';
    }
    el[k] = GetSCLocalizationTranslateString(el[k]);
}

function translateRelativeTimeEl(el) {
    const lang = (navigator.language || navigator.userLanguage);
    const datetime = $(el).attr('datetime');
    $(el).text(timeago.format(datetime, lang.replace('-', '_')));
}

function shouldTranslateEl(el) {
    const blockIds = [];
    const blockClass = [
        "css-truncate" // 过滤文件目录
    ];
    const blockTags = ["IMG", "svg", "mat-icon"];
    if (blockTags.includes(el.tagName)) {
        return false;
    }
    if (el.id && blockIds.includes(el.id)) {
        return false;
    }
    if (el.classList) {
        for (let clazz of blockClass) {
            if (el.classList.contains(clazz)) {
                return false;
            }
        }
    }
    return true;
}

function GetSCLocalizationTranslateString(txtSrc) {
    let oldTxtSrc = txtSrc
    const key = txtSrc.toLowerCase().replace(/\xa0/g, ' ').replace(/\s{2,}/g, ' ').trim();
    const sourceKey = txtSrc.replace(/\xa0/g, ' ').replace(/\s{2,}/g, ' ').trim();
    let noTheKey = key.replace("the ", "");
    let noHorizontalKey = key.replace("- ", "");

    if (SCLocalizationReplaceLocalesMap[key]) {
        txtSrc = SCLocalizationReplaceLocalesMap[key]
    } else if (SCLocalizationEnableSplitMode) {
        if (sourceKey.includes(" - ")) {
            let nodeValue = txtSrc
            let splitKey = sourceKey.split(" - ");
            if (splitKey[0].toLowerCase() === "upgrade" && key.includes("to") && key.endsWith("edition")) {
                // 升级包规则
                let noVersionStr = key.replace("STANDARD EDITION".toLowerCase(), "").replace("upgrade", "").replace("WARBOND EDITION".toLowerCase(), "")
                let shipNames = noVersionStr.split(" to ")
                let finalString = "升级包 " + GetSCLocalizationTranslateString(shipNames[0]) + " 到 " + GetSCLocalizationTranslateString(shipNames[1]);
                if (key.endsWith("WARBOND EDITION".toLowerCase())) {
                    finalString = finalString + " 战争债券版"
                } else {
                    finalString = finalString + " 标准版"
                }
                txtSrc = finalString
            } else {
                // 机库通用规则
                splitKey.forEach(function (splitKey) {
                    if (SCLocalizationReplaceLocalesMap[splitKey.toLowerCase()]) {
                        nodeValue = nodeValue.replace(splitKey, SCLocalizationReplaceLocalesMap[splitKey.toLowerCase()])
                    } else {
                        nodeValue = nodeValue.replace(splitKey, GetSCLocalizationTranslateString(splitKey))
                    }
                });
                txtSrc = nodeValue
            }
        } else if (key.endsWith("starter pack") || key.endsWith("starter package")) {
            let shipName = key.replace("starter package", "").replace("starter pack", "").trim()
            if (SCLocalizationReplaceLocalesMap[shipName.toLowerCase()]) {
                shipName = SCLocalizationReplaceLocalesMap[shipName.toLowerCase()];
            }
            txtSrc = shipName + " 新手包";
        } else if (key.startsWith("the ") && SCLocalizationReplaceLocalesMap[noTheKey]) {
            txtSrc = SCLocalizationReplaceLocalesMap[noTheKey];
        } else if (key.startsWith("- ") && SCLocalizationReplaceLocalesMap[noHorizontalKey]) {
            txtSrc = "- " + SCLocalizationReplaceLocalesMap[noHorizontalKey];
        }
    }
    if (oldTxtSrc === txtSrc) {
        ReportUnTranslate(key, txtSrc);
    }
    return txtSrc
}

InitWebLocalization();

function ReportUnTranslate(k, v) {

    if (enable_webview_localization_capture) {
        const cnPattern = /[\u4e00-\u9fa5]/;
        const enPattern = /[a-zA-Z]/;
        const htmlPattern = /<[^>]*>/;
        const cssRegex = /(?:^|[^<])<style[^>]*>[\s\S]*?<\/style>(?:[^>]|$)/i;
        const jsRegex = /(?:^|[^<])<script[^>]*>[\s\S]*?<\/script>(?:[^>]|$)/i;
        if (k.trim() !== "" && !cnPattern.test(k) && !htmlPattern.test(k) && !cssRegex.test(k) && !jsRegex.test(k)
            && enPattern.test(k) && !k.startsWith("http://") && !k.startsWith("https://")) {
            window.chrome.webview.postMessage({action: 'webview_localization_capture', key: k, value: v});
        }
    }
}

InitWebLocalization();


/// ----- Login Script ----
async function getRSILauncherToken(channelId) {
    if (!window.location.href.includes("robertsspaceindustries.com")) return;

    if (window.location.href.startsWith("https://robertsspaceindustries.com/connect")) {
        $(function () {
            $('#email').on('input', function () {
                let inputEmail = $('#email').val()
                sessionStorage.setItem('inputEmail', inputEmail);
            });
            $('#password').on('input', function () {
                let inputPassword = $('#password').val()
                sessionStorage.setItem('inputPassword', inputPassword);
            });
        });
    }

    // check login
    let r = await fetch("api/launcher/v3/account/check", {
        method: 'POST', headers: {
            'x-rsi-token': $.cookie('Rsi-Token'),
        },
    });
    if (r.status !== 200) {
        // wait login
        window.chrome.webview.postMessage({action: 'webview_rsi_login_show_window'});
        return;
    }

    SCTShowToast("登录游戏中...");

    // get claims
    let claimsR = await fetch("api/launcher/v3/games/claims", {
        method: 'POST', headers: {
            'x-rsi-token': $.cookie('Rsi-Token'),
        },
    });
    if (claimsR.status !== 200) return;
    let claimsData = (await claimsR.json())["data"];

    let tokenFormData = new FormData();
    tokenFormData.append('claims', claimsData);
    tokenFormData.append('gameId', 'SC');
    let tokenR = await fetch("api/launcher/v3/games/token", {
        method: 'POST', headers: {
            'x-rsi-token': $.cookie('Rsi-Token'),
        },
        body: tokenFormData
    });

    if (tokenR.status !== 200) return;
    let TokenData = (await tokenR.json())["data"]["token"];
    console.log(TokenData);

    // get release Data
    let releaseFormData = new FormData();
    releaseFormData.append("channelId", channelId);
    releaseFormData.append("claims", claimsData);
    releaseFormData.append("gameId", "SC");
    releaseFormData.append("platformId", "prod");
    let releaseR = await fetch("api/launcher/v3/games/release", {
        method: 'POST', headers: {
            'x-rsi-token': $.cookie('Rsi-Token'),
        },
        body: releaseFormData
    });
    if (releaseR.status !== 200) return;
    let releaseDataJson = (await releaseR.json())['data'];
    console.log(releaseDataJson);
    // get game library
    let libraryR = await fetch("api/launcher/v3/games/library", {
        method: 'POST', headers: {
            'x-rsi-token': $.cookie('Rsi-Token'),
        },
        body: releaseFormData
    });

    let libraryData = (await libraryR.json())["data"]

    // get user avatar
    let $avatarElement = $(".c-account-sidebar__profile-metas-avatar");
    let avatarUrl = $avatarElement.css("background-image");

    //post message
    window.chrome.webview.postMessage({
        action: 'webview_rsi_login_success', data: {
            'webToken': $.cookie('Rsi-Token'),
            'claims': claimsData,
            'authToken': TokenData,
            'releaseInfo': releaseDataJson,
            "avatar": avatarUrl,
            'libraryData': libraryData,
            "inputEmail": sessionStorage.getItem("inputEmail"),
            "inputPassword": sessionStorage.getItem("inputPassword")
        }
    });
}

function RSIAutoLogin(email, pwd) {
    if (!window.location.href.includes("robertsspaceindustries.com")) return;
    $(function () {
        if (email !== "") {
            $('#email').val(email)
        }
        if (pwd !== "") {
            $('#password').val(pwd)
        }
        sessionStorage.setItem('inputPassword', '');
        if (email !== "" && pwd !== "") {
            $("#remember").prop("checked", true);
            $('.c-formLegacyEnlist__submit-button-label').click();
        }
    });
}

function SCTShowToast(message) {
    let m = document.createElement('div');
    m.innerHTML = message;
    m.style.cssText = "font-family:siyuan;max-width:60%;min-width: 150px;padding:0 14px;height: 40px;color: rgb(255, 255, 255);line-height: 40px;text-align: center;border-radius: 4px;position: fixed;top: 50%;left: 50%;transform: translate(-50%, -50%);z-index: 999999;background: rgba(0, 0, 0,.7);font-size: 16px;";
    document.body.appendChild(m);
    setTimeout(function () {
        let d = 0.5;
        m.style.webkitTransition = '-webkit-transform ' + d + 's ease-in, opacity ' + d + 's ease-in';
        m.style.opacity = '0';
        setTimeout(function () {
            document.body.removeChild(m)
        }, d * 1000);
    }, 3500);

}