{ pkgs, config, inputs, lib, ... }:
let
  # unsigned int
  id = 1;

  # computers name
  profileName = "${config.home.username}-${toString id}";

  # Your firefox install path
  firefoxPath = ".mozilla/firefox";

  # The location of your firefox config
  profilePath = "${firefoxPath}/${profileName}";

  # Firefox Addons, may want to change this at some point
  addons = inputs.firefox-addons.packages.${pkgs.system};





  # linux side-bar mods?
  VerticalFox = pkgs.fetchFromGitHub {
    owner = "christorange";
    repo = "VerticalFox";
    rev = "9f993ae6a75f5efd56f927d82c66393f1817a9b1";
    sha256 = "sha256-1urPrffIw6YFINpCaGxMo7+7lBAnGKGjc3BBS9I0UzQ=";
  };



  # Side-Berry User-style
  sideberryRepo = pkgs.fetchFromGitHub {
    owner = "drannex42";
    repo = "FirefoxSidebar";
    rev = "d99c43774b56226834c273c131563dfa9625f58d";
    sha256 = "sha256-LMqmawJbPc8trFYhxRHG1i24R62CZa5wj9+J6yejhCY=";
  };





in
{


  home.file = {
    "sideberry" = {
      source = "${sideberryRepo}";
      target = "${profilePath}/chrome/sideberry";
    };
    "VerticalFox" =
      {
        source = "${VerticalFox}";
        target = "${profilePath}/chrome/VerticalFox";
      };
  };

  #home.file."${profilePath}/chrome/sidebar-mods.css".text = builtins.readFile

  #home.file."${profilePath}/chrome/treestyletab-edge-mimicry.css".text =

  programs.firefox = {
    profiles.${profileName} = {
      inherit id;
      name = "${profileName}";

      extensions = with addons; [
        # Privacy and Security
        #        ublock-origin
        #        anonaddy
        #        clearurls
        #        privacy-possum
        #        decentraleyes
        #        darkreader
        #        sponsorblock
        #        i-dont-care-about-cookies
        #        consent-o-matic
        # bitwarden
        # canvasblocker
        # cookie-autodelete

        # Productivity
        #        violentmonkey
        #tree-style-tab
        sidebery
        #        smart-referer
        #        user-agent-string-switcher
        #        single-file
        #        nighttab
        #        rust-search-extension
        #        translate-web-pages

        # Steam-related packages
        #        augmented-steam
        #        protondb-for-steam
        #        steam-database

        # Github-related packages
        #        enhanced-github
        #        lovely-forks

        # Youtube-related packages
        #        youtube-shorts-block

      ];

      # @import "./sideberry/userChrome.css";
      userChrome = ''
                /*
        How to use this CSS:

        0. Install the Sidebery extension: https://addons.mozilla.org/en-US/firefox/addon/sidebery/.
        1. In Sidebery settings:
            a. Set the title preface must as "[S] " (without quotes).
                This is used by CSS rules below to identify when Sidebery is active.
            b. Set 'Tabs tree structure' to false -- this stylesheet doesn't adapt to
                multiple tab levels, but feel free to tweak it!
            c. Copy and paste the "SIDEBERY STYLES" section below as a custom
                Sidebar CSS in Sidebery's "Styles Editor".
        2. Go to about:support -> copy 'user folder' location, setting it as the variable $FF_USER_DIR.
        3. Move CSS files to FF user location:
            mv userChrome.css $FF_USER_DIR/userChrome.css
            mv userContent.css $FF_USER_DIR/userContent.css
        4. Go to about:flags -> `toolkit.legacyUserProfileCustomizations.stylesheets` to TRUE.
        5. Restart Firefox ( about:restartrequired ).

        ===================================================================

        TWEAKING AND DEBUGGING:

        A. How to inspect browser interface:
            Source: https://superuser.com/questions/1608096/how-to-inspect-firefoxs-ui

            1. Enable the Browser Toolbox

                Press F12 to open the Page Inspector.
                Alternate: Right click the page then "Inspect Element (Q)".

                Press F1 to open the Page Inspector Settings.
                Alternate: In the top right of the Page Inspector next to the close button; press the "⋯" button then "Settings".

                Ensure the following settings are checked:
                    "Enable Browser chrome and add-on debugging toolbox"
                    "Enable remote debugging"

            2. Open the Browser Toolbox

                Press alt, "Tools", "Web Developer" then "Browser Toolbox".
                Alternate: Press ctrl+alt+shift+i

        B. How to inspect extensions interface:
            Source: https://superuser.com/questions/1608096/how-to-inspect-firefoxs-ui

            You can use the Browser Toolbox to inspect extensions. Additionally you can inspect extensions through about:debugging.

            1. Navigate to about:debugging.
            2. Go to the "This Firefox" page.
            3. Find the extension you want to inspect.
            4. Press "Inspect" and a console window should open.
            5. Change *targeted iframe* if needed by clicking the blue "layout" icon
                in the upper right corner, close to the ellipsis menu icon.

        ====================================================================
        SECTION: SIDEBERY STYLES
                PLACE THIS SECTION MANUALLY IN SIDEBERY'S "CUSTOM STYLES"


        .Tab .lvl-wrapper .fav {
            position: relative !important;
            width: 32px !important;
            height: 32px !important;
            flex-shrink: 0 !important;
            opacity: 1 !important;
            z-index: 20 !important;
            transition: opacity var(--d-fast), transform var(--d-fast) !important;
            padding: 10px !important;
            margin-right: 1em !important;
            border-radius: 5px !important;
        }

        .Tab {
            margin: 5px 0 !important;
            margin-left: 0 !important;
        }

        .Tab .fav {
            margin: 4px 0 !important;
            margin-left: 0 !important;
            margin-right: 10em !important;
            background-color: inherit;
        }

        .Tab .lvl-wrapper .fav .placeholder>svg {
            fill: #aaa !important;
            height: 24px;
            width: 24px;
            left: 4px !important;
            top: 4px !important;
        }

        .Tab .lvl-wrapper .fav>svg,
        .Tab .lvl-wrapper .fav>img {
            position: absolute !important;
            width: 60% !important;
            height: 60% !important;
            left: 20% !important;
            right: 20% !important;
            top: 20% !important;
            bottom: 20% !important;
            border-radius: 5px !important;
        }

        .Tab .ctx {
            right: none;
            left: 0;
        }

        .container {
            margin: 5px;
            margin-right: -5px;
        }

        .Tab .lvl-wrapper .fav svg,
        .Tab .lvl-wrapper .fav img {
            border-radius: 5px;
            background-color: inherit;
        }

        .Tab[data-active*="true"] .lvl-wrapper .fav,
        .Tab[data-active*="true"] .lvl-wrapper .fav {

            background-color: #c10000;
            background-color: #7a00c0;

            -webkit-transition: background-color 1000ms linear;
            -moz-transition: background-color 1000ms linear;
            -o-transition: background-color 1000ms linear;
            -ms-transition: background-color 1000ms linear;
            transition: background-color 1000ms linear;

            background-color: var(--container-fg);

        }

        END OF SIDEBERY STYLES SECTION
        ====================================================================
        */

        /*
        ============================
        SECTION: SYSTEM TRANSPARENCY
         => Using BlurredFox: https://github.com/manilarome/blurredfox
        ============================
        */

        /*
        =============================
        SECTION: BLURRED TRANSPARENCY
        =============================
        */
        @import url('blurredfox/parts/customization-window.css');

        #urlbar-input {
            font-family: monospace !important;
        }

        #urlbar[breakout][breakout-extend][open] {
            /* border: 1px dotted orangered !important; */
            background-color: #0d1320d3;
            background-image: url(./image/noise-512x512.png);
            /*
                attempt of blurring the background of the expanded
                tab area - unfortunately it does not blur the page
                contents in the back, even though the backdrop filter
                now works in Firefox.
            */
            -webkit-backdrop-filter: blur(6px) !important;
            -moz-backdrop-filter: blur(6px) !important;
            -ms-backdrop-filter: blur(6px) !important;
            -o-backdrop-filter: blur(6px) !important;
            backdrop-filter: blur(6px) !important;
            font-family: monospace !important;
            border-radius: 0 0 2em 2em;
            transition: all 0.2s ease-in-out;
            height: 0;
            margin: 0 !important;
            padding: 0 !important
        }

        .menupopup {
            /* border: 2px dashed rgb(194, 133, 41) !important; */
            background-image: url(image/noise-512x512.png) !important;
            -webkit-backdrop-filter: blur(32px) !important;
            backdrop-filter: saturate(180%) blur(35px);
        }

        .urlbarView-body-inner {
            /*     border: 1px solid royalblue !important; */
            /*     background-color: transparent; */
            color: white;
            padding: var(--s4);
            animation-duration: 1s;
            animation-delay: 2s;
            animation-fill-mode: both;
            transition: 0.2s;
            box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.192);
            box-shadow: 2px 2px 8px #00000021;
        }

        #urlbar-background {
            border: 0 !important;
            /* border: 1px solid cyan !important; */
            /* enable eased transitions */
            display: none !important;
            transition: all 0.2s ease-in-out;
        }

        /*
        ===============================
        SECTION: SIDEBERY MINIMAL STYLE
        ===============================

        Based on: https://github.com/ongots/firefox-sidebery-minimal-style
        */

        @media (prefers-color-scheme: dark),
        (prefers-color-scheme: no-preference) {
            * {
                --bg: rgb(9, 9, 9);
                --menu: #151515;
                --hover: #10201b8e;
                --active: #7a00c096;
                --text: #ddd;
                --text-hover: #eee;
                --text-active: #fff;
                --url-color: #8F94D2;
                --tab-line-color: rgb(41, 248, 158);
                --lwt-toolbarbutton-icon-fill: rgb(176, 255, 217) !important;
            }

            .menu-right,
            #screenshots_mozilla_org-menuitem-_create-screenshot>hbox:nth-child(1)>image:nth-child(1) {
                filter: contrast(0%)
            }

            [checked="true"] .menu-iconic-left {
                filter: contrast(300%)
            }
        }

        @media (prefers-color-scheme: light) {
            * {
                --bg: #fafafa;
                --menu: #fafafa;
                --hover: #11533c7c;
                --active: #7a00c096;
                --text: #111;
                --text-hover: rgba(37, 181, 124, 0.408);
                --url-color: #4353B6;
                --tab-line-color: #FF1B00;
                --lwt-toolbarbutton-icon-fill: #222 !important;
            }

            spacer {
                filter: invert(100%)
            }
        }

        * {
            scrollbar-width: thin;
            scrollbar-color: #80808060 transparent;
            --toolbarbutton-border-radius: 0;
            --arrowpanel-dimmed: var(--hover) !important;
            --arrowpanel-dimmed-further: var(--active) !important;
            --lwt-accent-color: var(--bg) !important;
            --lwt-background-tab-separator-color: transparent;
            --tabs-border-color: transparent;
            --tab-min-width: 84px;
            --toolbar-bgcolor: var(--bg) !important;
            --toolbar-bgimage: none;
            --toolbar-color: var(--text) !important;
            --toolbarbutton-outer-padding: 0;
            --toolbarbutton-hover-background: var(--hover) !important;
            --toolbarbutton-active-background: var(--hover) !important;
            /*  urlbar  */
            --autocomplete-popup-highlight-background: var(--hover) !important;
            --autocomplete-popup-highlight-color: var(--url-color) !important;
            --urlbar-popup-action-color: var(--url-color) !important;
            --urlbar-popup-url-color: var(--url-color) !important;
            /*  searchbar */
            --autocomplete-popup-background: var(--bg);
            --autocomplete-popup-color: var(--text);
            --lwt-sidebar-background-color: var(--bg) !important;
            --lwt-sidebar-text-color: var(--text) !important;
        }

        :root[uidensity="compact"] * {
            font-size: 10pt !important
        }

        :root[tabsintitlebar] {
            background-color: var(--bg) !important;
            color: var(--text) !important
        }

        /*   ______ TABS ______   */

        .titlebar-color {
            background-color: var(--bg)
        }

        hbox.titlebar-spacer:nth-child(1) {
            display: none !important
        }

        .tabbrowser-tab[pinned] {
            background-color: var(--bg) !important;
            z-index: 3 !important
        }

        .tab-line:not([selected]) {
            height: 0 !important
        }

        .tab-background[multiselected] {
            background: #223B82 !important
        }

        .tabbrowser-tab[multiselected] :hover .tab-background:not([selected]) {
            background-color: #2C4890 !important
        }

        @media (prefers-color-scheme: light) {
            .tab-background[multiselected] {
                background-color: #4B7CFC !important
            }

            .tabbrowser-tab[multiselected] :hover .tab-background:not([selected]) {
                background-color: #3E6AE5 !important
            }

            .tab-background[selected]:not([multiselected]) {
                background: var(--hover) !important
            }
        }

        .tab-background[multiselected]>.tab-background-inner {
            background-color: transparent !important
        }

        .tabbrowser-tab:hover .tab-background:not([selected]) {
            background-color: var(--hover) !important
        }

        .all-tabs-item {
            opacity: .8
        }

        .all-tabs-item[selected] {
            opacity: 1;
            box-shadow: none !important;
            background-color: var(--active) !important
        }

        .panel-viewstack {
            max-height: 100% !important
        }

        .tabbrowser-tab::after {
            border-left: 0 !important
        }

        .tab-content {
            padding: 0 4px !important
        }

        /*   Container indicator   */

        .tab-bottom-line {
            background: var(--identity-tab-color) !important;
            margin-bottom: 0 !important
        }

        @media (prefers-color-scheme: dark),
        (prefers-color-scheme: no-preference) {
            .tab-bottom-line {
                height: 1px !important
            }
        }

        /*   Discard tabs   */

        .tabbrowser-tab:not([selected="false"])[pending] .tab-content {
            opacity: .7 !important
        }

        .tabbrowser-tab[pending]:hover .tab-content,
        .tab-label:-moz-window-inactive {
            opacity: .8 !important
        }

        .titlebar-spacer {
            width: 14px !important
        }

        /*   Hide Tab bar if Sidebery is Active   */

        @media(-moz-windows-default-theme) {
            [sizemode="maximized"][titlepreface*="[S]"] #navigator-toolbox {
                margin: 8px 0 0
            }

            [uidensity="compact"][sizemode="normal"]:root {
                --tab-min-height: 31px !important;
                --tabs-navbar-shadow-size: 0 !important
            }

            [uidensity="normal"][sizemode="normal"]:root {
                --tab-min-height: 32px !important
            }
        }

        [titlepreface*="[S]"] #titlebar,
        [titlepreface*="[S]"] #tabbrowser-tabs,
        [titlepreface*="[S]"] #tabContextMenu,
        [titlepreface*="[S]"] #sidebar-header,
        [hidden]#sidebar-box {
            display: none
        }

        /*   Dynamic sidebar   */

        [titlepreface*="[S]"] #sidebar-box {
            max-width: 40px
        }

        #sidebar-box {
            /* CHANGE COLLAPSED SIDEBAR HERE */
            /* border: 2px dashed orangered !important; */

            overflow: hidden;
            position: fixed;
            display: inherit;
            opacity: 0.95;
            transition: 0.2s;
            transition-timing-function: ease-in-out;
            backdrop-filter: blur(5px);
            z-index: 3;

            /* width of collapsed sidebar */
            min-width: calc(40px * 1) !important;
            max-width: 40px !important;
            width: calc(40px * 1) !important;

            /* default sidebar height */
            min-height: 100%;

        }

        /* => Sidebar with reduced height
            Commenting this block out makes the sidebar
            use the entire viewport height.
        */
        #sidebar-box {
            min-height: 50vh;
            max-height: calc(100% - 40px);
            border-radius: 0 0 2em 0;
        }

        /* End of sidebar with reduced height */

        [inFullscreen] #sidebar-box {
            max-width: 5px;
            height: 100%;
            top: 1px
        }

        #sidebar-box:hover {
            /* border: 2px dashed rgb(183, 20, 131) !important; */
            /* expanded width */
            min-width: unset !important;
            max-width: calc(40px * 6) !important;
            width: calc(40px * 6) !important;
        }

        #sidebar {
            /* THIS IS THE SIDEBAR */
            /* border: 2px dotted blue !important; */
            max-width: 50vw !important;
            width: calc(40px * 6) !important;
            height: 100%;
            background-color: transparent;
            background-image: none !important;
        }

        .ScrollBox>.scroll-container>.scrollable {
            background-color: transparent !important;
            background-image: none !important;
        }

        #sidebar .container {
            background-color: var(--bg) !important;
        }

        [titlepreface*="[S]"] #appcontent {
            /* margin-left: 28px; */
            margin-left: 36px;
            /* border: 1px solid green !important; */
        }

        [inFullscreen] #appcontent {
            margin-left: -20px;
            /* border: 1px solid aqua !important; */
        }

        @media(-moz-windows-default-theme) {
            [titlepreface*="[S]"] #appcontent {
                margin-left: 48px;
                /* border: 1px solid darkmagenta !important; */
            }

            [inFullscreen] #appcontent {
                /* border: 1px solid magenta !important; */
                margin-left: 0
            }
        }

        /*   Firefox sidebar   */

        #sidebar-header {
            width: 100% !important
        }

        #sidebar-header,
        #search-box {
            -moz-appearance: none !important;
            appearance: none !important;
            background-color: var(--bg) !important;
            color: var(--text) !important
        }

        treechildren::-moz-tree-separator {
            border: 0 !important
        }

        /*   Show window buttons - + x */

        /* @media(-moz-windows-default-theme){[sizemode="maximized"][titlepreface*="[S]"] #navigator-toolbox {margin: inherit}}
        [sizemode="maximized"][titlepreface*="[S]"] #titlebar,
        [sizemode="normal"][titlepreface*="[S]"] #titlebar {display: inherit !important; margin-bottom: -29px}
        [inFullscreen][titlepreface*="[S]"] #titlebar {display: inherit !important; margin-bottom: -24px}
        [sizemode="maximized"][titlepreface*="[S]"] #nav-bar,
        [sizemode="normal"][titlepreface*="[S]"] #nav-bar {margin-right: 138px}
        [inFullscreen][titlepreface*="[S]"] #nav-bar {margin-right: 108px}
        [inFullscreen][titlepreface*="[S]"] #TabsToolbar-customization-target {display:none} */

        /*   ______ NAVBAR ______   */

        :root:not([uidensity="compact"]) .browser-toolbar #back-button {
            padding-block: 0 !important;
            padding-inline: 0 !important;
            border-radius: 0 !important
        }

        :root:not([uidensity="compact"]) .browser-toolbar #back-button>.toolbarbutton-icon {
            background-color: var(--bg) !important;
            border-radius: 0 !important;
            width: 32px !important;
            height: 32px !important;
            padding: 8px !important
        }

        :root:not([uidensity="compact"]) .browser-toolbar #back-button:hover>.toolbarbutton-icon {
            background-color: var(--hover) !important
        }

        :root:not([uidensity="compact"]) .browser-toolbar #back-button:active>.toolbarbutton-icon {
            background-color: var(--active) !important
        }

        :root:not([uidensity="compact"]) {
            --toolbarbutton-inner-padding: 8px !important
        }

        /*   Bookmarks   */

        .openintabs-menuitem,
        .bookmarks-actions-menuseparator {
            display: none
        }

        .bookmark-item menuseparator {
            height: 8px
        }

        /*   Urlbar, Searchbar */

        #PlacesToolbarItems>toolbarbutton>label,
        #identity-box,
        #urlbar-input {
            margin-bottom: 1px !important;
            color: var(--text) !important
        }

        .searchbar-textbox {
            margin-bottom: 2px !important;
            color: var(--text) !important
        }

        #PlacesToolbarItems>toolbarbutton:hover>label {
            color: var(--text-hover) !important
        }

        #urlbar-input::-moz-selection {
            background-color: var(--text) !important;
            color: var(--bg)
        }

        @media (prefers-color-scheme: light) {
            #urlbar-input::-moz-selection {
                background-color: #444 !important
            }
        }

        #identity-popup {
            --popup-width: auto !important
        }

        #urlbar-container {
            --urlbar-container-height: 40px !important
        }

        :root[uidensity="compact"] #urlbar-container {
            --urlbar-container-height: 26px !important
        }

        #search-container {
            margin: -2px 0 !important
        }

        #urlbar {
            color: var(--lwt-toolbarbutton-icon-fill) !important;
            top: 1px !important
        }

        #urlbar-background,
        #navigator-toolbox #searchbar {
            background-color: var(--bg) !important
        }

        /* background of urlbar when it's closed */
        #urlbar:not([open]) #urlbar-background,
        #searchbar {
            box-shadow: none !important;
            border: 0;
            border-radius: 0;
            opacity: 1;
            filter: blur(0);
            -webkit-filter: blur(0);
        }

        /* background of urlbar when it's open */
        #urlbar[breakout][breakout-extend][open]>#urlbar-background {
            box-shadow: 0 0 0 1px var(--hover) !important;
            border: 0;
            border-radius: 0 0 2em 2em;
            opacity: 0.5;
            filter: blur(2px);
            -webkit-filter: blur(2px);
        }

        .urlbarView-row {
            color: var(--text)
        }

        .urlbarView-row[selected] .urlbarView-title {
            color: var(--text-hover)
        }


        #urlbar[breakout][breakout-extend] {
            left: 0 !important;
            width: 100% !important
        }

        #urlbar[breakout][breakout-extend]>#urlbar-input-container {
            padding-inline: 0 !important;
            padding-block: 0 !important;
            height: 40px !important
        }

        [uidensity="compact"] #urlbar[breakout][breakout-extend]>#urlbar-input-container {
            height: 26px !important
        }

        #urlbar .search-one-offs:not([hidden]) {
            font-family: monospace !important;
            ;
            padding-block: 4px !important
        }

        #tracking-protection-icon-container {
            padding: 0 2px !important
        }

        #identity-box {
            margin: 0 3px 0 0 !important;
            padding: 0 2px !important
        }

        #identity-icon,
        #identity-icon-label {
            margin-bottom: 2px !important
        }

        #urlbar[pageproxystate="invalid"] #identity-box {
            margin: 0 6px 0 11px !important
        }

        #pageActionButton,
        #editBookmarkPanelImage,
        .search-one-offs>hbox:nth-child(1),
        #urlbar-anon-search-settings-compact,
        #searchbar-anon-search-settings {
            display: none !important
        }

        /*   ______ Notifications ______   */

        :root .toolbarbutton-badge {
            background-color: transparent !important;
            box-shadow: none !important;
            padding: 0 0 4px !important;
            color: var(--text) !important;
            font-size: 7.5pt !important;
            opacity: .9;
            text-shadow: -1px 2px 3px var(--bg), -2px 1px 3px var(--bg), -2px 1px 4px var(--bg), -2px 2px 4px var(--bg) !important
        }

        .toolbarbutton-badge:hover {
            text-shadow: -1px 2px 3px var(--hover), -2px 1px 3px var(--hover), -2px 1px 4px var(--hover), -2px 2px 4px var(--hover) !important
        }

        #PanelUI-button,
        #PanelUI-menu-button {
            padding-inline: 0 !important;
            margin-inline: 0 !important
        }

        /*   ______ MENU ______   */

        #appMenu-addons-button,
        #appMenu-preferences-button {
            -moz-box-ordinal-group: 0
        }

        .panel-arrow,
        #appMenu-edit-controls,
        #appMenu-open-file-button,
        #appMenu-fxa-label,
        .PanelUI-subView toolbarseparator,
        #appMenu-protection-report-button,
        #appMenu-private-window-button,
        #appMenu-new-window-button,
        #appMenu-zoom-controls,
        #appMenu-find-button,
        #appMenu-customize-button,
        #appMenu-whatsnew-button,
        #appMenu-more-button,
        #appMenu_menu_HelpPopup_reportPhishingtoolmenu[disabled],
        [oncommand="openHelpLink('firefox-help')"],
        [oncommand="openTourPage();"],
        .panel-subview-footer,
        .panel-footer {
            background-color: var(--menu) !important
        }

        .panel-subview-footer:not([disabled]):hover {
            background-color: var(--hover) !important
        }

        .panel-subview-body {
            padding: 0 !important
        }

        .panel-arrowcontent {
            background-color: var(--menu) !important;
            margin-top: 6px !important;
            margin-right: 0 !important
        }

        panel {
            margin-inline: -16px !important
        }

        :root[uidensity="compact"] panel {
            margin-inline: -14px !important
        }

        menupopup,
        menuseparator,
        menuitem:not([active]),
        menucaption,
        menupopup menu,
        tooltip,
        panelview {
            -moz-appearance: none !important;
            appearance: none !important;
            background-color: var(--menu) !important;
            color: var(--text) !important;
            padding: 3px
        }

        #appMenu-popup toolbarbutton,
        #widget-overflow-mainView toolbarbutton {
            padding: 6px !important
        }

        menuitem>label {
            margin-bottom: 2px !important
        }

        menupopup {
            padding: 0 !important
        }

        menupopup>menu>menupopup {
            margin-inline-start: 0 !important;
            margin-top: 0 !important
        }

        menuitem:hover,
        menupopup menu:hover,
        toolbarbutton:hover:not([disabled], .titlebar-close, .close-icon, #nav-bar #back-button, toolbaritem.all-tabs-item[selected] > toolbarbutton),
        .menu-iconic:hover,
        .menu-iconic[open],
        .downloadMainArea:hover,
        .downloadButton:hover,
        #downloadsHistory:hover {
            background-color: var(--hover) !important;
            color: var(--text-hover) !important
        }

        #identity-box:hover,
        #identity-box[open],
        #tracking-protection-icon-container:hover,
        #tracking-protection-icon-container[open],
        .urlbar-icon-wrapper:hover,
        .urlbar-icon-wrapper[open] {
            background-color: var(--hover) !important
        }

        .downloadsPanelFooterButton:hover {
            outline: 0 !important
        }

        #statuspanel-label {
            background-color: var(--bg) !important;
            color: var(--text) !important;
            opacity: .7
        }

        #alertBox {
            background-color: var(--bg) !important;
            color: var(--text) !important;
            border: 1px solid var(--text) !important
        }

        /*   ______ 'Find' bar (Ctrl+F) ______   */

        /* Move the "Find" Bar to the top of the page*/
        .browserContainer>findbar {
            -moz-box-ordinal-group: 0;
            /* -moz-box-ordinal-group seemingly stopped working,
            on v112 or v113 so I changed it to an absolute position below. */
            transition: cubic-bezier(0.455, 0.03, 0.515, 0.955);
            transition-duration: 200ms;
            /* extra styling - move it to top right, narrower, and rounded */
            position: absolute;
            top: 0;
            right: 0;
            margin: 1em;
            width: 100%;
            border-radius: 1em;
            /* this is a vertical list now */
            max-width: 20em;
            background-color: transparent !important;
            backdrop-filter: blur(1em) !important;
            /* default opacity at 0.5 and 1 when hovered */
            opacity: 0.5;
        }

        /* make it visible when hovered */
        .browserContainer>findbar:hover {
            opacity: 1;
        }

        findbar>.findbar-container {
            /* this is a horizontal list by default - make it a vertical list and left align */
            display: flex !important;
            flex-direction: column !important;
            width: 100% !important;
            height: auto !important;
            align-items: flex-start !important;
            /* that is not aligning left. Try this: */
            margin: 0 !important;
            padding: 0 !important;
            /* inherit background */
            background-color: inherit !important;
        }

        /* pad all children */
        findbar>.findbar-container>* {
            padding: 1em !important;
            background-color: inherit !important;
            width: 100%;
            max-width: 100%;
            margin-left: 0 !important;
        }

        findbar>.findbar-closebutton {
            position: absolute;
            bottom: 1em;
            right: 0;
            cursor: pointer;
        }

        /* text input for search */
        /* findbar>.findbar-container>hbox {} */

        .findbar-container,
        .findbar-textbox:not([status="notfound"]),
        .findbar-closebutton.close-icon {
            background-color: var(--bg) !important;
            padding: 0 4px !important
        }

        .findbar-find-previous:not(:hover),
        .findbar-find-next:not(:hover) {
            background: var(--bg) !important
        }

        /*   ______ Library ______   */

        #placesToolbar {
            padding: 0 4px 0 0 !important
        }

        #placesToolbar>toolbarbutton {
            padding: 7px !important
        }

        #placesMenu>menu {
            padding: 4px !important
        }

        #placesMenu>menu>.menubar-text {
            color: var(--text)
        }

        :root {
            --organizer-text-secondary-color: transparent !important
        }

        #searchFilter {
            background-color: var(--hover) !important
        }

        /*   ______ About Firefox ______   */

        #aboutDialogContainer {
            background-color: #171227 !important
        }

        /*
        =====================================
        END OF SIDEBERY MINIMAL STYLE SECTION
        =====================================
        */

      '';
      userContent = ''
              /* PART OF SIDEBERY MINIMAL STYLE */


        /* Based on https://github.com/ongots/firefox-sidebery-minimal-style */

        * {
            scrollbar-width: thin;
            scrollbar-color: #80808060 transparent !important
        }


        /*   Newtab   */

        @-moz-document url("about:home"),
        url("about:newtab") {
            body {
                background-color: #fafafa !important;
                background: radial-gradient(#80808030 1px, transparent 0);
                background-size: 30px 30px
            }
            @media (prefers-color-scheme: dark),
            (prefers-color-scheme: no-preference) {
                body {
                    background-color: #000 !important
                }
            }
            .prefs-button {
                display: none
            }
        }


        /*   Addons   */

        button.category:nth-child(1),
        #help-button,
        #helpButton,
        .addon-badge-recommended,
        .addon-description,
        .back-button,
        .header-name,
        .list-section-heading,
        .search-label,
        #sidebar::after,
        .navigation::after {
            display: none !important
        }

        :root {
            --addon-icon-size: 26px !important;
            --card-padding: 14px !important;
            --in-content-box-border-color: #333 !important
        }

        .addon.card {
            margin-bottom: 5px !important
        }

        .addon-name {
            font-weight: 400 !important
        }

        .addon-name-container {
            margin-top: 0 !important
        }

        .main-search {
            margin: -15px 0 -41px -364px !important
        }

        .page-options-menu,
        #updates-message {
            margin: -22px 0 -10px 0 !important
        }

        .sticky-container {
            position: static !important
        }

        .more-options-button {
            background-color: transparent !important
        }

        .more-options-button:hover {
            background-color: #80808040 !important
        }
      '';

      #      settings = import ./settings.nix;
    };
  };
}
