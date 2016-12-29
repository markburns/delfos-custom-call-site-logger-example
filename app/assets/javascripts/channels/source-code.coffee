App.sourceCode = App.cable.subscriptions.create('SourceCodeChannel', {
  received: (data)->
    $("#source-code").removeClass('hidden')
    result = $('#source-code').prepend(this.renderCode(data));

    $('pre code').each (i, block)->
      hljs.highlightBlock(block);

    result


  renderCode: (data)->
    wrapper = "<div class='source-code-snippet'>"
    location   = "<div class= 'source-code-location'>" + data.location + "</div>"
    method     = "<code>" + data.method + "</code>"
    parameters = "<div><code>" + JSON.stringify(data.parameters) + "</code></div>"
    syntax = data.fileSyntax
    beforeCode = "<pre class= 'source-code-before'><code class= '#{syntax}'>#{data.beforeCode}</code></pre>"
    line       = "<pre class= 'source-code-line'><code class= '#{syntax}'>#{data.line}</code></pre>"
    afterCode  = "<pre class= 'source-code-after'><code class= '#{syntax}'>#{data.afterCode}</code></pre>"

    result = wrapper + location + method + parameters + beforeCode + line + afterCode + "</div>"
});
