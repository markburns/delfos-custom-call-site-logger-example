App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
    messages = $("#messages")

    if(messages.length > 0){
      messages.removeClass('hidden')
      messages.append(this.renderMessage(data));
      messages[0].scrollTop = messages[0].scrollHeight;
    }
  },
  renderMessage: function(data) {
    return "<p> <b>" + data.user + ": </b>" + data.message + "</p>";
  }
});
