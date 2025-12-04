// SCToolbox WebView initialization script
(function() {
    'use strict';
    
    if (window._sctInitialized) return;
    window._sctInitialized = true;
    
    // ========== 导航栏 UI ==========
    const icons = {
        back: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M10 12L6 8L10 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>',
        forward: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M6 4L10 8L6 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>',
        reload: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M13.5 8C13.5 11.0376 11.0376 13.5 8 13.5C4.96243 13.5 2.5 11.0376 2.5 8C2.5 4.96243 4.96243 2.5 8 2.5C10.1012 2.5 11.9254 3.67022 12.8169 5.4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M10.5 5.5H13V3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>'
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
                #sct-navbar button:hover { background: rgba(10, 49, 66, 0.9); color: #fff; }
                #sct-navbar button:active { background: rgba(10, 49, 66, 1); transform: scale(0.95); }
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
            <button id="sct-back" title="Back">${icons.back}</button>
            <button id="sct-forward" title="Forward">${icons.forward}</button>
            <button id="sct-reload" title="Reload">${icons.reload}</button>
            <div id="sct-spinner" role="progressbar" aria-hidden="false" aria-valuetext="Loading" title="Loading"></div>
            <div id="sct-favicon-slot"><img id="sct-favicon" src="" alt="Page icon" /></div>
            <input type="text" id="sct-navbar-url" readonly value="${window.location.href}" />
        `;
        document.body.insertBefore(nav, document.body.firstChild);
        
        document.getElementById('sct-back').onclick = () => {
            // Check if going back would result in about:blank
            // If so, skip this entry and go back further
            const beforeBackUrl = window.location.href;
            history.back();
            
            // After a short delay, if we landed on about:blank, go back again
            setTimeout(() => {
                if (window.location.href === 'about:blank' && beforeBackUrl !== 'about:blank') {
                    history.back();
                }
            }, 100);
        };
        document.getElementById('sct-forward').onclick = () => history.forward();
        document.getElementById('sct-reload').onclick = () => location.reload();
        
        // Update back button state and URL display on navigation
        function updateNavBarState() {
            const backBtn = document.getElementById('sct-back');
            const urlEl = document.getElementById('sct-navbar-url');
            const currentUrl = window.location.href;
            
            if (backBtn) {
                // Disable back button if at start of history or at about:blank
                backBtn.disabled = window.history.length <= 1 || currentUrl === 'about:blank';
            }
            
            if (urlEl) {
                urlEl.value = currentUrl;
            }
        }
        
        // Listen to popstate and hashchange to update nav bar
        window.addEventListener('popstate', updateNavBarState);
        window.addEventListener('hashchange', updateNavBarState);
        
        // Initial state
        updateNavBarState();

        // Spinner and favicon show/hide helpers
        const spinner = document.getElementById('sct-spinner');
        const faviconSlot = document.getElementById('sct-favicon-slot');
        const faviconImg = document.getElementById('sct-favicon');

        function showSpinner() {
            if (spinner) {
                spinner.style.display = 'block';
                spinner.setAttribute('aria-hidden', 'false');
                spinner.setAttribute('aria-busy', 'true');
            }
            if (faviconSlot) {
                faviconSlot.style.display = 'none';
            }
        }

        function hideSpin() {
            if (spinner) {
                spinner.style.display = 'none';
                spinner.setAttribute('aria-hidden', 'true');
                spinner.setAttribute('aria-busy', 'false');
            }
        }

        // Extract favicon from page and show it when ready
        function showFaviconWhenReady() {
            hideSpin();
            
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
            
            // 3. Check page's existing favicon from document.head or body elements
            if (!faviconUrl) {
                const existingFavicon = document.querySelector('img[src*="favicon"], img[src*="icon"]');
                if (existingFavicon && existingFavicon.src) {
                    faviconUrl = existingFavicon.src;
                }
            }
            
            // Display favicon if found, otherwise hide slot
            if (faviconUrl) {
                if (faviconImg) {
                    faviconImg.src = faviconUrl;
                    faviconImg.onerror = () => {
                        if (faviconSlot) faviconSlot.style.display = 'none';
                    };
                }
                if (faviconSlot) {
                    faviconSlot.style.display = 'flex';
                }
            } else if (faviconSlot) {
                faviconSlot.style.display = 'none';
            }
        }

        // Monitor document readyState to show favicon when page is ready
        document.addEventListener('readystatechange', function () {
            if (document.readyState === 'interactive' || document.readyState === 'complete') {
                setTimeout(showFaviconWhenReady, 150);
            }
        });

        // Also trigger favicon display on load event
        window.addEventListener('load', function () {
            setTimeout(showFaviconWhenReady, 150);
        });
    }
    
    // 在 DOM 准备好时创建导航栏
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', createNavBar);
    } else {
        createNavBar();
    }
    
    // URL 变化时：进入加载状态，显示 spinner
    window.addEventListener('popstate', () => {
        // Show spinner when navigating via popstate (URL change)
        const spinner = document.getElementById('sct-spinner');
        const faviconSlot = document.getElementById('sct-favicon-slot');
        if (spinner) {
            spinner.style.display = 'block';
            spinner.setAttribute('aria-hidden', 'false');
            spinner.setAttribute('aria-busy', 'true');
        }
        if (faviconSlot) {
            faviconSlot.style.display = 'none';
        }
    });
})();
