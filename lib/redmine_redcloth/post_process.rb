require 'cgi'

module RedCloth::Formatters::HTML

  CODE_HIGHLIGHT_RE = /<code>?\s?class\s?=\s?(?:'|")(\w+)(?:'|")>?\s?(.+?)<\/code>/m
  WIKI_LINKS_RE = /(!)?(\[\[([^\]\n\|]+)(\|([^\]\n\|]+))?\]\])/
  BASIC_TAGS.select { |a, set| set << 'class' if a == 'code' } # Allow code highlight with Sanitize HTML option
      
  # Syntax highlight <code> content when a code class language is specified after Redcloth conversion is complete
  # inline: @class="ruby" My Ruby Code@
  # block: <pre><code class="ruby">My Ruby Code</code></pre>
  def after_transform(text)
    text.gsub!( CODE_HIGHLIGHT_RE ) do
	    lang,content = $~[1..2]
        "<code class=\"#{lang} syntaxhl\">#{Redmine::SyntaxHighlighting.highlight_by_language(CGI.unescapeHTML(content), lang)}</code>"
    end
    # Escape redmine wiki links
    text.gsub!( WIKI_LINKS_RE ) do |m|
      link = "#{$1}#{CGI.unescapeHTML($2)}"
    end
    text.chomp!
  end
  
  # Override default quote styles
  
  def quote1(opts) #single quote '
    "&#39;#{opts[:text]}&#39;"
  end
  
  def quote2(opts) #double quote "
    "&quot;#{opts[:text]}&quot;"
  end
  
  def multi_paragraph_quote(opts)
    "&quot#{opts[:text]}"
  end
end