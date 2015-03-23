require "nokogiri"

module Postino
  class LinkRenamer

    def self.convert(html, url_prefix="")
      content = Nokogiri::HTML(html)
      content.css("a").each do |link|
        val = link.attributes["href"].value
        link.attributes["href"].value = self.rename_link(val, url_prefix)
      end

      #content.css("div").each do |node|
      #  if node.content !~ /\A\s*\Z/
      #    node.replace(content.create_element('p', node.inner_html.html_safe))
      #  end
      #end

      content.css('div.mojoMcContainerEmptyMessage').remove

      #make sure nokogiri does not rips off my mustaches
      content.to_html.gsub("%7B%7B", "{{").gsub("%7D%7D", "}}")
    end

    def self.rename_link(value, url_prefix)
      "#{url_prefix}" + value
    end

  end
end
