class DelfosWebsocketLogger
  def save_call_stack(_call_sites, _execution_number)
    # no-op
  end

  def log(parameters, call_site, called_code)
    call_site   = CallSiteFormatter.new(call_site)
    called_code = CallSiteFormatter.new(called_code)

    broadcast call_site,   parameters
    broadcast called_code, parameters
  end

  def broadcast(call_site, parameters)
    arguments = parameters.args.map(&:inspect)
    keyword_arguments = parameters.keyword_args.map(&:inspect)

    BroadCastSourcecodeJob.perform_later(
      location:      call_site.location,
      method:        call_site.method,
      beforeCode:    call_site.before_code,
      line:          call_site.line,
      afterCode:     call_site.after_code,
      fileSyntax:    call_site.file_syntax,
      parameters:    {arguments: arguments, keyword_arguments: keyword_arguments}
    )
  end

  CallSiteFormatter = Struct.new(:call_site) do
    def location
      "#{call_site.file}:#{call_site.line_number}"
    end

    def method_name
      call_site.method_name
    end

    def method
      "#{object_class}#{dot_or_hash}#{method_name}"
    end

    def file_syntax
      case call_site.file
      when /\.erb\z/
        "erb"
      when /\.rb\z/
        "ruby"
      when /\.slim\z/
        "slim"
      end
    end

    def before_code
      line_range(first_line, line_number - 1)
    end

    def line
      line_range(line_number, line_number)
    end

    def after_code
      line_range(line_number + 1, last_line)
    end

    private

    def line_range(min, max)
      lines[min-1.. max-1].join("")
    end

    def last_line
      max = [line_number + 4, lines.length].min
    end

    def first_line
      [line_number - 5, 1].max
    end

    def line_number
      call_site.line_number.to_i
    end

    def lines
      @lines ||= File.readlines(call_site.file)
    end

    def dot_or_hash
      call_site.class_method ? "." : "#"
    end

    def object_class
      call_site.object.is_a?(Class) ? call_site.object : call_site.object.class
    end
  end
end
