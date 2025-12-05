// SCToolbox WebView initialization script
// Uses IPC (window.ipc.postMessage) to communicate with Rust backend
(function() {
    'use strict';
    
    if (window._sctInitialized) return;
    window._sctInitialized = true;
    
    // ========== IPC Communication ==========
    // Send message to Rust backend
    function sendToRust(type, payload) {
        if (window.ipc && typeof window.ipc.postMessage === 'function') {
            window.ipc.postMessage(JSON.stringify({ type, payload }));
        }
    }
    
    // ========== 导航栏 UI ==========
    const icons = {
        back: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M10 12L6 8L10 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>',
        forward: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M6 4L10 8L6 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>',
        reload: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M13.5 8C13.5 11.0376 11.0376 13.5 8 13.5C4.96243 13.5 2.5 11.0376 2.5 8C2.5 4.96243 4.96243 2.5 8 2.5C10.1012 2.5 11.9254 3.67022 12.8169 5.4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M10.5 5.5H13V3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>'
    };
    
    // Global state from Rust
    window._sctNavState = {
        canGoBack: false,
        canGoForward: false,
        isLoading: true,
        url: window.location.href
    };
    
    function createNavBar() {
        if (window.location.href === 'about:blank') return;
        if (document.getElementById('sct-navbar')) return;
        if (!document.body) {
            setTimeout(createNavBar, 50);
            return;
        }
        
        const nav = document.createElement('div');
        nav.id = 'sct-navbar';
        nav.innerHTML = `
            <style>
                #sct-navbar {
                    position: fixed;
                    top: 0.5rem; /* 8px */
                    left: 50%;
                    transform: translateX(-50%);
                    height: 2.25rem; /* 36px */
                    background: rgba(19, 36, 49, 0.95);
                    backdrop-filter: blur(0.75rem); /* 12px */
                    display: flex;
                    align-items: center;
                    padding: 0 0.5rem; /* 0 8px */
                    z-index: 2147483647;
                    font-family: 'Segoe UI', system-ui, sans-serif;
                    box-shadow: 0 0.125rem 0.75rem rgba(0,0,0,0.4); /* 0 2px 12px */
                    user-select: none;
                    border-radius: 0.5rem; /* 8px */
                    gap: 0.125rem; /* 2px */
                    border: 0.0625rem solid rgba(10, 49, 66, 0.8); /* 1px */
                }
                #sct-navbar button {
                    background: transparent;
                    border: none;
                    color: rgba(255,255,255,0.85);
                    width: 2rem; /* 32px */
                    height: 1.75rem; /* 28px */
                    border-radius: 0.25rem; /* 4px */
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.15s ease;
                    padding: 0;
                }
                #sct-navbar button:hover:not(:disabled) { background: rgba(10, 49, 66, 0.9); color: #fff; }
                #sct-navbar button:active:not(:disabled) { background: rgba(10, 49, 66, 1); transform: scale(0.95); }
                #sct-navbar button:disabled { opacity: 0.35; cursor: not-allowed; }
                #sct-navbar button svg { display: block; }
                #sct-navbar-url {
                    width: 16.25rem; /* 260px */
                    height: 1.625rem; /* 26px */
                    padding: 0 0.625rem; /* 0 10px */
                    border: 0.0625rem solid rgba(10, 49, 66, 0.6); /* 1px */
                    border-radius: 0.25rem; /* 4px */
                    background: rgba(0,0,0,0.25);
                    color: rgba(255,255,255,0.9);
                    font-size: 0.75rem; /* 12px */
                    outline: none;
                    text-overflow: ellipsis;
                    margin-left: 0.25rem; /* 4px */
                }
                #sct-navbar-url:focus { border-color: rgba(10, 49, 66, 1); background: rgba(0,0,0,0.35); }
                /* ---------- Spinner & Favicon Slot ---------- */
                #sct-spinner {
                    display: block; /* default: show spinner during loading */
                    width: 1.125rem; /* 18px */
                    height: 1.125rem; /* 18px */
                    border: 0.125rem solid rgba(255, 255, 255, 0.16); /* ~2px */
                    border-top-color: rgba(255, 255, 255, 0.92);
                    border-radius: 50%;
                    margin-left: 0.5rem;
                    -webkit-animation: sct-spin 0.8s linear infinite;
                    animation: sct-spin 0.8s linear infinite;
                    pointer-events: none;
                    align-self: center;
                    flex-shrink: 0;
                }
                #sct-favicon-slot {
                    display: none; /* hidden until page ready */
                    align-items: center;
                    justify-content: center;
                    width: 1.125rem; /* 18px - same as spinner */
                    height: 1.125rem; /* 18px - same as spinner */
                    margin-left: 0.5rem;
                    pointer-events: none;
                    flex-shrink: 0;
                }
                #sct-favicon {
                    width: 1.125rem; /* 18px */
                    height: 1.125rem; /* 18px */
                    object-fit: cover;
                    border-radius: 0.25rem; /* 4px */
                }
                @-webkit-keyframes sct-spin { to { -webkit-transform: rotate(360deg); } }
                @keyframes sct-spin { to { transform: rotate(360deg); } }
                @media (prefers-reduced-motion: reduce) {
                    #sct-spinner { -webkit-animation: none; animation: none; }
                }
            </style>
            <button id="sct-back" title="Back" disabled>${icons.back}</button>
            <button id="sct-forward" title="Forward" disabled>${icons.forward}</button>
            <button id="sct-reload" title="Reload">${icons.reload}</button>
            <div id="sct-spinner" role="progressbar" aria-hidden="false" aria-valuetext="Loading" title="Loading"></div>
            <div id="sct-favicon-slot"><img id="sct-favicon" src="" alt="Page icon" /></div>
            <input type="text" id="sct-navbar-url" readonly value="${window.location.href}" />
        `;
        document.body.insertBefore(nav, document.body.firstChild);
        
        // Navigation buttons - send commands to Rust
        document.getElementById('sct-back').onclick = () => {
            sendToRust('nav_back', {});
        };
        document.getElementById('sct-forward').onclick = () => {
            sendToRust('nav_forward', {});
        };
        document.getElementById('sct-reload').onclick = () => {
            sendToRust('nav_reload', {});
        };
        
        // Apply initial state from Rust
        updateNavBarFromState();
        
        // Request initial state from Rust
        sendToRust('get_nav_state', {});
    }
    
    // Update navbar UI based on state from Rust
    function updateNavBarFromState() {
        const state = window._sctNavState;
        const backBtn = document.getElementById('sct-back');
        const forwardBtn = document.getElementById('sct-forward');
        const urlEl = document.getElementById('sct-navbar-url');
        const spinner = document.getElementById('sct-spinner');
        const faviconSlot = document.getElementById('sct-favicon-slot');
        
        if (backBtn) {
            backBtn.disabled = !state.canGoBack;
        }
        if (forwardBtn) {
            forwardBtn.disabled = !state.canGoForward;
        }
        if (urlEl && state.url) {
            urlEl.value = state.url;
        }
        
        // Show spinner when loading, show favicon when complete
        if (state.isLoading) {
            if (spinner) {
                spinner.style.display = 'block';
                spinner.setAttribute('aria-hidden', 'false');
                spinner.setAttribute('aria-busy', 'true');
            }
            if (faviconSlot) {
                faviconSlot.style.display = 'none';
            }
        } else {
            if (spinner) {
                spinner.style.display = 'none';
                spinner.setAttribute('aria-hidden', 'true');
                spinner.setAttribute('aria-busy', 'false');
            }
            // Show favicon when page is loaded
            showFaviconIfAvailable();
        }
    }
    
    // Extract and show favicon from page
    function showFaviconIfAvailable() {
        const faviconSlot = document.getElementById('sct-favicon-slot');
        const faviconImg = document.getElementById('sct-favicon');
        
        if (!faviconSlot || !faviconImg) return;
        
        // Try to find favicon from page
        let faviconUrl = null;
        
        // 1. Look for link[rel="icon"] or link[rel="shortcut icon"]
        const linkIcon = document.querySelector('link[rel="icon"], link[rel="shortcut icon"], link[rel="apple-touch-icon"]');
        if (linkIcon && linkIcon.href) {
            faviconUrl = linkIcon.href;
        }
        
        // 2. Look for og:image in meta tags (fallback)
        if (!faviconUrl) {
            const ogImage = document.querySelector('meta[property="og:image"]');
            if (ogImage && ogImage.content) {
                faviconUrl = ogImage.content;
            }
        }
        
        // 3. Try default favicon.ico
        if (!faviconUrl) {
            try {
                const origin = window.location.origin;
                if (origin && origin !== 'null') {
                    faviconUrl = origin + '/favicon.ico';
                }
            } catch (e) {
                // Ignore
            }
        }
        
        // Display favicon if found
        if (faviconUrl) {
            faviconImg.src = faviconUrl;
            faviconImg.onerror = () => {
                faviconSlot.style.display = 'none';
            };
            faviconImg.onload = () => {
                faviconSlot.style.display = 'flex';
            };
        } else {
            faviconSlot.style.display = 'none';
        }
    }
    
    // ========== Rust -> JS Message Handler ==========
    // Rust will call this function to update navigation state
    window._sctUpdateNavState = function(state) {
        if (state) {
            window._sctNavState = {
                canGoBack: !!state.can_go_back,
                canGoForward: !!state.can_go_forward,
                isLoading: !!state.is_loading,
                url: state.url || window.location.href
            };
            updateNavBarFromState();
        }
    };
    
    // 在 DOM 准备好时创建导航栏
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', createNavBar);
    } else {
        createNavBar();
    }
})();
