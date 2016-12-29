App.sourceCode = App.cable.subscriptions.create('SourceCodeChannel', {
  received: (data)->
    $("#source-code").removeClass('hidden')
    result = $('#source-code').append(this.renderCode(data));

    $('pre code').each (i, block)->
      hljs.highlightBlock(block);

    result


  renderCode: (data)->
    wrapper = "<div class='source-code-snippet'>"
    location   = "<div class= 'source-code-location'>" + data.location + "</div>"
    method     = "<code>" + data.method + "</code>"
    args = data.parameters.arguments.map((a, i)-> 
      "<div><code>" + a + "</code></div>"
    ).join("\n")
    if args.length > 0
      args = "<div class='source-code'>Arguments</div>" + args

    kwArgs = data.parameters.keyword_arguments.map((a, i)->
      "<div><code>" + a + "</code></div>"
    ).join("\n")

    if kwArgs.length > 0
      kwArgs = "<div class='source-code'>Keyword Arguments</div>" + kwArgs


    syntax = data.fileSyntax

    beforeCode = @codeBlock("before", syntax, data.beforeCode)
    line = @codeBlock("line",   syntax, data.line)
    afterCode  = @codeBlock("after",  syntax, data.afterCode)


    result = wrapper + location + method + args + kwArgs + beforeCode + line + afterCode + "</div>"

  codeBlock: (preClass, syntaxClass, code)->
    "<pre class= 'source-code-#{preClass}'><code class= '#{syntaxClass}'>#{code}</code></pre>"
});
