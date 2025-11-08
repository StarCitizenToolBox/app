/// ------- Request Interceptor Script --------------
/// 轻量级网络请求拦截器，不破坏网页正常功能
(function() {
    'use strict';
    
    if (window._sctRequestInterceptorInstalled) {
        console.log('[SCToolbox] Request interceptor already installed');
        return;
    }
    window._sctRequestInterceptorInstalled = true;
    
    // 被屏蔽的域名和路径
    const blockedPatterns = [
        'google-analytics.com',
        'www.google.com/ccm/collect',
        'www.google.com/pagead',
        'www.google.com/ads',
        'googleapis.com',
        'doubleclick.net',
        'reddit.com/rp.gif',
        'alb.reddit.com',
        'pixel-config.reddit.com',
        'conversions-config.reddit.com',
        'redditstatic.com/ads',
        'analytics.tiktok.com',
        'googletagmanager.com',
        'facebook.com',
        'facebook.net',
        'gstatic.com/firebasejs'
    ];
    
    // 判断 URL 是否应该被屏蔽
    const shouldBlock = (url) => {
        if (!url || typeof url !== 'string') return false;
        const urlLower = url.toLowerCase();
        return blockedPatterns.some(pattern => urlLower.includes(pattern.toLowerCase()));
    };
    
    // 记录被拦截的请求
    const logBlocked = (type, url) => {
        console.log(`[SCToolbox] ❌ Blocked ${type}:`, url);
    };
    
    const TRANSPARENT_GIF = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';
    
    // ============ 1. 拦截 Fetch API ============
    const originalFetch = window.fetch;
    window.fetch = function(...args) {
        const url = typeof args[0] === 'string' ? args[0] : args[0]?.url;
        if (shouldBlock(url)) {
            logBlocked('fetch', url);
            return Promise.reject(new Error('Blocked by SCToolbox'));
        }
        return originalFetch.apply(this, args);
    };
    
    // ============ 2. 拦截 XMLHttpRequest ============
    const OriginalXHR = window.XMLHttpRequest;
    const originalXHROpen = OriginalXHR.prototype.open;
    const originalXHRSend = OriginalXHR.prototype.send;
    
    OriginalXHR.prototype.open = function(method, url, ...rest) {
        this._url = url;
        if (shouldBlock(url)) {
            logBlocked('XHR', url);
            this._blocked = true;
        }
        return originalXHROpen.apply(this, [method, url, ...rest]);
    };
    
    OriginalXHR.prototype.send = function(...args) {
        if (this._blocked) {
            setTimeout(() => {
                const errorEvent = new Event('error');
                this.dispatchEvent(errorEvent);
            }, 0);
            return;
        }
        return originalXHRSend.apply(this, args);
    };
    
    // ============ 3. 拦截 Image 元素的 src 属性 ============
    const imgSrcDescriptor = Object.getOwnPropertyDescriptor(HTMLImageElement.prototype, 'src');
    if (imgSrcDescriptor && imgSrcDescriptor.set) {
        Object.defineProperty(HTMLImageElement.prototype, 'src', {
            get: imgSrcDescriptor.get,
            set: function(value) {
                if (shouldBlock(value)) {
                    logBlocked('IMG.src', value);
                    // 设置为透明 GIF，避免请求
                    imgSrcDescriptor.set.call(this, TRANSPARENT_GIF);
                    this.style.cssText += 'display:none !important;width:0;height:0;';
                    return;
                }
                return imgSrcDescriptor.set.call(this, value);
            },
            configurable: true,
            enumerable: true
        });
    }
    
    // ============ 3.5. 拦截 Script 元素的 src 属性 ============
    const scriptSrcDescriptor = Object.getOwnPropertyDescriptor(HTMLScriptElement.prototype, 'src');
    if (scriptSrcDescriptor && scriptSrcDescriptor.set) {
        Object.defineProperty(HTMLScriptElement.prototype, 'src', {
            get: scriptSrcDescriptor.get,
            set: function(value) {
                if (shouldBlock(value)) {
                    logBlocked('SCRIPT.src', value);
                    // 阻止加载，不设置 src
                    this.type = 'javascript/blocked';
                    return;
                }
                return scriptSrcDescriptor.set.call(this, value);
            },
            configurable: true,
            enumerable: true
        });
    }
    
    // ============ 4. 拦截 setAttribute（用于 img.setAttribute('src', ...)）============
    const originalSetAttribute = Element.prototype.setAttribute;
    Element.prototype.setAttribute = function(name, value) {
        if (name.toLowerCase() === 'src' && this.tagName === 'IMG' && shouldBlock(value)) {
            logBlocked('IMG setAttribute', value);
            originalSetAttribute.call(this, name, TRANSPARENT_GIF);
            this.style.cssText += 'display:none !important;width:0;height:0;';
            return;
        }
        if (name.toLowerCase() === 'src' && this.tagName === 'SCRIPT' && shouldBlock(value)) {
            logBlocked('SCRIPT setAttribute', value);
            return; // 阻止设置
        }
        return originalSetAttribute.call(this, name, value);
    };
    
    // ============ 5. 拦截 navigator.sendBeacon ============
    if (navigator.sendBeacon) {
        const originalSendBeacon = navigator.sendBeacon.bind(navigator);
        navigator.sendBeacon = function(url, data) {
            if (shouldBlock(url)) {
                logBlocked('sendBeacon', url);
                return true; // 假装成功
            }
            return originalSendBeacon(url, data);
        };
    }
    
    // ============ 6. 使用 MutationObserver 监听动态添加的元素 ============
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            mutation.addedNodes.forEach((node) => {
                if (node.nodeType !== 1) return; // 只处理元素节点
                
                try {
                    // 检查 IMG 元素
                    if (node.tagName === 'IMG') {
                        const src = node.getAttribute('src') || node.src;
                        if (src && shouldBlock(src)) {
                            logBlocked('Dynamic IMG', src);
                            node.src = TRANSPARENT_GIF;
                            node.style.cssText += 'display:none !important;width:0;height:0;';
                        }
                    }
                    // 检查 SCRIPT 元素
                    else if (node.tagName === 'SCRIPT') {
                        const src = node.getAttribute('src');
                        if (src && shouldBlock(src)) {
                            logBlocked('Dynamic SCRIPT', src);
                            node.type = 'javascript/blocked';
                            node.removeAttribute('src');
                        }
                    }
                    // 检查 IFRAME 元素
                    else if (node.tagName === 'IFRAME') {
                        const src = node.getAttribute('src');
                        if (src && shouldBlock(src)) {
                            logBlocked('Dynamic IFRAME', src);
                            node.src = 'about:blank';
                            node.style.cssText += 'display:none !important;';
                        }
                    }
                    
                    // 递归检查子元素
                    if (node.querySelectorAll) {
                        node.querySelectorAll('img').forEach(img => {
                            const src = img.getAttribute('src') || img.src;
                            if (src && shouldBlock(src)) {
                                logBlocked('Child IMG', src);
                                img.src = TRANSPARENT_GIF;
                                img.style.cssText += 'display:none !important;width:0;height:0;';
                            }
                        });
                        
                        node.querySelectorAll('script[src]').forEach(script => {
                            const src = script.getAttribute('src');
                            if (src && shouldBlock(src)) {
                                logBlocked('Child SCRIPT', src);
                                script.type = 'javascript/blocked';
                                script.removeAttribute('src');
                            }
                        });
                    }
                } catch (e) {
                    // 忽略错误
                }
            });
        });
    });
    
    // 延迟启动 observer，等待页面初始化完成
    const startObserver = () => {
        if (document.body) {
            observer.observe(document.documentElement, {
                childList: true,
                subtree: true
            });
            console.log('[SCToolbox] ✅ MutationObserver started');
        } else {
            setTimeout(startObserver, 50);
        }
    };
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startObserver);
    } else {
        startObserver();
    }
    
    console.log('[SCToolbox] ✅ Request interceptor installed');
    console.log('[SCToolbox] 🛡️  Blocking', blockedPatterns.length, 'patterns');
})();
