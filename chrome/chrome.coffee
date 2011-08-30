###
# (c) 2011 Tyler Kennedy <tk@tkte.ch>
###
attributes = on

###
# Copy the contents of `text` to the clipboard.
###
to_clipboard = (text) ->
    textarea = document.getElementById "copy-workaround"
    textarea.value = text
    textarea.select()
    document.execCommand "copy", false, null

###
# Sends a message to the content script on `tab` with the
# body `message`, saving the response (if any) to the clipboard.
###
message_and_save = (tab, message) ->
    message.attributes or= attributes
    message.short or= off

    chrome.tabs.sendRequest tab.id, message, (response) ->
        if not response? or not response.result?
            return

        if message.short? and message.short
            to_clipboard "//#{ response.result.join('/') }"
        else
            to_clipboard "/#{ response.result.join('/') }"

# Contextual menu callbacks
menu =
    positional: (info, tab) ->
        attributes = info.checked

    absolute: (info, tab) ->
        message_and_save tab, {
            act: 'absolute'
        }

    shortest: (info, tab) ->
        message_and_save tab, {
            act: 'absolute'
            short: true
        }

    table: (info, tab) ->
        message_and_save tab, {
            act: 'table'
        }

    shortTable: (info, tab) ->
        message_and_save tab, {
            act: 'table'
            short: true
        }

# When our contextual menu should show
default_context = ['all']

root = chrome.contextMenus.create({
    title: 'PsychoXPath'
    contexts: default_context
})

absolute = chrome.contextMenus.create({
    title: 'Element (Absolute)'
    parentId: root
    contexts: default_context
    onclick: menu.absolute
})

shortest = chrome.contextMenus.create({
    title: 'Element (Shortest)'
    parentId: root
    contexts: default_context
    onclick: menu.shortest
})

chrome.contextMenus.create({
    type: 'separator'
    parentId: root
    contexts: default_context
})

table = chrome.contextMenus.create({
    title: 'Containing Table (Absolute)'
    parentId: root
    contexts: default_context
    onclick: menu.table
})

shortTable = chrome.contextMenus.create({
    title: 'Containing Table (Shortest)'
    parentId: root
    contexts: default_context
    onclick: menu.shortTable
})

chrome.contextMenus.create({
    type: 'separator'
    parentId: root
    contexts: default_context
})

positional = chrome.contextMenus.create({
    title: 'Use attributes in XPaths'
    parentId: root
    contexts: default_context
    type: 'checkbox'
    checked: attributes
    onclick: menu.positional
})