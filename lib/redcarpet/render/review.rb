module Redcarpet
  module Render
    class ReVIEW < Base

      def initialize(render_extensions)
        super()
        @table_num = 0
        @table_id_prefix = "tbl"
        @header_offset = 0
        if render_extensions[:header_offset]
          @header_offset = render_extensions[:header_offset]
        end
      end

      def normal_text(text)
        text
      end

      def escape_inline(text)
        text.gsub(/\}/){'\\}'}
      end

      def escape_href(text)
        text.gsub(/,/){'\\,'}
      end

      def block_code(code, language)
        code_text = normal_text(code).chomp
        lang = ""
        if language
          lang = "#\@# lang: #{language}\n"
        end
        "\n#{lang}//emlist{\n#{code_text}\n//}\n"
      end

      def block_quote(quote)
        quote_text = normal_text(quote).chomp
        quote_text.gsub!(/\A\n\n/,'')
        "\n//quote{\n#{quote_text}\n//}\n"
      end

      def block_html(raw_html)
        html_text = raw_html.chomp
        warning = "XXX: BLOCK_HTML: YOU SHOULD REWRITE IT"
        "\n//emlist{\n#{warning}\n#{html_text}\n//}\n"
      end

      def hrule
        "\n//hr\n"
      end

      def codespan(code)
        "@<tt>{#{escape_inline(code)}}"
      end

      def header(title, level)
        l = level - @header_offset
        case l
        when 1
          "\n= #{title}\n"
        when 2
          "\n== #{title}\n"
        when 3
          "\n=== #{title}\n"
        when 4
          "\n==== #{title}\n"
        end
      end

      def table(header, body)
        @sep = nil
        header_text = ""
        if header
          header_text = "#{header}-----------------\n"
        end
        body.chomp!
        "//table[#{table_id()}][]{\n#{header_text}#{body}\n//}\n"
      end

      def table_row(content)
        @sep = nil
        content+"\n"
      end

      def table_cell(content, alignment)
        sep = @sep
        @sep = "\t"
        "#{sep}#{content}"
      end

      def image(link, title, alt_text)
        filename = File.basename(link,".*")
        "//image[#{filename}][#{alt_text}]{\n//}"
      end

      def autolink(link, link_type)
        "@<href>{#{escape_href(link)}}"
      end

      def link(link, title, content)
        "@<href>{#{escape_href(link)},#{escape_inline(content)}}"
      end

      def double_emphasis(text)
        "@<strong>{#{escape_inline(text)}}"
      end

      def emphasis(text)
        "@<b>{#{escape_inline(text)}}"
      end

      def strikethrough(text)
        "@<del>{#{escape_inline(text)}}"
      end

      def linebreak
        "@<br>{}\n"
      end

      def paragraph(text)
        "\n\n#{text}\n"
      end

      def list(content, list_type)
        case list_type
        when :ordered
          "\n#{content}\n"
        when :unordered
          "\n#{content}\n"
        end
      end

      def list_item(content, list_type)
        case list_type
        when :ordered
          " 1. #{content.strip}\n"
        when :unordered
          " * #{content.strip}\n"
        end
      end

      def table_id()
        @table_num += 1
        "#{@table_id_prefix}#{@table_num}"
      end

    end
  end
end
