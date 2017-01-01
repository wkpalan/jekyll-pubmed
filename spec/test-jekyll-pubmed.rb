require "spec_helper"

describe Jekyll::Jekyll_Pubmed do
  let(:site) { make_site }
  before { site.process }

  context "full page rendering" do
    let(:content) { File.read(dest_dir("page.html")) }

    it "builds javascript" do
      expect(content).to match(%r!#{Jekyll::Maps::GoogleMapTag::JS_LIB_NAME}!)
    end

    it "includes external js only once" do
      expect(content.scan(%r!maps\.googleapis\.com!).length).to eq(1)
    end

    it "renders API key" do
      expect(content).to match(%r!maps/api/js\?key=GOOGLE_MAPS_API_KEY!)
    end
  end
end
