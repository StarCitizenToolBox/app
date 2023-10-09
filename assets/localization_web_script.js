/// https://github.com/CxJuice/Uex_Chinese_Translate

let replaceLocalesMap = {"k": "v"};

let enable_webview_localization_capture = false;

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
    if (window.location.hostname.includes("www.erkul.games") || window.location.hostname.includes("ccugame.app")) {
        document.body.addEventListener("click", function (event) {
            setTimeout(function () {
                allTranslate().then(_ => {
                })
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
        replaceLocalesMap[word] = replacement;
    });
    allTranslate().then(_ => {
    })
    // console.log("WebLocalizationUpdateReplaceWords ==" + w)
}

async function allTranslate() {
    async function replaceTextNode(node1) {
        if (node1.nodeType === Node.TEXT_NODE) {
            let nodeValue = node1.nodeValue;
            const key = nodeValue.trim().toLowerCase()
                .replace(/\xa0/g, ' ') // replace '&nbsp;'
                .replace(/\s{2,}/g, ' ');
            if (replaceLocalesMap[key]) {
                nodeValue = replaceLocalesMap[key]
            } else {
                ReportUnTranslate(key, node1.nodeValue);
            }
            node1.nodeValue = nodeValue;
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

    const txtSrc = el[k].trim();
    const key = txtSrc.toLowerCase()
        .replace(/\xa0/g, ' ') // replace '&nbsp;'
        .replace(/\s{2,}/g, ' ');
    if (replaceLocalesMap[key]) {
        el[k] = el[k].replace(txtSrc, replaceLocalesMap[key])
    } else {
        ReportUnTranslate(key, txtSrc);
    }
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

function ReportUnTranslate(k, v) {
    const cnPattern = /[\u4e00-\u9fa5]/;
    const enPattern = /[a-zA-Z]/;
    const htmlPattern = /<[^>]*>/;
    const cssRegex = /(?:^|[^<])<style[^>]*>[\s\S]*?<\/style>(?:[^>]|$)/i;
    const jsRegex = /(?:^|[^<])<script[^>]*>[\s\S]*?<\/script>(?:[^>]|$)/i;
    if (enable_webview_localization_capture) {
        if (k.trim() !== "" && !cnPattern.test(k) && !htmlPattern.test(k) && !cssRegex.test(k) && !jsRegex.test(k)
            && enPattern.test(k) && !k.startsWith("http://") && !k.startsWith("https://")) {
            window.chrome.webview.postMessage({action: 'webview_localization_capture', key: k, value: v});
        }
    }
}

InitWebLocalization();