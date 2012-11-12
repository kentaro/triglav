require 'spec_helper'

describe ApplicationHelper do
  describe '#markdown' do
    it 'should convert text from markdown to html' do
      markdown_text = <<-EOF.strip_heredoc
        # Title

        - foo
        - bar

        hoge
      EOF

      html_text = <<-EOF.strip_heredoc
        <h1>Title</h1>

        <ul>
        <li>foo</li>
        <li>bar</li>
        </ul>


        <p>hoge</p>
      EOF

      expect(helper.markdown(markdown_text)).to be == html_text.chomp
    end
  end

  describe '#datetime_ago' do
    it 'should return localized string as "XXX ago"' do
      expect(helper.datetime_ago(Time.now)).to be == 'less than a minute ago'
    end
  end
end
