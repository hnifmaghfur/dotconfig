local wezterm = require 'wezterm'
local action = wezterm.action
local M = {}

function M.keys()
  return {
    { key = 'c', mods = 'CTRL|SHIFT', action = action.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CTRL|SHIFT', action = action.PasteFrom 'Clipboard' },
    { key = 't', mods = 'CTRL|SHIFT', action = action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'CTRL|SHIFT', action = action.CloseCurrentTab { confirm = false } },
    { key = 'n', mods = 'CTRL|SHIFT', action = action.SpawnWindow },

    { key = '-', mods = 'LEADER', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\\', mods = 'LEADER|SHIFT', action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    { key = 'h', mods = 'LEADER', action = action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'LEADER', action = action.ActivatePaneDirection 'Right' },

    { key = 'x', mods = 'LEADER', action = action.CloseCurrentPane { confirm = false } },
    { key = 'o', mods = 'LEADER', action = action.RotatePanes 'Clockwise' },
    { key = 'O', mods = 'LEADER', action = action.RotatePanes 'CounterClockwise' },

    { key = '1', mods = 'CTRL', action = action.ActivateTab(0) },
    { key = '2', mods = 'CTRL', action = action.ActivateTab(1) },
    { key = '3', mods = 'CTRL', action = action.ActivateTab(2) },
    { key = '4', mods = 'CTRL', action = action.ActivateTab(3) },
    { key = '5', mods = 'CTRL', action = action.ActivateTab(4) },
    { key = '6', mods = 'CTRL', action = action.ActivateTab(5) },
    { key = '7', mods = 'CTRL', action = action.ActivateTab(6) },
    { key = '8', mods = 'CTRL', action = action.ActivateTab(7) },
    { key = '9', mods = 'CTRL', action = action.ActivateTab(8) },

    { key = 'f', mods = 'LEADER', action = action.Search 'CurrentSelectionOrEmptyString' },
    { key = 'p', mods = 'CTRL|SHIFT', action = action.ActivateTabRelative(-1) },
    { key = 'n', mods = 'CTRL|SHIFT', action = action.ActivateTabRelative(1) },
    { key = '[', mods = 'LEADER', action = action.ActivateKeyTable { name = 'resize_pane' } },
    { key = 'r', mods = 'LEADER', action = action.ActivateKeyTable { name = 'resize_pane' } },
    { key = 's', mods = 'LEADER', action = action.ActivateKeyTable { name = 'scroll_mode' } },
    { key = 'g', mods = 'LEADER', action = action.ActivateKeyTable { name = 'search_mode' } },
    { key = 'Tab', mods = 'LEADER', action = action.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'LEADER|SHIFT', action = action.ActivateTabRelative(-1) },
    { key = 't', mods = 'LEADER', action = action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'LEADER', action = action.CloseCurrentTab { confirm = false } },
    { key = 'f', mods = 'LEADER|SHIFT', action = action.SpawnCommandInNewWindow { label = 'Floating Terminal' } },
    { key = 'Enter', mods = 'LEADER', action = action.SpawnTab 'CurrentPaneDomain' },
    { key = 'm', mods = 'LEADER', action = action.TogglePaneZoomState },
    { key = 'y', mods = 'LEADER', action = action.ActivateCopyMode },
    { key = 'u', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
    { key = 'd', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
    { key = '0', mods = 'LEADER', action = action.ActivateKeyTable { name = 'number_tab' } },
    { key = ',', mods = 'LEADER', action = action.ActivateKeyTable { name = 'quick_switch' } },

    -- Layout presets
    { key = 'Space', mods = 'LEADER', action = action.ActivateKeyTable { name = 'layout_mode', one_shot = false } },
  }
end

function M.key_tables()
  return {
    resize_pane = {
      { key = 'h', action = action.AdjustPaneSize { 'Left', 1 } },
      { key = 'j', action = action.AdjustPaneSize { 'Down', 1 } },
      { key = 'k', action = action.AdjustPaneSize { 'Up', 1 } },
      { key = 'l', action = action.AdjustPaneSize { 'Right', 1 } },
      { key = 'H', action = action.AdjustPaneSize { 'Left', 5 } },
      { key = 'J', action = action.AdjustPaneSize { 'Down', 5 } },
      { key = 'K', action = action.AdjustPaneSize { 'Up', 5 } },
      { key = 'L', action = action.AdjustPaneSize { 'Right', 5 } },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    scroll_mode = {
      { key = 'j', action = action.ScrollByPage(0.5) },
      { key = 'k', action = action.ScrollByPage(-0.5) },
      { key = 'd', action = action.ScrollByPage(0.5) },
      { key = 'u', action = action.ScrollByPage(-0.5) },
      { key = 'g', action = action.ScrollToTop },
      { key = 'G', action = action.ScrollToBottom },
      { key = 'h', action = action.ScrollByPage(-0.5) },
      { key = 'l', action = action.ScrollByPage(0.5) },
      { key = '/', action = action.ActivateKeyTable { name = 'search_mode' } },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    search_mode = {
      { key = 'Enter', action = action.Search 'CurrentSelectionOrEmptyString' },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    copy_mode = {
      { key = 'v', action = action.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'V', action = action.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'y', action = action.CopyMode 'CopyToClipboard' },
      { key = 'q', action = action.CopyMode 'Close' },
      { key = 'Escape', action = action.CopyMode 'Close' },
      { key = 'h', action = action.CopyMode 'MoveLeft' },
      { key = 'l', action = action.CopyMode 'MoveRight' },
      { key = 'j', action = action.CopyMode 'MoveDown' },
      { key = 'k', action = action.CopyMode 'MoveUp' },
      { key = 'w', action = action.CopyMode 'MoveForwardWord' },
      { key = 'b', action = action.CopyMode 'MoveBackwardWord' },
      { key = '0', action = action.CopyMode 'MoveToStartOfLine' },
      { key = '$', action = action.CopyMode 'MoveToEndOfLineContent' },
      -- Enhanced copy mode
      { key = '/', action = action.Search { CaseInSensitiveString = '' } },
      { key = 'n', action = action.CopyMode 'NextMatch' },
      { key = 'N', action = action.CopyMode 'PriorMatch' },
      { key = 'v', mods = 'CTRL', action = action.CopyMode { SetSelectionMode = 'Block' } },
      { key = 'd', mods = 'CTRL', action = action.CopyMode 'MoveToViewportBottom' },
      { key = 'u', mods = 'CTRL', action = action.CopyMode 'MoveToViewportTop' },
      { key = 'g', action = action.CopyMode 'MoveToScrollbackTop' },
      { key = 'G', action = action.CopyMode 'MoveToScrollbackBottom' },
      { key = 'M', action = action.CopyMode 'MoveToViewportMiddle' },
      { key = '%', action = action.CopyMode 'MoveToSelectionOtherEnd' },
    },

    layout_mode = {
      { key = 'h', action = action.EmitEvent 'layout-main-horizontal' },
      { key = 'v', action = action.EmitEvent 'layout-main-vertical' },
      { key = 't', action = action.EmitEvent 'layout-tiled' },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    number_tab = {
      { key = '0', action = action.ActivateTab(0) },
      { key = '1', action = action.ActivateTab(1) },
      { key = '2', action = action.ActivateTab(2) },
      { key = '3', action = action.ActivateTab(3) },
      { key = '4', action = action.ActivateTab(4) },
      { key = '5', action = action.ActivateTab(5) },
      { key = '6', action = action.ActivateTab(6) },
      { key = '7', action = action.ActivateTab(7) },
      { key = '8', action = action.ActivateTab(8) },
      { key = '9', action = action.ActivateTab(9) },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    quick_switch = {
      { key = 'a', action = action.ActivateKeyTable { name = 'quick_select_a' } },
      { key = 'b', action = action.ActivateKeyTable { name = 'quick_select_b' } },
      { key = 'c', action = action.ActivateKeyTable { name = 'quick_select_c' } },
      { key = 'd', action = action.ActivateKeyTable { name = 'quick_select_d' } },
      { key = 'e', action = action.ActivateKeyTable { name = 'quick_select_e' } },
      { key = 'Escape', action = 'PopKeyTable' },
    },

    quick_select_a = {
      { key = '1', action = action.SwitchToWorkspace { name = '1' } },
      { key = '2', action = action.SwitchToWorkspace { name = '2' } },
      { key = '3', action = action.SwitchToWorkspace { name = '3' } },
      { key = 'Escape', action = 'PopKeyTable' },
    },
  }
end

return M
