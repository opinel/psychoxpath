var dwx_element = null;

document.body.onmousedown = function (e) {
    e = e || window.event;
    dwx_element = (e.target || e.srcElement);
}

function onRequest(request, sender, sendResponse) {
    var result = null;
    var attributes = request.attributes;

    if(!dwx_element) {
        sendResponse({result: null});
        return;
    }

    if(request.act == 'absolute') {
        result = psychoxpath.get_abs_xpath(dwx_element, [], !attributes);
    } else if(request.act == 'shortest') {
        result = psychoxpath.get_abs_xpath(dwx_element, [], !attributes);
        result = psychoxpath.shortest_xpath(result);
    } else if(request.act == 'table') {
        result = psychoxpath.get_abs_xpath(dwx_element, [], !attributes);
        result = psychoxpath.last_of_type(result, 'table')
    }

    sendResponse({
        result: result
    });
}

chrome.extension.onRequest.addListener(onRequest);
