require "spec_helper"

describe Jekyll_Pubmed do
  let(:overrides) { Hash.new }
  let(:config) do
    Jekyll.configuration(Jekyll::Utils.deep_merge_hashes({
      "full_rebuild" => true,
      "source"      => source_dir,
      "destination" => dest_dir,
      "url"         => "http://example.org",
      "name"       => "My awesome site",
      "author"      => {
        "name"        => "Dr. Jekyll"
      },
      "collections" => {
        "my_collection" => { "output" => true },
        "other_things"  => { "output" => false }
      },
      "jekyll_pubmed" => {
        "data" => "publications",
        "term" => "Wimalanathan K"
      }
    }, overrides))
  end
  let(:site)     { Jekyll::Site.new(config) }
  let(:context)  { make_context(site: site) }
  before(:each) do
    site.process
  end
  it "creates publications" do
    expect(Pathname.new(dest_dir("publications/index.html"))).to exist
  end


end
