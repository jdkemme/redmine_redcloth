# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redcloth'
require 'digest/md5'

module RedmineRedcloth

      class Formatter < RedCloth::TextileDoc
        include ActionView::Helpers::TagHelper
        include Redmine::WikiFormatting::LinksHelper

        alias :inline_auto_link :auto_link!
        alias :inline_auto_mailto :auto_mailto!
        
        #
        # Regular expressions to convert to HTML. Pulled from Redcloth3 to maintain section editing compatability
        #
        A_HLGN = /(?:(?:<>|<|>|\=|[()]+)+)/
        A_VLGN = /[\-^~]/
        C_CLAS = '(?:\([^")]+\))'
        C_LNGE = '(?:\[[a-z\-_]+\])'
        C_STYL = '(?:\{[^"}]+\})'
        S_CSPN = '(?:\\\\\d+)'
        S_RSPN = '(?:/\d+)'
        A = "(?:#{A_HLGN}?#{A_VLGN}?|#{A_VLGN}?#{A_HLGN}?)"
        S = "(?:#{S_CSPN}?#{S_RSPN}|#{S_RSPN}?#{S_CSPN}?)"
        C = "(?:#{C_CLAS}?#{C_STYL}?#{C_LNGE}?|#{C_STYL}?#{C_LNGE}?#{C_CLAS}?|#{C_LNGE}?#{C_STYL}?#{C_CLAS}?)"

        # auto_link rule after textile rules so that it doesn't break !image_url! tags
        RULES = [:textile, :block_markdown_rule, :inline_auto_link, :inline_auto_mailto]

        def initialize(*args)
          super
          self.filter_html = Setting.plugin_redmine_redcloth['filter_html']
          self.sanitize_html = Setting.plugin_redmine_redcloth['sanitize_html']
          self.filter_styles= Setting.plugin_redmine_redcloth['filter_styles']
          self.filter_classes = Setting.plugin_redmine_redcloth['filter_classes']
          self.filter_ids = Setting.plugin_redmine_redcloth['filter_ids']
          self.hard_breaks = Setting.plugin_redmine_redcloth['hard_breaks']
          self.lite_mode = Setting.plugin_redmine_redcloth['lite_mode']
          self.no_span_caps= Setting.plugin_redmine_redcloth['no_span_caps']
        end

        def to_html(*rules)
          @toc = []
          super(*RULES).to_s
        end

        def get_section(index)
          section = extract_sections(index)[1]
          hash = Digest::MD5.hexdigest(section)
          return section, hash
        end

        def update_section(index, update, hash=nil)
          t = extract_sections(index)
          if hash.present? && hash != Digest::MD5.hexdigest(t[1])
            raise Redmine::WikiFormatting::StaleSectionError
          end
          t[1] = update unless t[1].blank?
          t.reject(&:blank?).join "\n\n"
        end

        def extract_sections(index)
          @pre_list = []
          text = self.dup
          # rip_offtags text, false, false
          before = ''
          s = ''
          after = ''
          i = 0
          l = 1
          started = false
          ended = false
          text.scan(/(((?:.*?)(\A|\r?\n\s*\r?\n))(h(\d+)(#{A}#{C})\.(?::(\S+))?[ \t](.*?)$)|.*)/m).each do |all, content, lf, heading, level|
            if heading.nil?
              if ended
                after << all
              elsif started
                s << all
              else
                before << all
              end
              break
            end
            i += 1
            if ended
              after << all
            elsif i == index
              l = level.to_i
              before << content
              s << heading
              started = true
            elsif i > index
              s << content
              if level.to_i > l
                s << heading
              else
                after << heading
                ended = true
              end
            else
              before << all
            end
          end
          sections = [before.strip, s.strip, after.strip]
          # sections.each {|section| smooth_offtags section}
          sections
        end
    end
end
