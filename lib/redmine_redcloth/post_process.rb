require 'cgi'

module RedCloth::Formatters::HTML

  CODE_HIGHLIGHT_RE = /<code>?\s?class\s?=\s?(?:'|")(\w+)(?:'|")>?\s?(.+?)<\/code>/m
  
  # Syntax highlight <code> content when a code class language is specified after Redcloth conversion is complete
  # inline: @class="ruby" My Ruby Code@
  # block: <pre><code class="ruby">My Ruby Code</code></pre>
  def after_transform(text)
    text.gsub!( CODE_HIGHLIGHT_RE ) do
	    lang,content = $~[1..2]
        "<code class=\"#{lang} syntaxhl\">#{Redmine::SyntaxHighlighting.highlight_by_language(CGI.unescapeHTML(content), lang)}</code>"
    end
    text.chomp!
  end
end