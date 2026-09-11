-- ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓████████▓▒░░▒▓███████▓▒░
-- ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
-- ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
-- ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓██████▓▒░  ░▒▓██████▓▒░
-- ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░             ░▒▓█▓▒░
-- ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░             ░▒▓█▓▒░
--  ░▒▓█████████████▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░ ░▒▓██████▓▒░ ░▒▓█████████████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓████████▓▒░▒▓████████▓▒░▒▓███████▓▒░

-- TAGS
hl.window_rule({ match = { tag = "opaque" }, opaque = true })

-- Ignore maximize requests from all apps.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})
-- local suppressMaximizeRule = hl.window_rule({...})
-- suppressMaximizeRule:set_enabled(false)


hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})



-- NO_BLUR for these apps:
hl.window_rule({
    match   = { class = "kitty|vivaldi|vivaldi-stable|code|org.telegram.desktop|btop-primary" },
    no_blur = true,
})



-- +---------------------------+
-- |  OPACITY — content types  |
-- +---------------------------+
hl.window_rule({ match = { content = "photo" }, opaque = true })  -- images
hl.window_rule({ match = { content = "video" }, opaque = true })  -- videos
hl.window_rule({ match = { content = "game" },  opaque = true })  -- games


-- +-----------------------------+
-- |  OPACITY — no transparency  |
-- +-----------------------------+
-- Workspaces 10-12
hl.window_rule({ match = { workspace = "10" }, opaque = true })
hl.window_rule({ match = { workspace = "11" }, opaque = true })
hl.window_rule({ match = { workspace = "12" }, opaque = true })


-- +-----------------------------+
-- |   TRANSPIERENCE SETTINGS    |
-- +-----------------------------+
hl.window_rule({
    -- ALWAYS OPAQUE APPS
    match  = { class = "org.nomacs.ImageLounge|krita|draw.io|thunar|dev.zed.Zed|mpv|phototonic" },
    opaque = true,
})
hl.window_rule({
    -- SLIGHT TRANSPARENT APPS
    match = { class = "org.gnome.Evince" },
    opacity = "0.95 override"
})
hl.window_rule({
    -- ALWAYS OPAQUE WEB-SITES IN BROWSERS
    match  = {
        class = "vivaldi|vivaldi-stable",
        title = ".*YouTube.*|.*Reddit.*|.*/gg/.*|.*ity F.*",
    },
    opaque = true
})
-- --------------------------------------------------------------------------------------

-- +----------+
-- |  KITTY   |
-- +----------+
hl.window_rule({
    match   = { class = "kitty" },
    opacity = "0.7 override 0.5 override",
})


-- +------------+
-- |  BROWSERS  |
-- +------------+
hl.window_rule({
    match   = { class = "vivaldi-stable" },
    opacity = "0.9 override 0.9 override 1.0 override",
})
hl.window_rule({
    match   = { class = "zen" },
    opacity = "0.99 override 0.9 override 1.0 override",
})
hl.window_rule({
    name  = "VivaldiFileOperations",
    match = {
        class = "vivaldi|vivaldi-stable",
        title = "Save File.*|Сохранить файл.*|Open File.*|Открытие файла.*",
    },
    float = true,
    size  = { 800, 600 },
})
hl.window_rule({
    name  = "VivaldiSettings",
    match = {
        class = "vivaldi-stable",
        title = "Vivaldi Settings.*|Настройки Vivaldi.*",
    },
    float = true,
})



-- +-----------------+
-- |  IMAGE VIEWER   |
-- +-----------------+
hl.window_rule({
    name        = "ImageViewers",
    match       = { class = "org.nomacs.ImageLounge|org.gnome.gThumb|phototonic" },
    float       = true,
    fullscreen  = true,
    opaque      = true,
    border_size = 0,
    rounding    = 0,
    fullscreen_state = "3"
})


-- +------------+
-- |  ARCHIVES  |
-- +------------+
hl.window_rule({
    name  = "FileRoller",
    match = { class = "org.gnome.FileRoller" },
    float = true,
})


-- +------------+
-- |  TELEGRAM  |
-- +------------+
hl.window_rule({
    name      = "TelegramWorkspace",
    match     = { class = "org.telegram.desktop" },
    workspace = "1",
})
hl.window_rule({
    name      = "TelegramViewer",
    match     = { class = "org.telegram.desktop", title = "Просмотр медиа" },
    opaque    = true,
    float     = true,
    fullscreen_state = "1"
})
hl.window_rule({
    match = { title = ".*Выберите изображение.*" },
    float = true,
    size  = { 800, 600 },
})


