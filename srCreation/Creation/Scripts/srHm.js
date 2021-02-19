$(document).ready(function () {
    //setInterval(function () { RefreshChat(); }, 500);
    $('[data-link]').css('cursor', 'pointer');
});

$(document).on("click", "[data-link]", function () {
    location.href = $(this).attr('data-link');
});
$(document).on('click', '#sToggle', function () {
    var tog = $(this).attr("data-tog");
    var more = $(this).attr("data-show");
    var less = $(this).attr("data-hide");
    if (tog == 0) { //Hidden state, Show it.
        $(this).attr('data-tog', '1');
        $(this).text(more);
    }
    else {
        $(this).attr('data-tog', '0');
        $(this).text(less);
    }
    // Call Expand functionality.
});

$(document).on('click', '#iLogo', function () {
    location.href = logoUrl;
});

$(document).off('click', '#execChat').on('click', '#execChat', function () {
    var toSent = $('#txtChat').val().trim();
    if (toSent != '') {
        $.ajax({
            url: urlExecChat,
            data: { msg: toSent },
            type: 'POST',
            success: function (result, status, jqXhr) {
                // No work to do here....
                $('#txtChat').val('');
                $('#dChatActive').animate({ scrollTop: $('#dChatActive').scrollHeight }, 100);
            },
            error: function (jqXhr, status, err) {
                // Handle error here.
                HandleAjxErr(jqXhr, status, err);
            }
        });
    }
});
function SetErr(msg) {
    $('#errShow').addClass('error');
    $('#errShow').html(msg);
}
function RefreshChat() {
    var lmId = $('.ChatEach').last().attr('data-lmid');
    var data = { lmId: lmId };
    $.ajax({
        url: urlGetChat,
        data: data,
        type: 'GET',
        dataType: 'html',
        success: function (chats, status, jqXhr) {
            if (chats != undefined) {
                $('#dChatActive').append(chats);
            }
        },
        error: function (jqXhr, status, err) {
            // Handle error here.
            HandleAjxErr(jqXhr, status, err);
        }
    });
}

function HandleAjxErr(jqXhr, status, err) {
    alert(err);
}
