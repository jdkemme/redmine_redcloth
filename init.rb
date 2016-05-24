require 'redmine'
require 'redmine_redcloth/post_process'

Redmine::Plugin.register :redmine_redcloth do
  name 'Redmine Redcloth plugin'
  author 'Jacob Kemme'
  description 'This is a Redcloth4x plugin for Redmine'
  version '0.0.1'
  requires_redmine :version_or_higher => '3.0.0'
  url 'https://github.com/jdkemme/redmine_redcloth'

  settings :partial => 'settings/redmine_redcloth_settings',
    :default => { 
      filter_html: true,
      sanitize_html: false, 
      filter_styles: false, 
      filter_classes: false,
      filter_ids: false,
      hard_breaks: true,
      lite_mode: false,
      no_span_caps: true
      } 

  wiki_format_provider 'Redcloth 4', RedmineRedcloth::Formatter, Redmine::WikiFormatting::Textile::Helper
end