-- +----------+
-- |  THUNAR  |
-- +----------+
hl.window_rule({
    name  = "ThunarRename",
    match = { title = "Rename.*|Переименовать.*" },
    float = true,
})
hl.window_rule({
    name  = "ThunarFileActions",
    match = { title = "File Operation Progress.*|Действия над файлами.*" },
    float = true,
})


-- +---------------+
-- |  GTK PORTAL   |
-- +---------------+
hl.window_rule({
    name  = "SaveFileGlobal",
    match = { title = ".*Сохранить файл.*|.*Сохранение изображения.*|.*Сохранить видео.*" },
    float = true,
    size  = { 800, 600 },
})
hl.window_rule({
    name  = "GtkPortal",
    match = { class = "xdg-desktop-portal-gtk" },
    float = true,
    size  = { 800, 600 },
})


-- +-------+
-- |  MPV  |
-- +-------+
hl.window_rule({
    name        = "MPV",
    match       = { class = "mpv" },
    float       = true,
    opaque      = true,
    border_size = 0,
    rounding    = 0,
})


-- +--------+
-- |  CALC  |
-- +--------+
hl.window_rule({
    name  = "UnoCalc",
    match = { class = "Calculator.Skia.Gtk" },
    float = true,
    size  = { 600, 600 },
})


-- +-------------+
-- |  AUDACIOUS  |
-- +-------------+
hl.window_rule({
    name = "audacious-float",
    match = { class = "audacious" },
    float = true,
    size = {800, 600}
})
hl.window_rule({
    name             = "audacious",
    match            = { class = "audacious", title = ".*Audacious.*" },
    float            = true,
    size             = { 900, 800 },
    move             = "(monitor_w-900)/2 30",
    opacity          = "0.8",
    animation        = "slide top",
    no_initial_focus = true,
})
hl.window_rule({
    name             = "audacious_no_splash",
    match            = { class = "Audacious", title = "" },
    no_initial_focus = true,
})
hl.window_rule({
    name             = "audacious_song_search",
    match            = { class = "audacious", title = "Jump to Song.*|Перейти к композиции.*" },
    float            = true,
    move             = "650 27",
    animation        = "slide top",
    opacity          = "0.7 override 0.5 override",
    dim_around       = true,
})


-- +--------+
-- |  BTOP  |
-- +--------+
-- Main window
hl.window_rule({
    name        = "BtopPrimaryWindow",
    match       = { class = "btop-primary" },
    float       = true,
    opacity     = "0.7 override",
    size        = { 1910, "monitor_h-55" },
    decorate    = false,
    xray        = false,
})


-- +---------+
-- |  SATTY  |
-- +---------+
hl.window_rule({
    name       = "satty",
    match      = { class = "com.gabm.satty" },
    float      = true,
    opaque     = true,
    fullscreen = true
})


-- +-------------+
-- |  VIRTUALBOX |
-- +-------------+
hl.window_rule({
    name   = "VBoxSettings",
    match  = { class = "VirtualBox|VirtualBoxVM", title = ".*Настройки.*" },
    float  = true,
    center = true,
})
hl.window_rule({
    name        = "VBoxMachineWide",
    match       = { class = "VirtualBox Machine" },
    float       = true,
    size        = { "monitor_w", "(monitor_h-55)" },
    move        = "0 25",
    rounding    = 0,
    no_shadow   = true,
})


-- +------------------+
-- |  GAMES / LUTRIS  |
-- +------------------+
hl.window_rule({
    name      = "LutrisWorkspace",
    match     = { class = "net.lutris.Lutris" },
    workspace = "9",
})
-- .exe — no borders, workspace 10, full opacity
hl.window_rule({
    name        = "ExeNoBorders",
    match       = { class = ".*\\.exe" },
    border_size = 0,
    rounding    = 0,
    workspace   = "10",
    opaque      = true
})
-- Proton / steam_app
hl.window_rule({
    name        = "ProtonSteamApp",
    match       = { class = "steam_app_.*" },
    opaque      = true,
    workspace   = "10",
    border_size = 0,
    rounding    = 0,
})
-- CheatEngine
hl.window_rule({
    name      = "CheatEngine",
    match     = { class = "cheatengine-x86_64.exe" },
    workspace = "8",
})
