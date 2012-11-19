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

  %w(user service role host).each do |model|
    describe "##{model}_path" do
      context 'when path only contains url-safe chars' do
        let(model.to_sym) { build(model.to_sym, name: 'name') }
        it { expect(__send__("#{model}_path", __send__(model))).to be == "/#{model}s/name" }
      end

      context 'when path only contains url-unsafe chars' do
        let(model.to_sym) { build(model.to_sym, name: 'name%') }
        it { expect(__send__("#{model}_path", __send__(model))).to be == "/#{model}s/name%25" }
      end
    end
  end
end
