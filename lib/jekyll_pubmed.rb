require "listless/version"

require 'json'
require 'hash-joiner'
require 'open-uri'
require 'crack'
require 'pp'

module Jekyll_Get
  class Generator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      config = site.config['jekyll_get']
      if !config
        return
      end
      if !config.kind_of?(Array)
        config = [config]
      end
      config.each do |d|
        begin
          target = site.data[d['data']]
          source = JSON.load(open(d['json']))
          if target
            HashJoiner.deep_merge target, source
          else
            site.data[d['data']] = source
          end
          if d['data'] == "publications"
            pub_ids = source["esearchresult"]["idlist"]
            #site.data["abstracts"] = @pub_ids
            id_var = pub_ids.join(",")
            esummary_url="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=#{id_var}&retmode=xml"
            #doc = Nokogiri::XML(open(esummary_url))
            doc = Crack::XML.parse(open(esummary_url))
            site.data["abstracts"] = make_pubmed_json(doc)
            #.PubmedArticle.MedlineCitation.Article.Journal.JournalIssue.PubDate.Year
          end
          if d['cache']
            data_source = (site.config['data_source'] || '_data')
            path = "#{data_source}/#{d['data']}.json"
            open(path, 'wb') do |file|
              file << JSON.generate(site.data[d['data']])
            end
          end
        rescue
          next
        end
      end
    end
    def make_pubmed_json(doc)
      h = Hash.new
      sorted_pmid = Hash.new
      years = Array.new
      #puts "Hello World #{doc}"
      doc["PubmedArticleSet"].each do |key,array|
        puts "#{key}---"
        array.each do |array2|
          year = array2["MedlineCitation"]["Article"]["Journal"]["JournalIssue"]["PubDate"]["Year"]
          month = array2["MedlineCitation"]["Article"]["Journal"]["JournalIssue"]["PubDate"]["Month"]
          date = array2["MedlineCitation"]["Article"]["Journal"]["JournalIssue"]["PubDate"]["Day"]
          pub_date = Time.new(year,month,date)

          pmid = array2["MedlineCitation"]["PMID"]
          authors = Array.new
          array2["MedlineCitation"]["Article"]["AuthorList"]["Author"].each do |author|
            authors = authors << author["LastName"] + " " + author["Initials"]
          end

          journal = array2["MedlineCitation"]["Article"]["Journal"]["ISOAbbreviation"]

          aritcle_title = array2["MedlineCitation"]["Article"]["ArticleTitle"]
          article_abstract = array2["MedlineCitation"]["Article"]["Abstract"]["AbstractText"]
          #puts article_abstract

          #tmp_record[pmid] = Hash.new

          tmp_record = {"pub_date" => pub_date, "authors" => authors, "journal" => journal, "title"=>aritcle_title, "abstract"=>article_abstract}
          sorted_pmid[pub_date] = pmid
          h["#{pmid}"] = tmp_record
          years = years << year
         #pp tmp_record
        end
      end
      sorted_pmid =  sorted_pmid.sort.reverse.to_h
      sorted_years = years.uniq.sort.reverse.to_a
      #return doc["PubmedArticleSet"]
      out_hash =  {"pmids" => sorted_pmid, "articles" => h, "years" => sorted_years}
      pp out_hash
      return out_hash
    end
  end
end
