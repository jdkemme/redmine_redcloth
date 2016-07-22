module RedClothQuoteExtension

  QUOTES_RE = /(^>+([^\n]*?)(\n|$))+/m
  QUOTES_CONTENT_RE = /^([> ]+)(.*)$/m
  
  def quotes( text )
    text.gsub!( QUOTES_RE ) do |match|
      lines = match.split( /\n/ )
      Rails.logger.debug "Block Quote lines: #{lines}"
      quotes = ''
      indent = 0
      lines.each_with_index do |line, i|
        line =~ QUOTES_CONTENT_RE 
        bq,content = $1, $2
        l = bq.count('>')
        if l != indent
          quotes << ((l>indent ? l > 1 ? "</p>\n" + '<blockquote>' * (l-indent) + "\n<p>" : '<blockquote>' * (l-indent) + '<p>' : '</p>' + '</blockquote>' * (indent-l) + "\n<p>"))
          indent = l
      quotes << (content)
    else
      quotes << ("\n" + content)
        end
      end
      quotes << ("</p>\n" + '</blockquote>' * indent)     
      quotes
    end
    text.chomp!
  end
end

RedCloth::Formatters::HTML.send(:include, RedClothQuoteExtension)